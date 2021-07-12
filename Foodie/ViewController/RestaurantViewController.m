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
#import "LoginViewController.h"
#import "DetailViewController.h"

@interface RestaurantViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *restaurantTable;

@property (strong, nonatomic) NSArray *restaurants;
@property (strong, nonatomic) NSArray *restaurantDetail;


@end

@implementation RestaurantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.restaurantTable.delegate = self;
    self.restaurantTable.dataSource = self;
    [self fetchRestaurants];
    [self.restaurantTable reloadData];

    
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
