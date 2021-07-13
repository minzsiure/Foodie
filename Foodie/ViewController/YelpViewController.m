//
//  YelpViewController.m
//  Foodie
//
//  Created by Eva Xie on 7/12/21.
//

#import "YelpViewController.h"

@interface YelpViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *yelpWebView;

@end

@implementation YelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.yelpURL
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:10.0];
    // Load Request into WebView.
    [self.yelpWebView loadRequest:request];
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
