//
//  RestaurantDetail.h
//  Foodie
//
//  Created by Eva Xie on 7/12/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RestaurantDetail : NSObject
@property (nonatomic, strong) NSString *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSDictionary *location;
@property (strong, nonatomic) NSString *rating;
@property (strong, nonatomic) NSNumber *reviewCount;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSURL *photoOne;
@property (strong, nonatomic) NSURL *photoTwo;
@property (strong, nonatomic) NSURL *photoThree;
@property (strong, nonatomic) NSArray *hours;


- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSMutableArray *)detailsWithDictionaries:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
