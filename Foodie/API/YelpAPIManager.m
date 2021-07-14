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

@end

@implementation YelpAPIManager




- (void)getYelpRestaurantCompletion:(void(^)(NSArray *restaurants, NSError *error))completion{
    // get user current location
//    RestaurantViewController *lvc = [[RestaurantViewController alloc] init];
//    double latDouble = lvc.latitude;
//    double longDouble = lvc.longitude;
    PFUser *user = [PFUser currentUser];
    NSString *lat = user[@"latitude"];
    NSString *longt = user[@"longitude"];
    
    // assemble APIKey
    NSString *APIKey = @"28Yo8kD_K-RyBUR6gCWznPYoMh1ItVdboaEExmr9duOBklai0I21Ww6b-IHLW2ZJyn6Ohh70J_V-xP6Mxv1JV1V8HZ_9hljzdgqkMbouw6oRsY3f12VS0KL3LqHoYHYx";
//    NSURL *url = [NSURL URLWithString: @"https://api.yelp.com/v3/businesses/search?term=restaurant&latitude=42.360001&longitude=-71.0942"];
    NSString *baseURL =  @"https://api.yelp.com/v3/businesses/search?term=restaurant&latitude=";
    NSString *latURL = [baseURL stringByAppendingString:lat];
    NSString *longtURL = [latURL stringByAppendingString:@"&longitude="];
    NSString *urlString = [longtURL stringByAppendingString:longt];
    NSURL *url = [NSURL URLWithString:urlString];
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
            NSLog(@"YELP DATA FETCHED SUCCESS");
            NSArray *dictionaries = responseDictionary[@"businesses"];
            //NSLog(@"%@", dictionaries);
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

- (void)getRestaurantDetail:(Restaurant *)restaurant completion:(void (^)(RestaurantDetail *restautantDetail, NSError *error))completion {
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
            RestaurantDetail *restaurantDetail = [RestaurantDetail detailsWithDictionaries:responseDictionary];
            NSLog(@"%@", restaurantDetail.name);
            //completion(restaurantDetail, nil);
        }
        else{
            NSLog(@"ERROR %@", [error localizedDescription]);
            completion(nil, error);
        }
        
    }] resume];
}


@end
