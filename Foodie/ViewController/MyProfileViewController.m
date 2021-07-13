//
//  MyProfileViewController.m
//  Foodie
//
//  Created by Eva Xie on 7/9/21.
//

#import "MyProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import <Parse/Parse.h>

@interface MyProfileViewController ()
@property (strong, nonatomic) UIImage *resizedImage;
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

- (void)viewDidAppear:(BOOL)animated {
    PFUser *user = [PFUser currentUser];
    PFFileObject *profilePic = user[@"profilePic"];
    NSURL *profilePicURL = [NSURL URLWithString:profilePic.url];
    [self.profileImage setImageWithURL:profilePicURL];
    
    self.userName.text = user[@"username"];
}

- (IBAction)onTapEditProfilePic:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}


// Implement the delegate method
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    PFUser *user = [PFUser currentUser];
    
    
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    self.resizedImage = [self resizeImage:editedImage withSize:CGSizeMake(300, 300)];
    
    self.profileImage.image = self.resizedImage;
    if (self.profileImage.image != nil) {
        NSData *data = UIImagePNGRepresentation(self.profileImage.image);
        PFFileObject *photo = [PFFileObject fileObjectWithName:@"image.png" data:data];
        user[@"profilePic"] = photo;
    }
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"it worked!");
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
