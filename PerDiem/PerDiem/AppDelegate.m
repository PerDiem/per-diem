//
//  AppDelegate.m
//  Per Diem
//
//  Created by Chad Jewsbury on 11/12/15.
//  Copyright © 2015 Per Diem. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "NavigationViewController.h"
#import "BudgetsViewController.h"
#import "CalendarViewController.h"
#import "TransactionsViewController.h"
#import "TabBarController.h"
#import "User.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [Parse setApplicationId:@"8oKuq2b2uWdqI7AL7ETaBSrtzJRdjm1YXVClcyCO"
                  clientKey:@"iU3wcznuXqJ8NfsLegZqx1L1G2PgtYRey1Gl3qEm"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(renderLoggedInContent)
                                                 name:@"userLoggedIn"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(renderLoginForm)
                                                 name:@"userLoggedOut"
                                               object:nil];
    

    if ([User currentUser]) {
        [self renderLoggedInContent];
    } else {
        [self renderLoginForm];
    }
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)renderLoginForm {
    self.window.rootViewController = [[LoginViewController alloc] init];
}

- (void)renderLoggedInContent {
    // Budgets
    NavigationViewController *nvc1 = [[NavigationViewController alloc] init];
    BudgetsViewController *vc1 = [[BudgetsViewController alloc] initWithNibName:@"BudgetsViewController" bundle:nil];
    [nvc1 setViewControllers:@[vc1]];
    
    // Calendar
    NavigationViewController *nvc2 = [[NavigationViewController alloc] init];
    CalendarViewController *vc2 = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
    [nvc2 setViewControllers:@[vc2]];
    
    // Transactions
    NavigationViewController *nvc3 = [[NavigationViewController alloc] init];
    TransactionsViewController *vc3 = [[TransactionsViewController alloc] initWithNibName:@"TransactionsViewController" bundle:nil];
    [nvc3 setViewControllers:@[vc3]];
    
    TabBarController *tbc = [[TabBarController alloc] init];
    tbc.viewControllers = @[nvc1, nvc2, nvc3];
    
    self.window.rootViewController = tbc;
}

// Uncomment to enable login everytime the app launch
//- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [User logOut];
//}

@end
