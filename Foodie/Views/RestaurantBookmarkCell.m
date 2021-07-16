//
//  RestaurantBookmarkCell.m
//  Foodie
//
//  Created by Eva Xie on 7/15/21.
//

#import "RestaurantBookmarkCell.h"
#import "RestaurantDetail.h"
#import "UIImageView+AFNetworking.h"

@implementation RestaurantBookmarkCell

- (void) setRestaurant:(RestaurantDetail *)restaurantDetail{
    _restaurantDetail = restaurantDetail;
    self.cardName.text = self.restaurantDetail.name;
    self.cardPoster.image = nil;
    if (self.restaurantDetail.imageURL != nil){
        [self.cardPoster setImageWithURL:self.restaurantDetail.imageURL];
    }
}

@end
