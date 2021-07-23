//
//  DetailViewController.h
//  Foodie
//
//  Created by Eva Xie on 7/9/21.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
#import "RestaurantDetail.h"


NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController
@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, strong) RestaurantDetail *restaurantDetailObj;
@property (nonatomic, strong) NSArray *restaurantDictionaries;


@end

NS_ASSUME_NONNULL_END
