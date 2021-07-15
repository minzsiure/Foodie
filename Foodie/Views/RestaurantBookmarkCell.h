//
//  RestaurantBookmarkCell.h
//  Foodie
//
//  Created by Eva Xie on 7/15/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RestaurantBookmarkCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cardPoster;
@property (weak, nonatomic) IBOutlet UILabel *cardName;

@end

NS_ASSUME_NONNULL_END
