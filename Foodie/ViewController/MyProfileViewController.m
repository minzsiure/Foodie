//
//  MyProfileViewController.m
//  Foodie
//
//  Created by Eva Xie on 7/9/21.
//

#import "MyProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import <Parse/Parse.h>
#import "RestaurantBookmarkCell.h"
#import "YelpAPIManager.h"
#import "RestaurantDetail.h"
#import "DetailViewController.h"

@interface MyProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UIImage *resizedImage;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UICollectionView *bookmarkCollectionView;
@property (strong, nonatomic) NSArray *bookmarks; //array of IDs
@property (strong, nonatomic) NSArray *restaurantDetailArray; //array of RestaurantDetail Objects


@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shadowView.layer.shadowOpacity = 0.35;
    self.shadowView.layer.shadowOffset = CGSizeMake(0, -5);
    self.shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // get array of bookmarked restaurantID
    PFUser *currentUser = [PFUser currentUser];
    self.bookmarks = currentUser[@"restaurants"];
    NSLog(@"bookmarks%@", self.bookmarks);
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.bookmarkCollectionView addSubview:self.refreshControl];
    [self.bookmarkCollectionView setPagingEnabled:YES];
    self.bookmarkCollectionView.dataSource = self;
    self.bookmarkCollectionView.delegate = self;
    
    [self fetchBookmarks];
}

- (void) beginRefresh:(UIRefreshControl *)refreshControl{
    [self fetchBookmarks];
}

- (void)viewDidAppear:(BOOL)animated {
    PFUser *user = [PFUser currentUser];
    PFFileObject *profilePic = user[@"profilePic"];
    NSURL *profilePicURL = [NSURL URLWithString:profilePic.url];
    [self.profileImage setImageWithURL:profilePicURL];
    
    self.userName.text = user[@"username"];
}

- (IBAction)onTapEditProfilePic:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}


// Implement the delegate method
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    PFUser *user = [PFUser currentUser];
    
    
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    self.resizedImage = [self resizeImage:editedImage withSize:CGSizeMake(300, 300)];
    
    self.profileImage.image = self.resizedImage;
    if (self.profileImage.image != nil) {
        NSData *data = UIImagePNGRepresentation(self.profileImage.image);
        PFFileObject *photo = [PFFileObject fileObjectWithName:@"image.png" data:data];
        user[@"profilePic"] = photo;
    }
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"it worked!");
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BookmarkDetailSegue"]){
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.bookmarkCollectionView indexPathForCell:tappedCell];
        DetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.restaurantDetailObj = self.restaurantDetailArray[indexPath.row];
    }
}

- (void)computeInBackground:(int)no completion:(void (^)(void))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"%d starting", no);
        sleep(no*2);
        block();
    });
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
        });
    });
}


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
