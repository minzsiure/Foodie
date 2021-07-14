//
//  RestaurantViewController.m
//  Foodie
//
//  Created by Eva Xie on 7/9/21.
//

#import "RestaurantViewController.h"
#import "RestaurantCell.h"
#import "UIImageView+AFNetworking.h"
#import "Restaurant.h"
#import "RestaurantDetail.h"
#import "YelpAPIManager.h"
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import "LoginViewController.h"
#import "DetailViewController.h"
#import "MapViewController.h"

@interface RestaurantViewController () <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *restaurantTable;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *restaurants;
@property (strong, nonatomic) NSArray *restaurantDetail;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation RestaurantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.restaurantTable.delegate = self;
    self.restaurantTable.dataSource = self;
    [self accessCurrentLocation];
    
}

- (void) accessCurrentLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
     {
             CLLocation *location = [locations lastObject];
              //First, checking if the location services are enabled
             self.latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
             self.longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
                NSLog(@"restaurant view controller said lat%@ - lon%@", self.latitude, self.longitude);
            [self fetchRestaurants];
            [self.locationManager stopUpdatingLocation];
                  
            //refresh controller
            self.refreshControl = [[UIRefreshControl alloc] init];
            [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
            [self.restaurantTable insertSubview:self.refreshControl atIndex:0];
    }

- (void) beginRefresh:(UIRefreshControl *)refreshControl{
    [self fetchRestaurants];
}

- (void) fetchRestaurants{
    YelpAPIManager *manager = [YelpAPIManager new];
    [manager getYelpRestaurantCompletion:self.latitude forLongt:self.longitude completion:^(NSArray *restaurants, NSError *error) {
        if (restaurants){
            self.restaurants = restaurants;
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self.restaurantTable reloadData];
                [self.refreshControl endRefreshing];
            });
            
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
        
    }];
}

- (IBAction)logOut:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [[UIApplication sharedApplication].keyWindow setRootViewController: loginViewController];
        
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"detailSegue"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.restaurantTable indexPathForCell:tappedCell];
        Restaurant *restaurant = self.restaurants[indexPath.row];
    
        DetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.restaurant = restaurant;
    }
    if ([segue.identifier isEqual:@"mapSegue"]){
        
        MapViewController *mapViewController = [segue destinationViewController];
        mapViewController.restaurantDictionaries = self.restaurants;
    }

}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RestaurantCell"];
    cell.restaurant = self.restaurants[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.restaurants.count;
}

// swipe to bookmark
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIContextualAction *bookmark = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        PFUser *currentUser = [PFUser currentUser];
        Restaurant *restaurant = self.restaurants[indexPath.row];
        
        //if currentUser did not bookmark, then add the restaurantID to their bookmark; else, do nothing
        if (!([currentUser[@"restaurants"] containsObject:restaurant.id])){
            [currentUser addObject:restaurant.id forKey:@"restaurants"];
        }

        [currentUser saveInBackground];
        completionHandler(true);
        
        
    }];
    
    // UI Design
    bookmark.image  = [UIImage imageNamed:@"bookmark"];
    bookmark.backgroundColor = [UIColor colorWithRed:228.0f/255.0f
                                              green:78.0f/255.0f
                                               blue:45.0f/255.0f
                                              alpha:1.0f];
    bookmark.title = @"Bookmark";
    
    UISwipeActionsConfiguration *actions = [UISwipeActionsConfiguration configurationWithActions:[[NSArray alloc] initWithObjects:bookmark, nil]];
    
    return actions;
}


@end
