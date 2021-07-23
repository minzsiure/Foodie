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
#import "RestaurantViewController.h"
#import <Parse/Parse.h>
#import <ASIHTTPRequest/ASIHTTPRequest.h>

@interface MapViewController () <GMSMapViewDelegate>
@property double latitude;
@property double longtitude;
@property (strong, nonatomic) GMSMapView *mapView;



@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFUser *user = [PFUser currentUser];
    _latitude = [user[@"latitude"] doubleValue];
    _longtitude = [user[@"longitude"] doubleValue];
    [self createCameraPosition];
    [self createCenterMarker];
    [self processRestaurantArray:self.restaurantDictionaries];
    if (self.detailLatitude != nil && self.detailLongitude != nil){
        [self createPolyline];
    }
    
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
    self.mapView.settings.myLocationButton = YES;
}

- (void) createCenterMarker{
    // create a marker on user current location (currently default)
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(_latitude, _longtitude);
    marker.title = @"Current Location";
//    marker.snippet = @"";
    marker.map = self.mapView;
    marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
}

- (void) createPolyline{
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString *GoogleAPIKey = [dict objectForKey: @"GoogleAPIKey"];
    PFUser *user = [PFUser currentUser];
    NSString *urlString = [NSString stringWithFormat:
                       @"%@?origin=%f,%f&destination=%f,%f&sensor=true&key=%@",
                       @"https://maps.googleapis.com/maps/api/directions/json",
                           [user[@"latitude"] doubleValue],
                           [user[@"longitude"] doubleValue],
                           [self.detailLatitude doubleValue],
                           [self.detailLongitude doubleValue],
                           GoogleAPIKey];
    NSURL *directionsURL = [NSURL URLWithString:urlString];


    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:directionsURL];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSDictionary *json =[NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:&error];
        GMSPath *path =[GMSPath pathFromEncodedPath:json[@"routes"][0][@"overview_polyline"][@"points"]];
        GMSPolyline *singleLine = [GMSPolyline polylineWithPath:path];
        singleLine.strokeWidth = 7;
        singleLine.strokeColor = [UIColor blueColor];
        singleLine.map = self.mapView;
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MarkerDetail"]){
        Restaurant *restaurant = sender;
        DetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.restaurant = restaurant;
    }
}



@end
