//
//  LVSecondViewController.m
//  LVUITestUtils
//
//  Created by yanguo sun on 04/01/2017.
//  Copyright © 2017 sunyanguo. All rights reserved.
//

#import "LVSecondViewController.h"

@interface LVSecondViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIButton *alertButton;

@end

@implementation LVSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)action:(id)sender {
    [self.view endEditing:YES];
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"Message" message:self.textField.text preferredStyle:(UIAlertControllerStyleActionSheet)];
    alertVc.popoverPresentationController.sourceRect = self.alertButton.bounds;
    alertVc.popoverPresentationController.sourceView = self.alertButton;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVc addAction:okAction];
    [alertVc addAction:cancelAction];
    [self presentViewController:alertVc animated:YES completion:^{
        
    }];
}
@end
