//
//  LoginViewController.m
//  Foodie
//
//  Created by Eva Xie on 7/9/21.
//

#import "LoginViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import <UITextField+Shake.h>

@interface LoginViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *usernameText;
@property (weak, nonatomic) IBOutlet UILabel *passwordText;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self accessCurrentLocation];
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
        
         self.latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
         self.longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
         NSLog(@"lat%@ - lon%@", self.latitude, self.longitude);
         PFUser *user = [PFUser currentUser];
         user[@"latitude"] = self.latitude;
         user[@"longitude"] = self.longitude;
        [self.locationManager stopUpdatingLocation];
         
    }


- (IBAction)signUpUser:(id)sender {
    if (![self.usernameField.text isEqual:@""] && ![self.passwordField.text isEqual:@""]) {
        PFUser *newUser = [PFUser user];

        newUser.username = self.usernameField.text;
        newUser.password = self.passwordField.text;
//        newUser[@"latitude"] = self.latitude;
//        newUser[@"longitude"] = self.longitude;

        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"User registered successfully");
            }
        }];
    }
    else {
        [self displayAlert];
    }
}

- (IBAction)logInUser:(id)sender {
    if (![self.usernameField.text isEqual:@""] && ![self.passwordField.text isEqual:@""]) {
        NSString *username = self.usernameField.text;
        NSString *password = self.passwordField.text;
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (error != nil) {
//            user[@"latitude"] = self.latitude;
//            user[@"longitude"] = self.longitude;
                NSLog(@"User log in failed: %@", error.localizedDescription);
            } else {
                NSLog(@"User logged in successfully");
            
                // display view controller that needs to shown after successful login
                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            }
        }];
    }
    else{
        [self.usernameField shake];
        [self.passwordField shake];
        [self.usernameField shake:10 withDelta:10 speed:0.05 shakeDirection:ShakeDirectionHorizontal];
        [self.passwordField shake:10 withDelta:10 speed:0.05 shakeDirection:ShakeDirectionHorizontal];
        
    }
}

- (void)displayAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Empty fields" message:@"Username and password fields must not be empty" preferredStyle:(UIAlertControllerStyleAlert)];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                     }];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:^{
    
    }];
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
