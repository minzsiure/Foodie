//
//  Restaurant.m
//  Foodie
//
//  Created by Eva Xie on 7/9/21.
//

#import "Restaurant.h"

@implementation Restaurant

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    self.id = dictionary[@"id"];
    self.name = dictionary[@"name"];
    self.categories = dictionary[@"categories"];
    self.phone = dictionary[@"phone"];
    
    NSString *posterURLString = dictionary[@"image_url"];
    self.imageURL = [NSURL URLWithString:posterURLString];
    
    NSString *yelpURLString = dictionary[@"url"];
    self.yelpURL = [NSURL URLWithString:yelpURLString];

    self.location = dictionary[@"location"];
    self.latitude = dictionary[@"coordinates"][@"latitude"];
    self.longitude = dictionary[@"coordinates"][@"longitude"];

    double voteDouble = [(NSNumber *)  dictionary[@"rating"] doubleValue];
    NSString *voteString = [NSString stringWithFormat:@"%0.1f ",voteDouble];
    NSString *star = @"★";
    NSString *ratingString = [voteString stringByAppendingString:star];
    self.rating = ratingString;
    
    self.reviewCount = dictionary[@"reviewCount"];
    self.price = dictionary[@"price"];
    
    return self;
}

+ (NSMutableArray *)restaurantsWithDictionaries:(NSArray *)dictionaries {
    NSMutableArray *restaurants = [NSMutableArray array];
    
    // a factory method that returns Restaurants when initialized with an array of Restaurant Dictionaries.
    for (NSDictionary *dictionary in dictionaries) {
        Restaurant *restaurant = [[Restaurant alloc] initWithDictionary:dictionary];
        [restaurants addObject:restaurant];
    }
    
    return restaurants;
}




@end
