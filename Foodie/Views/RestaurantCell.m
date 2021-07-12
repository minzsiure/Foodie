//
//  RestaurantCell.m
//  Foodie
//
//  Created by Eva Xie on 7/9/21.
//

#import "RestaurantCell.h"
#import "Restaurant.h"
#import "UIImageView+AFNetworking.h"

@implementation RestaurantCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setRestaurant:(Restaurant *)restaurant{
    _restaurant = restaurant;
    self.restaurantName.text = self.restaurant.name;
    self.posterImage.image = nil;
    if (self.restaurant.imageURL != nil){
        [self.posterImage setImageWithURL:self.restaurant.imageURL];
    }
}

@end
