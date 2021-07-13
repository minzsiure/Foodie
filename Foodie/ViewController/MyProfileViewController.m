//
//  MyProfileViewController.m
//  Foodie
//
//  Created by Eva Xie on 7/9/21.
//

#import "MyProfileViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MyProfileViewController ()
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.shadowView.layer.shadowOpacity = 0.35;
    self.shadowView.layer.shadowOffset = CGSizeMake(0, -5);
    self.shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
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
