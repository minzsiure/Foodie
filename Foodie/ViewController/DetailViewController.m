//
//  DetailViewController.m
//  Foodie
//
//  Created by Eva Xie on 7/9/21.
//

#import "DetailViewController.h"
#import "RestaurantDetail.h"
#import "Restaurant.h"
#import "UIImageView+AFNetworking.h"
#import "YelpAPIManager.h"
#import "YelpViewController.h"
#import "OtherUsersCell.h"
#import <Parse/Parse.h>
#import "OtherUserViewController.h"
#import "MapViewController.h"

@interface DetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) NSDictionary *detailDictionary;
@property (strong, nonatomic) NSString *categoryString;
@property (strong, nonatomic) NSString *locString;
@property (weak, nonatomic) IBOutlet UICollectionView *otherUsersCollectionView;
@property(strong, nonatomic) NSArray *userArray;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *bookmarkButton;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.otherUsersCollectionView.dataSource = self;
    self.otherUsersCollectionView.delegate = self;
    self.imageScrollView.delegate = self;
    

    PFQuery *query = [PFQuery queryWithClassName:@"Restaurant"];
    // id is passed in from tableView, so we fetch API using /search{id} request;
    if (self.restaurant.id != nil){
        [self fetchRestaurantDetail];
        [query whereKey:@"restaurantID" equalTo:self.restaurant.id];
    }
    //otherwise from profile page, we will set up this page with passed-in restaurantDetail object (no restaurant.id)
    else{
        [query whereKey:@"restaurantID" equalTo:self.restaurantDetailObj.id];
        
    }
    PFObject *object = [query getFirstObject];
    self.userArray = object[@"userArray"];
}

- (void) scrollViewSetUp{
    NSArray *imageArray = [[NSArray alloc] initWithObjects:self.restaurantDetailObj.photoOne, self.restaurantDetailObj.photoTwo, self.restaurantDetailObj.photoThree, nil];
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat width = CGRectGetWidth(screen);
    [self.pageControl setNumberOfPages:imageArray.count];
    for (int i = 0; i < [imageArray count]; i++) {
        //We'll create an imageView object in every 'page' of our scrollView.
        CGRect frame;
        frame.origin.x = width * i;
        frame.origin.y = 0;
        frame.size = self.imageScrollView.frame.size;

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView setContentMode:UIViewContentModeScaleToFill];
        imageView.image = nil;
        [imageView setImageWithURL:[imageArray objectAtIndex:i]];
        [self.imageScrollView addSubview:imageView];
    }
    //Set the content size of our scrollview according to the total width of our imageView objects.
    
    self.imageScrollView.contentSize = CGSizeMake(width * [imageArray count], 170);
}

- (void)scrollViewDidScroll:(UIScrollView *)sender{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.imageScrollView.frame.size.width;
    int page = floor((self.imageScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}


- (void)viewDidAppear:(BOOL)animated{
    [self pageSetUp];
    [self scrollViewSetUp];
}

- (void) fetchRestaurantDetail{
    YelpAPIManager *manager = [YelpAPIManager new];
    [manager getRestaurantDetail:(self.restaurant.id) completion:^(NSDictionary * restaurantDetail, NSError *error) {
        self.restaurantDetailObj = [RestaurantDetail detailsWithDictionaries:restaurantDetail];
        dispatch_async(dispatch_get_main_queue(), ^(void){
        });
    }];
}

- (IBAction)onTapBookmark:(id)sender {
    UIButton *btn = (UIButton *)sender;
    PFUser *currentUser = [PFUser currentUser];
//    if currentUser did not bookmark, then add the restaurantID to their bookmark;
    if (!([currentUser[@"restaurants"] containsObject:self.restaurantDetailObj.id])){
        [currentUser addObject:self.restaurantDetailObj.id forKey:@"restaurants"];
        [currentUser saveInBackground];
        [btn setImage:[UIImage systemImageNamed:@"bookmark.fill"] forState:UIControlStateNormal];
    }
//    else, do the opposite
    else{
        [currentUser removeObject:self.restaurantDetailObj.id forKey:@"restaurants"];
        [currentUser saveInBackground];
        [btn setImage:[UIImage systemImageNamed:@"bookmark"] forState:UIControlStateNormal];
    }
    
    
    
}



- (void) pageSetUp{
    PFUser *currentUser = [PFUser currentUser];
    if (!([currentUser[@"restaurants"] containsObject:self.restaurantDetailObj.id])){
        [self.bookmarkButton setImage:[UIImage systemImageNamed:@"bookmark"] forState:UIControlStateNormal];
    }
    else{
        [self.bookmarkButton setImage:[UIImage systemImageNamed:@"bookmark.fill"] forState:UIControlStateNormal];
    }
    
    self.nameLabel.text = self.restaurantDetailObj.name;
    self.ratingLabel.text = self.restaurantDetailObj.rating;
    
    //price (if any) + category
    NSArray *categoryArr = self.restaurantDetailObj.categories;
    NSMutableArray *newArray = [NSMutableArray new];
    for (NSDictionary *dic in categoryArr){
        [newArray addObject:dic[@"title"]];
    }
    NSString *categoryStr = [newArray componentsJoinedByString:@", "];
    if (self.restaurantDetailObj.price != nil){
        NSString *subRow = [self.restaurantDetailObj.price stringByAppendingString:@" • "];
        self.priceLabel.text = [subRow stringByAppendingString:categoryStr];
    }
    else{
        self.priceLabel.text = categoryStr;
    }

    //address
    NSArray *locArray = self.restaurantDetailObj.location[@"display_address"];
    self.addressLabel.text = [locArray componentsJoinedByString:@" "];
    
    //hour
    if (self.restaurantDetailObj.hours != nil && (self.restaurantDetailObj.hours.count == 7)){
        NSMutableArray *hourArray = [NSMutableArray array];
        NSArray *week = [NSArray arrayWithObjects:@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday", nil];
        for (int i = 0; i < 7; i++){
            //start
            NSString *dayString = [NSString stringWithFormat:@"%@ ",week[i]];
            NSString *startOne = [self.restaurantDetailObj.hours[i][@"start"] substringWithRange: NSMakeRange(0, 2)];
            NSString *startTwo = [self.restaurantDetailObj.hours[i][@"start"] substringFromIndex:2];
            NSString *startHour = [startOne stringByAppendingFormat:@":%@", startTwo];
            NSString *startResult = [dayString stringByAppendingString:startHour];
        
            //end
            NSString *endOne = [self.restaurantDetailObj.hours[i][@"end"] substringWithRange: NSMakeRange(0, 2)];
            NSString *endTwo = [self.restaurantDetailObj.hours[i][@"end"] substringFromIndex:2];
            NSString *endHour = [endOne stringByAppendingFormat:@":%@", endTwo];
            NSString *result = [startResult stringByAppendingFormat:@"-%@", endHour];
    
            [hourArray addObject:result];
        }
        self.hourLabel.text = [hourArray componentsJoinedByString:@"\n"];
    }
    else{
        self.hourLabel.text = @"Hours unavailable.";
    }
}

- (IBAction)onTapCall:(id)sender {
    NSString *phoneURL = [@"tel:" stringByAppendingString:self.restaurant.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneURL]];
}

- (IBAction)onTapLocation:(id)sender {
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"yelpSegue"]){
        YelpViewController *yelpViewController = [segue destinationViewController];
        yelpViewController.yelpURL = self.restaurant.yelpURL;
    }
    if ([segue.identifier isEqual:@"otherUserSegue"]){
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.otherUsersCollectionView indexPathForCell:tappedCell];
        OtherUserViewController *ouv = [segue destinationViewController];
        ouv.userID = self.userArray[indexPath.row];
    }
    if ([segue.identifier isEqual:@"detailMapSegue"]){
        MapViewController *mapViewController = [segue destinationViewController];
        mapViewController.restaurantDictionaries = self.restaurantDictionaries;
        mapViewController.detailLatitude = self.restaurantDetailObj.latitude;
        mapViewController.detailLongitude = self.restaurantDetailObj.longitude;
    }
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    OtherUsersCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OtherUserCell" forIndexPath:indexPath];
    PFUser *currentUser = [PFUser currentUser];
    // if current user did not bookmark OR current indexPath.row does not refer to current user, then proceed to load profile picture
    if (!([self.userArray containsObject:currentUser.objectId]) || self.userArray[indexPath.row] != currentUser.objectId){
        PFQuery *userQuery = [PFUser query];
        [userQuery whereKey:@"objectId" equalTo:self.userArray[indexPath.row]];
        PFUser *thisUser = [userQuery getFirstObject];
        cell.userID = thisUser[@"objectId"];
        cell.userProfilePic.image = nil;
        if (thisUser[@"profilePic"] != nil){
            PFFileObject *profilePic = thisUser[@"profilePic"];
            NSURL *profilePicURL = [NSURL URLWithString:profilePic.url];
            [cell.userProfilePic setImageWithURL:profilePicURL];
        }
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    PFUser *currentUser = [PFUser currentUser];
    if ([self.userArray containsObject:currentUser.objectId]){
        return self.userArray.count-1;
    }
    return self.userArray.count;
}

@end
