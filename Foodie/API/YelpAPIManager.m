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


- (void)getYelpRestaurantCompletion: (NSString *)lat forLongt: (NSString *)longt completion:(void(^)(NSArray *restaurants, NSError *error))completion{
    

    NSString *baseURL =  @"https://api.yelp.com/v3/businesses/search?term=restaurant&latitude=";
    NSString *latURL = [baseURL stringByAppendingString:lat];
    NSString *longtURL = [latURL stringByAppendingString:@"&longitude="];
    NSString *urlString = [longtURL stringByAppendingString:longt];
    NSURL *url = [NSURL URLWithString:urlString];
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
            NSLog(@"at API %@, %@", lat, longt);
            
            NSArray *restaurants = [Restaurant restaurantsWithDictionaries:dictionaries];
            completion(restaurants, nil);
            
        }
        else{
            NSLog(@"ERROR %@", [error localizedDescription]);
            completion(nil, error);
        }
        
    }] resume];
}

- (void)getRestaurantDetail:(Restaurant *)restaurant completion:(void (^)(NSDictionary *restaurantDetail, NSError *error))completion {
    NSString *APIKey = @"28Yo8kD_K-RyBUR6gCWznPYoMh1ItVdboaEExmr9duOBklai0I21Ww6b-IHLW2ZJyn6Ohh70J_V-xP6Mxv1JV1V8HZ_9hljzdgqkMbouw6oRsY3f12VS0KL3LqHoYHYx";
    NSString *baseURL = @"https://api.yelp.com/v3/businesses/";
    NSString *completeURL = [baseURL stringByAppendingString:restaurant.id];
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
            NSLog(@"detail %@", restaurantDetail);
            completion(restaurantDetail, nil);
        }
        else{
            NSLog(@"ERROR %@", [error localizedDescription]);
            completion(nil, error);
        }
        
    }] resume];
}


@end
