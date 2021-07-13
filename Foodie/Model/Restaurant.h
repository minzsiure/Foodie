//
//  Restaurant.h
//  Foodie
//
//  Created by Eva Xie on 7/9/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Restaurant : NSObject

@property (nonatomic, strong) NSString *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSURL *yelpURL;
@property (strong, nonatomic) NSDictionary *location;
@property (strong, nonatomic) NSString *rating;
@property (strong, nonatomic) NSNumber *reviewCount;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *price;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)restaurantsWithDictionaries:(NSMutableArray *)dictionaries;


@end

NS_ASSUME_NONNULL_END
