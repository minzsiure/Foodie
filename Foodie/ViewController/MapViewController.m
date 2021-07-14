//
//  MapViewController.m
//  Foodie
//
//  Created by Eva Xie on 7/13/21.
//

#import "MapViewController.h"
#import "Restaurant.h"
#import <GoogleMaps/GoogleMaps.h>
#import "DetailViewController.h"
#import <Parse/Parse.h>

@interface MapViewController () <GMSMapViewDelegate>
@property double latitude;
@property double longtitude;
@property (strong, nonatomic) GMSMapView *mapView;



@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _latitude = 42.36001;
//    _longtitude = -71.0942;
    PFUser *user = [PFUser currentUser];
    _latitude = [user[@"latitude"] doubleValue];
    _longtitude = [user[@"longitude"] doubleValue];
    [self createCameraPosition];
    [self createCenterMarker];
    [self processRestaurantArray:self.restaurantDictionaries];
    
}


- (void) createCameraPosition{
    // Create a GMSCameraPosition that tells the map to display the given
    // coordinate at zoom level 15.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_latitude
                                                              longitude:_longtitude
                                                                   zoom:15];
    self.mapView = [GMSMapView mapWithFrame:self.view.frame camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

- (void) createCenterMarker{
    // create a marker on user current location (currently default)
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(_latitude, _longtitude);
    marker.title = @"Current Location";
//    marker.snippet = @"";
    marker.map = self.mapView;
}

- (void) processRestaurantMarker: (Restaurant *)restaurantObj{
    // process all restaurant objects from main stream Yelp API
    GMSMarker *marker = [[GMSMarker alloc] init];
    double latDouble = [restaurantObj.latitude doubleValue];
    double longDouble = [restaurantObj.longitude doubleValue];
    marker.position = CLLocationCoordinate2DMake(latDouble, longDouble);
    marker.title = restaurantObj.name;
    marker.map = self.mapView;
    marker.snippet = @"View Details";
    marker.userData = restaurantObj;
    
}

- (void) processRestaurantArray: (NSArray *)restaurantDic{
    for (Restaurant *dictionary in restaurantDic){
        [self processRestaurantMarker:dictionary];
    }
}

#pragma mark - GMSMapViewDelegate
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    NSLog(@"You long tapped at marker");
    [self performSegueWithIdentifier:@"MarkerDetail" sender:marker.userData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MarkerDetail"]){
        Restaurant *restaurant = sender;
        DetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.restaurant = restaurant;
    }
}



@end
