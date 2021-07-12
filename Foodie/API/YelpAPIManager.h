//
//  YelpAPIManager.h
//  Foodie
//
//  Created by Eva Xie on 7/9/21.
//
#import "Restaurant.h"
#import "RestaurantDetail.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YelpAPIManager : NSObject
- (void)getYelpRestaurantCompletion:(void(^)(NSArray *restaurants, NSError *error))completion;
- (void)getRestaurantDetail:(Restaurant *)restaurant completion:(void (^)(RestaurantDetail *restautantDetail, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
