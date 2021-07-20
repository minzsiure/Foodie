//
//  RestaurantDetail.m
//  Foodie
//
//  Created by Eva Xie on 7/12/21.
//

#import "RestaurantDetail.h"
#import "Restaurant.h"

@implementation RestaurantDetail


- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    self.id = dictionary[@"id"];
    self.name = dictionary[@"name"];
    self.categories = dictionary[@"categories"];
    self.phone = dictionary[@"phone"];
    
    NSString *posterURLString = dictionary[@"image_url"];
    NSURL *posterURL = [NSURL URLWithString:posterURLString];
    self.imageURL = posterURL;
    
    self.location = dictionary[@"location"];
    
    double voteDouble = [(NSNumber *)  dictionary[@"rating"] doubleValue];
    NSString *voteString = [NSString stringWithFormat:@" %0.1f ",voteDouble];
    NSString *star = @"★";
    NSString *ratingString = [voteString stringByAppendingString:star];
    self.rating = ratingString;
    
    self.reviewCount = dictionary[@"reviewCount"];
    self.price = dictionary[@"price"];
    
    NSArray *photos = dictionary[@"photos"];
    self.photoOne = [NSURL URLWithString:photos[0]];
    self.photoTwo = [NSURL URLWithString:photos[1]];
    self.photoThree = [NSURL URLWithString:photos[2]];
    
    self.hours = dictionary[@"hours"];
    
    return self;
}

+ (RestaurantDetail *)detailsWithDictionaries:(NSDictionary *)dictionary {
    // a factory method that returns Restaurants when initialized with an array of Restaurant Dictionaries.
    RestaurantDetail *restaurantDetail = [[RestaurantDetail alloc] initWithDictionary:dictionary];
    
    return restaurantDetail;
}

@end

