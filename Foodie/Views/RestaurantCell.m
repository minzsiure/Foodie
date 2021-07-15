//
//  RestaurantCell.m
//  Foodie
//
//  Created by Eva Xie on 7/9/21.
//

#import "RestaurantCell.h"
#import "Restaurant.h"
#import "UIImageView+AFNetworking.h"
#import <Parse/Parse.h>

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
    PFUser *currentUser = [PFUser currentUser];
    if ([currentUser[@"restaurants"] containsObject:self.restaurant.id]){
        [self.bookmarkLogo setImage:[UIImage imageNamed:@"bookmark_red_small"] forState:UIControlStateNormal];
    }
    else{
        [self.bookmarkLogo setImage:[UIImage imageNamed:@"bookmark_grey_small"] forState:UIControlStateNormal];
    }
}


@end
