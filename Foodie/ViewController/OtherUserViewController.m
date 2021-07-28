//
//  OtherUserViewController.m
//  Foodie
//
//  Created by Eva Xie on 7/21/21.
//
#import <Parse/Parse.h>
#import "OtherUserViewController.h"
#import "YelpAPIManager.h"
#import "UIImageView+AFNetworking.h"
#import "RestaurantBookmarkCell.h"

@interface OtherUserViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UICollectionView *bookmarkCollectionView;
@property (strong, nonatomic) UIImage *resizedImage;
@property (strong, nonatomic) NSArray *bookmarks; //array of IDs
@property (strong, nonatomic) NSArray *restaurantDetailArray; //array of RestaurantDetail Objects


@end

@implementation OtherUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shadowView.layer.shadowOpacity = 0.35;
    self.shadowView.layer.shadowOffset = CGSizeMake(0, -5);
    self.shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // get array of bookmarked restaurantID
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"objectId" equalTo:self.userID];
    PFUser *thisUser = [userQuery getFirstObject];
    
    self.bookmarks = thisUser[@"restaurants"];
    [self.bookmarkCollectionView setPagingEnabled:YES];
    self.bookmarkCollectionView.dataSource = self;
    self.bookmarkCollectionView.delegate = self;

    [self fetchBookmarks];
}

- (void) fetchBookmarks{
    YelpAPIManager *manager = [YelpAPIManager new];
    [manager getRestaurantDetailArray:(self.bookmarks) completion:^(NSMutableArray *restaurantDetailArray, NSError * error) {
        self.restaurantDetailArray = restaurantDetailArray;
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.bookmarkCollectionView reloadData];
        });
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"objectId" equalTo:self.userID];
    PFUser *thisUser = [userQuery getFirstObject];
    PFFileObject *profilePic = thisUser[@"profilePic"];
    NSURL *profilePicURL = [NSURL URLWithString:profilePic.url];
    [self.profileImage setImageWithURL:profilePicURL];
    
    self.userName.text = thisUser[@"username"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RestaurantBookmarkCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RestaurantBookmarkCell" forIndexPath:indexPath];
    // only load when API request is fully complete
    if (self.restaurantDetailArray.count == self.bookmarks.count){
        RestaurantDetail *obj = self.restaurantDetailArray[indexPath.row];
        cell.cardName.text = obj.name;
        cell.cardPoster.image = nil;
        cell.restaurantID = obj.id;
        if (obj.imageURL != nil){
            [cell.cardPoster setImageWithURL:obj.imageURL];
        }
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bookmarks.count;
}

@end
