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
    
    [self fetchRestaurants];
    //[self accessCurrentLocation];
    [self.restaurantTable reloadData];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    //refresh controller
    [self.refreshControl addTarget:self action:@selector(fetchRestaurants) forControlEvents:UIControlEventValueChanged];
    [self.restaurantTable insertSubview:self.refreshControl atIndex:0];
    [self.restaurantTable addSubview:self.refreshControl];
}

- (void) loadViewIfNeeded{
    
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
        
         _latitude = location.coordinate.latitude;
         _longitude = location.coordinate.longitude;
         NSLog(@"lat%f - lon%f", self.latitude, self.longitude);
        
        [self.locationManager stopUpdatingLocation];
         
    }

- (void) fetchRestaurants{
    
    YelpAPIManager *manager = [YelpAPIManager new];
    [manager getYelpRestaurantCompletion:^(NSArray *restaurants, NSError *error){
        self.restaurants = restaurants;
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
    return 20;
}


@end
