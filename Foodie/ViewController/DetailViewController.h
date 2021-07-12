//
//  DetailViewController.h
//  Foodie
//
//  Created by Eva Xie on 7/9/21.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController
@property (nonatomic, strong) Restaurant *restaurant;

@end

NS_ASSUME_NONNULL_END
