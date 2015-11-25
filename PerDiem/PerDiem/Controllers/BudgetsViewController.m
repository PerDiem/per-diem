//
//  BudgetsViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "BudgetsViewController.h"
#import "TransactionFormViewController.h"
#import "BudgetFormViewController.h"
#import "TransactionsViewController.h"
#import "BudgetCell.h"
#import "Budget.h"

@interface BudgetsViewController () <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) NSArray* budgets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BudgetsViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavBar];

    [Budget budgets:^(NSArray *budgets, NSError *error) {
        NSMutableSet *list = [NSMutableSet setWithArray:self.budgets];
        [list addObjectsFromArray:budgets];
        self.budgets = [list allObjects];
        [self.tableView reloadData];
    }];

    [Budget budgetsWithTransaction:^(NSArray *budgets, NSError *error) {
        NSSet *oldBudgets = [NSSet setWithArray:self.budgets];
        NSMutableSet *newBudgets = [NSMutableSet setWithArray:budgets];
        [newBudgets unionSet:oldBudgets];

        self.budgets = [newBudgets allObjects];
        [self.tableView reloadData];
    }];

    [self setupTableView];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}
#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    Budget *budget = self.budgets[indexPath.row];
    TransactionsViewController *vc = [[TransactionsViewController alloc] initWithBudget:budget];

    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.budgets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BudgetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BudgetCell"];
    cell.budget = self.budgets[indexPath.row];
    return cell;
}


#pragma mark - TabBarViewController

- (void)setupUI {
    [self setupBarItemWithImageNamed:@"budgets"];
}

- (void)setupTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BudgetCell" bundle:nil] forCellReuseIdentifier:@"BudgetCell"];
    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}


#pragma mark - NavBar Controller

- (void) setupNavBar {
    UIBarButtonItem *transactionButton = [[UIBarButtonItem alloc] initWithTitle:@"New Transaction" style:UIBarButtonItemStylePlain target:self action:@selector(onNewTransaction)];

    UIBarButtonItem *budgetButton = [[UIBarButtonItem alloc] initWithTitle:@"New Budget" style:UIBarButtonItemStylePlain target:self action:@selector(onNewBudget)];

    self.navigationItem.rightBarButtonItem = transactionButton;
    self.navigationItem.leftBarButtonItem = budgetButton;
}
- (void) onNewTransaction {
    [self.navigationController pushViewController:[[TransactionFormViewController alloc] init] animated:YES];
}

- (void) onNewBudget {
    [self.navigationController pushViewController:[[BudgetFormViewController alloc] init] animated:YES];
}

@end
