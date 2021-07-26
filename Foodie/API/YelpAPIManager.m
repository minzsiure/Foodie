//
//  YelpAPIManager.m
//  Foodie
//
//  Created by Eva Xie on 7/9/21.
//

#import "YelpAPIManager.h"
#import "LoginViewController.h"
#import "RestaurantViewController.h"
#import "Restaurant.h"
#import <YelpAPI/YelpAPI.h>
#import <Parse/Parse.h>

@interface YelpAPIManager() 

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSString *YelpAPIKey;

@end

@implementation YelpAPIManager

- (id)init {
    self = [super init];
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    self.YelpAPIKey = [dict objectForKey: @"YelpAPIKey"];
    return self;
}


- (void)getYelpRestaurantCompletion: (NSString *)lat forLongt: (NSString *)longt forLimit: (NSString *)limit forOffset: (NSString *)offset completion:(void(^)(NSArray *restaurants, NSError *error))completion{
    // https://api.yelp.com/v3/businesses/search?term=delis&latitude=37.786882&longitude=-122.399972&limit=20&offset=20
    
    NSString *baseURL =  @"https://api.yelp.com/v3/businesses/search?term=restaurant&latitude=";
    //location
    NSString *latURL = [baseURL stringByAppendingString:lat];
    NSString *longtURL = [latURL stringByAppendingString:@"&longitude="];
    NSString *urlString = [longtURL stringByAppendingString:longt];
    
    //limit, offset for infinite scroll; default is 20 and 0
    NSString *limitString = [urlString stringByAppendingString:@"&limit="];
    NSString *limitVal = [limitString stringByAppendingString:limit];
    NSString *offsetString = [limitVal stringByAppendingString:@"&offset="];
    NSString *offsetVal = [offsetString stringByAppendingString:offset];
    
    
    NSURL *url = [NSURL URLWithString:offsetVal];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    

    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSString *authValue = [NSString stringWithFormat:@"Bearer %@", self.YelpAPIKey];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];

    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request
             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"YELP DATA FETCHED SUCCESS");
            NSArray *dictionaries = responseDictionary[@"businesses"];
            
            // this is for testing location manager
//            NSLog(@"at API %@, %@", lat, longt);
            NSArray *restaurants = [Restaurant restaurantsWithDictionaries:dictionaries];
            completion(restaurants, nil);
            
        }
        else{
            NSLog(@"ERROR %@", [error localizedDescription]);
            completion(nil, error);
        }
        
    }] resume];
}

- (void) getYelpAutocomplete:(NSString *)lat forLongt: (NSString *)longt forText: (NSString *)text completion:(void(^)(NSArray *restaurantIDs, NSError *error))completion{
// https://api.yelp.com/v3/autocomplete?text=lobster&latitude=42.376970&longitude=-71.102400
    NSString *APIKey = self.YelpAPIKey;
    NSString *textURL = [@"https://api.yelp.com/v3/autocomplete?text=" stringByAppendingString:text];
    NSString *locURL = [textURL stringByAppendingFormat:@"&latitude=%@&longitude=%@",lat, longt];
    NSURL *url = [NSURL URLWithString: locURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSString *authValue = [NSString stringWithFormat:@"Bearer %@", APIKey];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];

    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request
             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"Restaurant Detail FETCHED SUCCESS");
            NSArray *restaurantDict = responseDictionary[@"businesses"];
            NSMutableArray *restaurantIDs = [NSMutableArray array];
            for (NSDictionary *arr in restaurantDict){
                [restaurantIDs addObject:arr[@"id"]];
            }
            completion(restaurantIDs, nil);
        }
        else{
            NSLog(@"ERROR %@", [error localizedDescription]);
            completion(nil, error);
        }
        
    }] resume];
}

- (void)getRestaurantDetail:(NSString *)restaurantID completion:(void (^)(NSDictionary *restaurantDetail, NSError *error))completion {
    NSString *APIKey = self.YelpAPIKey;
    NSString *baseURL = @"https://api.yelp.com/v3/businesses/";
    NSString *completeURL = [baseURL stringByAppendingString:restaurantID];
    NSURL *url = [NSURL URLWithString: completeURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSString *authValue = [NSString stringWithFormat:@"Bearer %@", APIKey];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];

    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request
             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"Restaurant Detail FETCHED SUCCESS");
            NSDictionary *restaurantDetail = responseDictionary;
            completion(restaurantDetail, nil);
        }
        else{
            NSLog(@"ERROR %@", [error localizedDescription]);
            completion(nil, error);
        }
        
    }] resume];
}

// takes in an array of ID, return an array of restaurantDetailObject
- (void)getRestaurantDetailArray:(NSArray *)restaurantIDArray completion:(void (^)(NSMutableArray *restaurantDetailArray, NSError *error))completion {
    NSString *APIKey = self.YelpAPIKey;
    NSString *baseURL = @"https://api.yelp.com/v3/businesses/";
    NSMutableArray *restaurantDetailArray = [NSMutableArray array];
    
    for (NSString *restaurantID in restaurantIDArray){
        NSString *completeURL = [baseURL stringByAppendingString:restaurantID];
        NSURL *url = [NSURL URLWithString: completeURL];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

        NSString *authValue = [NSString stringWithFormat:@"Bearer %@", APIKey];
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];

        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:request
             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            RestaurantDetail *restaurantDetail = [[RestaurantDetail alloc] initWithDictionary:responseDictionary];
            [restaurantDetailArray addObject:restaurantDetail];
            
        }
        completion(restaurantDetailArray, nil);
        }] resume];
    }
}

- (void)getRestaurantArray:(NSArray *)restaurantIDArray completion:(void (^)(NSMutableArray *restaurantArray, NSError *error))completion {
    NSString *APIKey = self.YelpAPIKey;
    NSString *baseURL = @"https://api.yelp.com/v3/businesses/";
    NSMutableArray *restaurantArray = [NSMutableArray array];
    
    for (NSString *restaurantID in restaurantIDArray){
        NSString *completeURL = [baseURL stringByAppendingString:restaurantID];
        NSURL *url = [NSURL URLWithString: completeURL];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

        NSString *authValue = [NSString stringWithFormat:@"Bearer %@", APIKey];
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];

        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:request
             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            Restaurant *restaurant = [[Restaurant alloc] initWithDictionary:responseDictionary];
            [restaurantArray addObject:restaurant];
            
        }
        completion(restaurantArray, nil);
        }] resume];
    }
}


@end
