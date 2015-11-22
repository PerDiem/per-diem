//
//  BudgetsViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "BudgetsViewController.h"
#import "TransactionFormViewController.h"

@interface BudgetsViewController ()

@end

@implementation BudgetsViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavBar];
}


#pragma mark - TabBarViewController

- (void)setupUI {
    [self setupBarItemWithTitle:@"Budgets" imageNamed:@"budgets"];
}

#pragma mark - NavBar Controller

- (void) setupNavBar {
    UIBarButtonItem *transactionButtom = [[UIBarButtonItem alloc] initWithTitle:@"New Transaction" style:UIBarButtonItemStylePlain target:self action:@selector(onNewtransaction)];

    self.navigationItem.rightBarButtonItem = transactionButtom;
}
- (void) onNewtransaction {
    [self.navigationController pushViewController:[[TransactionFormViewController alloc] init] animated:YES];
}

@end
