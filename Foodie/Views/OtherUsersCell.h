//
//  OtherUsersCell.h
//  Foodie
//
//  Created by Eva Xie on 7/19/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OtherUsersCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userProfilePic;
@property (weak, nonatomic) NSString *userID;


@end

NS_ASSUME_NONNULL_END
