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
#import "HHPullToRefreshWave.h"

@interface RestaurantViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *restaurantTable;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *restaurants;
@property (strong, nonatomic) NSArray *restaurantDetail;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *filteredData;

@end

@implementation RestaurantViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.activityIndicator startAnimating];
    
    // for simulator
    self.latitude = @"42.376970";
    self.longitude = @"-71.102400";
    PFUser *user = [PFUser currentUser];
    user[@"latitude"] = self.latitude;
    user[@"longitude"] = self.longitude;
    [self fetchRestaurants];
    //
    
    self.restaurantTable.delegate = self;
    self.restaurantTable.dataSource = self;
    self.searchBar.delegate = self;
//    [self accessCurrentLocation];// <- this is for real phone
    
    //refresh controller
    self.restaurantTable.backgroundColor = [UIColor colorWithRed:57/255.0 green:67/255.0 blue:89/255.0 alpha:1];
    [self.restaurantTable hh_addRefreshViewWithActionHandler:^{
        [self fetchRestaurants];
    }];
    [self.restaurantTable hh_setRefreshViewTopWaveFillColor:[UIColor lightGrayColor]];
    [self.restaurantTable hh_setRefreshViewBottomWaveFillColor:[UIColor whiteColor]];
    
}

- (void) viewDidAppear:(BOOL)animated{
    [self fetchRestaurants];
    [self.restaurantTable reloadData];
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
         
        PFUser *user = [PFUser currentUser];
        user[@"latitude"] = self.latitude;
        user[@"longitude"] = self.longitude;
        [self fetchRestaurants];
        [self.locationManager stopUpdatingLocation];
    }

- (void) beginRefresh:(UIRefreshControl *)refreshControl{
    [self fetchRestaurants];
}

- (void) fetchRestaurants{
    [self.activityIndicator startAnimating];
    PFUser *user = [PFUser currentUser];
    self.latitude = user[@"latitude"];
    self.longitude = user[@"longitude"];
    YelpAPIManager *manager = [YelpAPIManager new];
    [manager getYelpRestaurantCompletion:self.latitude forLongt:self.longitude forLimit:@"20" forOffset:@"0" completion:^(NSArray *restaurants, NSError *error) {
        if (restaurants){
            self.restaurants = restaurants;
            self.filteredData = restaurants;
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self.restaurantTable reloadData];
                [self.activityIndicator stopAnimating];
            });
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        // change to sending searchText to autocomplete API
        YelpAPIManager *manager = [YelpAPIManager new];
        [manager getYelpAutocomplete:self.latitude forLongt:self.longitude forText:searchText completion:^(NSArray * _Nonnull restaurantIDs, NSError * _Nonnull error) {
            if (restaurantIDs){
                YelpAPIManager *anotherManager = [YelpAPIManager new];
                [anotherManager getRestaurantArray:restaurantIDs completion:^(NSMutableArray * _Nonnull restaurantArray, NSError * _Nonnull error) {
                    self.filteredData = restaurantArray;
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        [self.restaurantTable reloadData];
                    });
                    NSLog(@"%@", self.filteredData);
                }];
            }
            else{
                self.filteredData = self.restaurants;
            }
        }];
    }
    else {
        self.filteredData = self.restaurants;
        [self.restaurantTable reloadData];
    }
    [self.restaurantTable reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}

- (IBAction)logOut:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        [self dismissViewControllerAnimated:YES completion:nil];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [[UIApplication sharedApplication].keyWindow setRootViewController: loginViewController];
    }];
}

//network error
- (void)networkError{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"The internet connection appears to be offline." preferredStyle:(UIAlertControllerStyleAlert)];

    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                      }];
    [alert addAction:cancelAction];

    // create an TryAgain action
    UIAlertAction *TryAgainAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        [self fetchRestaurants];
    }];
    [alert addAction:TryAgainAction];

    [self presentViewController:alert animated:YES completion:^{
    }];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"detailSegue"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.restaurantTable indexPathForCell:tappedCell];
        Restaurant *restaurant = self.filteredData[indexPath.row];
    
        DetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.restaurant = restaurant;
        detailViewController.restaurantDictionaries = self.restaurants;
    }
    if ([segue.identifier isEqual:@"mapSegue"]){
        MapViewController *mapViewController = [segue destinationViewController];
        mapViewController.restaurantDictionaries = self.restaurants;
    }

}

- (void) loadMoreData: (NSString *)currentCount {
    YelpAPIManager *manager = [YelpAPIManager new];
    [manager getYelpRestaurantCompletion:self.latitude forLongt:self.longitude forLimit:@"20" forOffset:currentCount completion:^(NSArray *restaurants, NSError *error) {
        if (restaurants){
            [self.restaurants addObjectsFromArray:restaurants];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                // update flag
                self.isMoreDataLoading = false;
                [self.restaurantTable reloadData];
                [self.refreshControl endRefreshing];
                [self.activityIndicator stopAnimating];
            });
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row + 1 == [self.restaurants count]){
        NSString *moreCount = [NSString stringWithFormat:@"%lu", [self.restaurants count]];
        [self loadMoreData:moreCount];
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.restaurantTable.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.restaurantTable.bounds.size.height;

        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.restaurantTable.isDragging) {
            self.isMoreDataLoading = true;
            NSString *moreCount = [NSString stringWithFormat:@"%lu", [self.restaurants count]];
            [self loadMoreData:moreCount];
        }
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RestaurantCell"];
    cell.restaurant = self.filteredData[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredData.count;
}


// swipe left to bookmark
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIContextualAction *bookmark = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        PFUser *currentUser = [PFUser currentUser];
        Restaurant *restaurant = self.filteredData[indexPath.row];
        
        //if currentUser did not bookmark, then add the restaurantID to their bookmark; else, do nothing
        if (!([currentUser[@"restaurants"] containsObject:restaurant.id])){
            [currentUser addObject:restaurant.id forKey:@"restaurants"];
            NSLog(@"restID %@", restaurant.id);
        }
        [currentUser saveInBackground];
        
        // check if this restaurant is previously created
        PFQuery *query = [PFQuery queryWithClassName:@"Restaurant"];
        [query whereKey:@"restaurantID" equalTo:restaurant.id];
        PFObject *object = [query getFirstObject];
        
        // if previously created, add directly
        if (object && !([object[@"userArray"] containsObject:currentUser.objectId])) {
            [object addObject:currentUser.objectId forKey:@"userArray"];
            [object saveInBackground];
        }
        // else, create first then add
        else{
            PFObject *resObj = [PFObject objectWithClassName:@"Restaurant"];
            resObj[@"restaurantID"] = restaurant.id;
            resObj[@"name"] = restaurant.name;
            [resObj addObject:currentUser.objectId forKey:@"userArray"];
            [resObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
             if (succeeded) {
                    NSLog(@"Object saved!");
             } else {
                    NSLog(@"Error: %@", error.description);
                }
            }];
        }
        [self.restaurantTable beginUpdates];
        [self.restaurantTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        [self.restaurantTable endUpdates];
        completionHandler(true);
    }];
    
    // UI Design
    bookmark.image  = [UIImage imageNamed:@"bookmark_white"];
    bookmark.backgroundColor = [UIColor colorWithRed:228.0f/255.0f
                                              green:78.0f/255.0f
                                               blue:45.0f/255.0f
                                              alpha:1.0f];
    bookmark.title = @"Bookmark";
    
    UISwipeActionsConfiguration *actions = [UISwipeActionsConfiguration configurationWithActions:[[NSArray alloc] initWithObjects:bookmark, nil]];
    
    return actions;
}

//swipe right to cancel bookmark
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIContextualAction *cancel = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        PFUser *currentUser = [PFUser currentUser];
        Restaurant *restaurant = self.filteredData[indexPath.row];
        
        //if currentUser did bookmark, then remove the restaurantID from their bookmark; else, do nothing
        if (([currentUser[@"restaurants"] containsObject:restaurant.id])){
            [currentUser removeObject:restaurant.id forKey:@"restaurants"];
        }
        [currentUser saveInBackground];
        
        // remove current userID from this Restaurant Parse Obj's userArray
        PFQuery *query = [PFQuery queryWithClassName:@"Restaurant"];
        [query whereKey:@"restaurantID" equalTo:restaurant.id];
        PFObject *object = [query getFirstObject];
        if (object) {
            [object removeObject:currentUser.objectId forKey:@"userArray"];
            [object saveInBackground];
            NSLog(@"removed");
        }
        [self.restaurantTable beginUpdates];
        [self.restaurantTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        [self.restaurantTable endUpdates];
        completionHandler(true);
        
        
    }];
    
    // UI Design
    cancel.image  = [UIImage systemImageNamed:@"nosign"];
    cancel.backgroundColor = [UIColor colorWithRed:210.0f/255.0f
                                              green:210.0f/255.0f
                                               blue:210.0f/255.0f
                                              alpha:1.0f];
    cancel.title = @"Unbookmark";
    
    UISwipeActionsConfiguration *actions = [UISwipeActionsConfiguration configurationWithActions:[[NSArray alloc] initWithObjects:cancel, nil]];
    
    return actions;
}


@end
