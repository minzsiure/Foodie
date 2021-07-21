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
#import <MaterialPageControl.h>

@interface DetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
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
//var frame = CGRect.zero
@property (nonatomic) CGRect frame;


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
    // page controller
    NSArray *imageArray = [[NSArray alloc] initWithObjects:self.restaurantDetailObj.photoOne, self.restaurantDetailObj.photoTwo, self.restaurantDetailObj.photoThree, nil];
    [self.pageControl setNumberOfPages:imageArray.count];
    for (int i = 0; i < [imageArray count]; i++) {
    //We'll create an imageView object in every 'page' of our scrollView.
    CGRect frame;
    frame.origin.x = 390 * i;
    frame.origin.y = 0;
    frame.size = self.imageScrollView.frame.size;

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    imageView.image = nil;
    [imageView setImageWithURL:[imageArray objectAtIndex:i]];
    [self.imageScrollView addSubview:imageView];
    }
    //Set the content size of our scrollview according to the total width of our imageView objects.
    self.imageScrollView.contentSize = CGSizeMake(390 * [imageArray count], 170);
}

- (void)scrollViewDidScroll:(UIScrollView *)sender{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.imageScrollView.frame.size.width;
    int page = floor((self.imageScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}


- (void)viewDidAppear:(BOOL)animated{
    [self pageSetUp];
}

- (void) fetchRestaurantDetail{
    YelpAPIManager *manager = [YelpAPIManager new];
    [manager getRestaurantDetail:(self.restaurant.id) completion:^(NSDictionary * restaurantDetail, NSError *error) {
        self.restaurantDetailObj = [RestaurantDetail detailsWithDictionaries:restaurantDetail];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self scrollViewSetUp];
        });
    }];
    
}


- (void) pageSetUp{
    self.posterImage.image = nil;
    if (self.restaurantDetailObj.imageURL != nil){
        [self.posterImage setImageWithURL:self.restaurantDetailObj.imageURL];
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
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    OtherUsersCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OtherUserCell" forIndexPath:indexPath];
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"objectId" equalTo:self.userArray[indexPath.row]]; // find all the women
    PFUser *thisUser = [userQuery getFirstObject];
    cell.userID = thisUser[@"objectId"];
    cell.userProfilePic.image = nil;
    if (thisUser[@"profilePic"] != nil){
        PFFileObject *profilePic = thisUser[@"profilePic"];
        NSURL *profilePicURL = [NSURL URLWithString:profilePic.url];
        [cell.userProfilePic setImageWithURL:profilePicURL];
    }
    
    
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userArray.count;
}

@end
