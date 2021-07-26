//
//  AppDelegate.m
//  Foodie
//
//  Created by Eva Xie on 7/1/21.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <GoogleMaps/GoogleMaps.h>
@import GooglePlaces;

@interface AppDelegate ()
@property (strong, nonatomic) NSString *GoogleAPIKey;
@property (strong, nonatomic) NSString *ParseApplicationID;
@property (strong, nonatomic) NSString *ParseClientKey;


@end

@implementation AppDelegate

- (id)init {
    self = [super init];
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    self.GoogleAPIKey = [dict objectForKey: @"GoogleAPIKey"];
    self.ParseApplicationID = [dict objectForKey: @"ParseApplicationID"];
    self.ParseClientKey = [dict objectForKey:@"ParseClientKey"];
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // GoogleMap set up
    [GMSServices provideAPIKey:self.GoogleAPIKey];
    // Parse set up
    ParseClientConfiguration *config = [ParseClientConfiguration  configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {

            configuration.applicationId = self.ParseApplicationID;
            configuration.clientKey = self.ParseClientKey;
            configuration.server = @"https://parseapi.back4app.com";
        }];

    [Parse initializeWithConfiguration:config];
    [GMSPlacesClient provideAPIKey:self.GoogleAPIKey];

    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
