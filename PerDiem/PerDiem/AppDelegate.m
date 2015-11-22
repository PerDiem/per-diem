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
#import "DayViewController.h"
#import "TransactionsViewController.h"
#import "TransactionFormViewController.h"
#import "TabBarController.h"
#import "User.h"
#import "Transaction.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [Parse setApplicationId:@"8oKuq2b2uWdqI7AL7ETaBSrtzJRdjm1YXVClcyCO"
                  clientKey:@"iU3wcznuXqJ8NfsLegZqx1L1G2PgtYRey1Gl3qEm"];

//    [User logOut];
    if ([User currentUser]) {
        
        // Budgets
        NavigationViewController *nvc1 = [[NavigationViewController alloc] init];
        BudgetsViewController *vc1 = [[BudgetsViewController alloc] initWithNibName:@"BudgetsViewController" bundle:nil];
        [nvc1 setViewControllers:@[vc1]];


        // Day
        NavigationViewController *nvc2 = [[NavigationViewController alloc] init];
        DayViewController *vc2 = [[DayViewController alloc] initWithNibName:@"DayViewController" bundle:nil];
        [nvc2 setViewControllers:@[vc2]];
        
        // Transactions
        NavigationViewController *nvc3 = [[NavigationViewController alloc] init];
        TransactionsViewController *vc3 = [[TransactionsViewController alloc] initWithNibName:@"TransactionsViewController" bundle:nil];
        [nvc3 setViewControllers:@[vc3]];

//        // New Transaction
//        NavigationViewController *nvc4 = [[NavigationViewController alloc] init];
//        TransactionFormViewController *vc4 = [[TransactionFormViewController alloc] init];
//        [nvc4 setViewControllers:@[vc4]];

        TabBarController *tbc = [[TabBarController alloc] init];
        tbc.viewControllers = @[nvc1, nvc2, nvc3];
        
        self.window.rootViewController = tbc;
        
    } else {
        self.window.rootViewController = [[LoginViewController alloc] init];
    }
    [self.window makeKeyAndVisible];

    return YES;
}

@end
