//
//  LocationViewController.m
//  Foodie
//
//  Created by Eva Xie on 7/26/21.
//

#import "LocationViewController.h"
#import <Parse/Parse.h>
@import GooglePlaces;

@interface LocationViewController () <GMSAutocompleteViewControllerDelegate>

@end

@implementation LocationViewController {
    GMSAutocompleteFilter *_filter;
  }

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    // Specify the place data types to return.
    GMSPlaceField fields = (GMSPlaceFieldName | GMSPlaceFieldPlaceID);
    self.placeFields = fields;

      // Specify a filter.
    _filter = [[GMSAutocompleteFilter alloc] init];
    _filter.type = kGMSPlacesAutocompleteTypeFilterAddress;
    self.autocompleteFilter = _filter;
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // after user selected the place
    dispatch_async(dispatch_get_main_queue(), ^{
        GMSPlacesClient *placeClient = [GMSPlacesClient sharedClient];
        [placeClient lookUpPlaceID:place.placeID callback:^(GMSPlace * _Nullable result, NSError * _Nullable error) {
            if(!error) {
                NSLog(@"place : %f,%f",result.coordinate.latitude, result.coordinate.longitude);
                PFUser *user = [PFUser currentUser];
                // regular phone
                user[@"latitude"] = [NSString stringWithFormat:@"%f", result.coordinate.latitude];
                user[@"longitude"] = [NSString stringWithFormat:@"%f", result.coordinate.longitude];
            } else {
                NSLog(@"Error : %@",error.localizedDescription);
                }
            }];
        });
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
  [self dismissViewControllerAnimated:YES completion:nil];
  // TODO: handle the error.
  NSLog(@"Error: %@", [error description]);
}

  // User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
  [self dismissViewControllerAnimated:YES completion:nil];
}

  // Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
