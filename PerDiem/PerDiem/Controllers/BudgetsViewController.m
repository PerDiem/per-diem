//
//  BudgetsViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "BudgetsViewController.h"

@interface BudgetsViewController ()

@end

@implementation BudgetsViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - TabBarViewController

- (void)setupUI {
    [self setupBarItemWithTitle:@"Budgets" imageNamed:@"budgets"];
}

@end
