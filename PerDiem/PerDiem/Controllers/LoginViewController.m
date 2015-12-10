//
//  LoginViewController.m
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/20/15.
//  Copyright © 2015 Per Diem. All rights reserved.
//

#import "LoginViewController.h"
#import "UIColor+PerDiem.h"
#import "KeychainWrapper.h"
#import <QuartzCore/QuartzCore.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import "User.h"
#import "JTProgressHUD.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) KeychainWrapper *keychainWrapper;
@property (weak, nonatomic) IBOutlet UIView *loginView;

@end

@implementation LoginViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.username.backgroundColor = [UIColor loginInputColor];
    self.username.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: [UIColor placeholderInputColor]}];

    self.password.backgroundColor = [UIColor loginInputColor];
    self.password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor placeholderInputColor]}];

    [self.loginView.layer setCornerRadius:5.0f];


    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([defaults boolForKey:@"hasLoginKey"]) {
        LAContext *laContext = [[LAContext alloc] init];
        NSError *authError = nil;
    
        if ([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
            [laContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                      localizedReason:@"Please authenticate to continue"
                                reply:^(BOOL success, NSError *error) {
                                    if (success) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            self.password.text = [self.keychainWrapper myObjectForKey:@"v_Data"];
                                            self.username.text = [defaults valueForKey:@"username"];
                                            [self onLogin:self];
                                        });
                                    } else {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            // could do some smarter handling using object `error.description`
                                            // simply assume here the user wants to manually type password
                                            [self.username becomeFirstResponder];
                                        });
                                    }
                                }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // could do some smarter handling using object `authError.description`
                // simply assume here that touch id is not configured
                [self.username becomeFirstResponder];                
            });
        }

    }
}


#pragma mark - Actions

- (IBAction)onLogin:(id)sender {
    [JTProgressHUD showWithView:JTProgressHUDViewBuiltIn
                          style:JTProgressHUDStyleGradient
                     transition:JTProgressHUDTransitionFade
                backgroundAlpha:.5];
    [PFUser logInWithUsernameInBackground:self.username.text
                                 password:self.password.text
                                    block:^void(PFUser *user, NSError *error) {
                                        if (user) {
                                            [self userCompletedAuthentication];
                                            if ([JTProgressHUD isVisible]) {
                                                [JTProgressHUD hide];
                                            }
                                        } else {
                                            if ([JTProgressHUD isVisible]) {
                                                [JTProgressHUD hide];
                                            }
                                            [self alertWithTitle:@"Login Error"
                                                         message:[NSString stringWithFormat:@"%@", error]];
                                        }
                                    }];
}

- (IBAction)onSignUp:(id)sender {

    User *user = [User user];
    user.username = self.username.text;
    user.password = self.password.text;

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self userCompletedAuthentication];
        } else {
            [self alertWithTitle:@"Login Error"
                         message:[NSString stringWithFormat:@"%@", [error userInfo][@"error"]]];
        }
    }];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - Private

- (void)userCompletedAuthentication {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [self.keychainWrapper mySetObject:self.password.text forKey:(__bridge id)kSecValueData];
    [self.keychainWrapper writeToKeychain];
    
    [defaults setValue:self.username.text forKey:@"username"];
    [defaults setBool:true forKey: @"hasLoginKey"];
    [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userLoggedIn" object:nil];
}

- (KeychainWrapper *)keychainWrapper {
    if (!_keychainWrapper) {
        _keychainWrapper =  [[KeychainWrapper alloc] init];
    }
    return _keychainWrapper;
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
