//
//  RestaurantCell.h
//  Foodie
//
//  Created by Eva Xie on 7/9/21.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"

NS_ASSUME_NONNULL_BEGIN

@interface RestaurantCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property(nonatomic, strong) Restaurant *restaurant;
@property (weak, nonatomic) IBOutlet UIButton *bookmarkLogo;
@property (weak, nonatomic) IBOutlet UILabel *ratingCategory;


@end

NS_ASSUME_NONNULL_END
