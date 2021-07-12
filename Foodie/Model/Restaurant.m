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
    NSURL *posterURL = [NSURL URLWithString:posterURLString];
    self.imageURL = posterURL;
    self.location = dictionary[@"location"];
    self.rating =  dictionary[@"rating"];
    self.ratingURL = dictionary[@"ratingURL"];
    self.reviewCount = dictionary[@"reviewCount"];
    self.snippetImageURL = dictionary[@"snippetImageURL"];
    self.snippet = dictionary[@"snippet"];
    
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
