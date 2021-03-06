//
//  MapViewController.h
//  Foodie
//
//  Created by Eva Xie on 7/13/21.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface MapViewController : UIViewController
@property (nonatomic, strong) NSArray *restaurantDictionaries;
@property (strong, nonatomic) NSString *detailLatitude;
@property (strong, nonatomic) NSString *detailLongitude;

@end

NS_ASSUME_NONNULL_END
