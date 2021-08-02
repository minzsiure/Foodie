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

extern NSMutableArray *sessionArr;
NSMutableArray *sessionArr;

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
            NSArray *dictionaries = responseDictionary[@"businesses"];
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
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
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
    }];
    NSURLSessionDataTask *lastSession;
    
    if (sessionArr == nil){
        sessionArr = [[NSMutableArray alloc] init];
    }
    else{
        lastSession = [sessionArr objectAtIndex:0];
    }
    
    if (lastSession != nil){
        for (int i = 0; i < sessionArr.count; i++){
            [sessionArr[0] cancel];
            [sessionArr removeObjectAtIndex:0];
        }
    }
    [sessionArr insertObject:task atIndex:0];
    
    [task resume];
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
        }] resume];
    }
    completion(restaurantDetailArray, nil);
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
