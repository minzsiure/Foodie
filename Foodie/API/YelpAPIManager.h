//
//  YelpAPIManager.h
//  Foodie
//
//  Created by Eva Xie on 7/9/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YelpAPIManager : NSObject
- (void)getYelpRestaurantCompletion:(void(^)(NSArray *restaurants, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
