//
//  DetailViewController.m
//  Foodie
//
//  Created by Eva Xie on 7/9/21.
//

#import "DetailViewController.h"
#import "RestaurantDetail.h"
#import "Restaurant.h"
#import "UIImageView+AFNetworking.h"
#import "YelpAPIManager.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) NSDictionary *detailDictionary;
@property (strong, nonatomic) NSString *categoryString;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchRestaurantDetail];
    
}

- (void) fetchRestaurantDetail{
    //NSLog(@"%@", self.restaurant.id);
//    YelpAPIManager *manager = [YelpAPIManager new];
//    [manager getRestaurantDetail:self.restaurant completion:^(RestaurantDetail *restautantDetail, NSError *error) {
//        self.restaurantDetail = restautantDetail;
//
//        //NSLog(@"%@", self.categoryString);
//    }];
//    NSString *APIKey = @"28Yo8kD_K-RyBUR6gCWznPYoMh1ItVdboaEExmr9duOBklai0I21Ww6b-IHLW2ZJyn6Ohh70J_V-xP6Mxv1JV1V8HZ_9hljzdgqkMbouw6oRsY3f12VS0KL3LqHoYHYx";
//    NSString *baseURL = @"https://api.yelp.com/v3/businesses/";
//    NSString *completeURL = [baseURL stringByAppendingString:self.restaurant.id];
//    NSURL *url = [NSURL URLWithString: completeURL];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//
//    [request setHTTPMethod:@"GET"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//
//    NSString *authValue = [NSString stringWithFormat:@"Bearer %@", APIKey];
//    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
//
//    NSURLSession *session = [NSURLSession sharedSession];
//    [[session dataTaskWithRequest:request
//             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (!error) {
//            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//            NSLog(@"Restaurant Detail FETCHED SUCCESS");
//            self.detailDictionary = responseDictionary;
//        }
//        else{
//            NSLog(@"ERROR %@", [error localizedDescription]);
//        }
//
//    }] resume];
    
    self.posterImage.image = nil;
    if (self.restaurant.imageURL != nil){
        [self.posterImage setImageWithURL:self.restaurant.imageURL];
    }
    self.nameLabel.text = self.restaurant.name;
    self.ratingLabel.text = self.restaurant.rating;
    self.priceLabel.text = self.restaurant.price;
    NSArray *categoryDic = self.restaurant.categories;
    for (int i = 0; i < categoryDic.count; i++){
        if (i < categoryDic.count){
            [self.categoryString stringByAppendingString:categoryDic[i][@"title"]];
            [self.categoryString stringByAppendingString:@", "];
        }
        else{
            [self.categoryString stringByAppendingString:categoryDic[i][@"title"]];
        }
    }
    self.categoryLabel.text = self.categoryString;
}

- (IBAction)onTapYelpLink:(id)sender {
}

- (IBAction)onTapCall:(id)sender {
}

- (IBAction)onTapLocation:(id)sender {
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
