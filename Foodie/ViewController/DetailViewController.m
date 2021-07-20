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

@interface DetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) NSDictionary *detailDictionary;
@property (strong, nonatomic) NSString *categoryString;
@property (strong, nonatomic) NSString *locString;
@property (weak, nonatomic) IBOutlet UICollectionView *otherUsersCollectionView;
@property(strong, nonatomic) NSArray *userWhoLiked;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.otherUsersCollectionView.dataSource = self;
    self.otherUsersCollectionView.delegate = self;
    // id is passed in from tableView, so we fetch API using /search{id} request;
    //otherwise we will set up this page with passed-in restaurantDetail object (no restaurant.id)
    if (self.restaurant.id != nil){
        [self fetchRestaurantDetail];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [self pageSetUp];
}

- (void) fetchRestaurantDetail{
    YelpAPIManager *manager = [YelpAPIManager new];
    [manager getRestaurantDetail:(self.restaurant.id) completion:^(NSDictionary * restaurantDetail, NSError *error) {
        self.restaurantDetailObj = [RestaurantDetail detailsWithDictionaries:restaurantDetail];
        dispatch_async(dispatch_get_main_queue(), ^(void){
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
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

@end
