//
//  MapViewController.m
//  Foodie
//
//  Created by Eva Xie on 7/13/21.
//

#import "MapViewController.h"
#import "Restaurant.h"
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController () <GMSMapViewDelegate>
@property double latitude;
@property double longtitude;
@property (strong, nonatomic) GMSMapView *mapView;


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _latitude = 42.36001;
    _longtitude = -71.0942;
    // Create a GMSCameraPosition that tells the map to display the given
    // coordinate at zoom level 15.
    [self createCameraPosition];
    [self createCenterMarker];
    [self processRestaurantArray:self.restaurantDictionaries];
}

- (void) createCameraPosition{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_latitude
                                                              longitude:_longtitude
                                                                   zoom:15];
    self.mapView = [GMSMapView mapWithFrame:self.view.frame camera:camera];
    self.mapView.myLocationEnabled = YES;
    [self.view addSubview:self.mapView];
}

- (void) createCenterMarker{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(_latitude, _longtitude);
    marker.title = @"MIT";
    marker.snippet = @"Current Location";
    marker.map = self.mapView;
}

- (void) processRestaurantMarker: (Restaurant *)restaurantObj{
    GMSMarker *marker = [[GMSMarker alloc] init];
    double latDouble = [restaurantObj.latitude doubleValue];
    double longDouble = [restaurantObj.longitude doubleValue];
    marker.position = CLLocationCoordinate2DMake(latDouble, longDouble);
    marker.title = restaurantObj.name;
    marker.map = self.mapView;
    marker.snippet = @"View Details";
    
}

- (void) processRestaurantArray: (NSArray *)restaurantDic{
    for (Restaurant *dictionary in restaurantDic){
        [self processRestaurantMarker:dictionary];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
