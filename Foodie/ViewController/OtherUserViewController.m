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
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end

@implementation OtherUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.activityIndicator startAnimating];
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
    //Global queue get command
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
        //Create dispatch group
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
            // block1
            NSLog(@"Block1");
            YelpAPIManager *manager = [YelpAPIManager new];
            [manager getRestaurantDetailArray:(self.bookmarks) completion:^(NSMutableArray *restaurantDetailArray, NSError * error) {
                if (error) {
                    NSLog(@"it is failing here.");
                } else {
                    self.restaurantDetailArray = restaurantDetailArray;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update UI
                        [self.bookmarkCollectionView reloadData];
                    });
                }
            }];
            NSLog(@"Block1 End");
        });
        //Start dispatch group
        dispatch_group_enter(group);
        //Dont continue until group finished
        [self computeInBackground:1 completion:^{
            NSLog(@"1 done");
            dispatch_group_leave(group); // pair 1 leave
        }];
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        NSLog(@"finally!");
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI
            [self.bookmarkCollectionView reloadData];
            [self.activityIndicator stopAnimating];
        });
    });
}

- (void)computeInBackground:(int)no completion:(void (^)(void))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"%d starting", no);
        sleep(no*2);
        block();
    });
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
