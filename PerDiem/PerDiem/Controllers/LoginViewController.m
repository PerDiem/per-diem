//
//  LoginViewController.m
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/20/15.
//  Copyright © 2015 Per Diem. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin:(id)sender {
    [PFUser logInWithUsernameInBackground:self.username.text password:self.password.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            NSLog(@"Hooray! Let them use the app now.");
                                        } else {
                                            NSLog(@"%@", error);
                                        }
                                    }];


}
- (IBAction)onSignUp:(id)sender {

    User *user = [User user];
    user.username = self.username.text;
    user.password = self.password.text;

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Hooray! Let them use the app now.");
        } else {
            NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
            NSLog(@"%@", errorString);
        }
    }];

}

@end
