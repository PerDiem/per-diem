//
//  BudgetsViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "NavigationViewController.h"
#import "BudgetsViewController.h"
#import "TransactionFormViewController.h"
#import "BudgetFormViewController.h"
#import "TransactionsViewController.h"
#import "BudgetCell.h"
#import "Budget.h"
#import "AddButtonView.h"
#import "UIColor+PerDiem.h"
#import <SWTableViewCell.h>

@interface BudgetsViewController () <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate, BudgetFormActionDelegate, TransactionFormActionDelegate, AddButtonDelegate>

@property(strong, nonatomic) NSArray* budgets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet AddButtonView *addButtonView;

@end

@implementation BudgetsViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Budgets";
    [self setupRefreshControl];
    [self setupTableView];
    [self fetchBudgets];

    self.addButtonView.delegate = self;
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
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    return cell;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"Edit"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    return rightUtilityButtons;
}

#pragma mark - TabBarViewController

- (void)setupUI {
    [self setupBarItemWithImageNamed:@"ic-pie" selectedImageName:@"ic-pie-selected" title:@"Budgets"];
}

#pragma mark - Setup

- (void) fetchBudgets {
    [Budget budgets:^(NSArray *budgets, NSError *error) {
        NSMutableSet *list = [NSMutableSet setWithArray:self.budgets];
        [list addObjectsFromArray:budgets];
        self.budgets = [list allObjects];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];

    NSDate *today = [NSDate date];
    NSDate *startOfDay = [[NSCalendar currentCalendar] startOfDayForDate:today];
    NSInteger monthStartedDaysAgo = startOfDay.day - 1;
    NSDate *startOfMonth = [startOfDay dateBySubtractingDays:monthStartedDaysAgo];
    DTTimePeriod *timePeriod = [DTTimePeriod timePeriodWithSize:DTTimePeriodSizeMonth
                                            startingAt:startOfMonth];

    [Budget budgetsWithTransactionWithinPeriod:timePeriod completion:^(NSArray *budgets, NSError *error) {
        NSSet *oldBudgets = [NSSet setWithArray:self.budgets];
        NSMutableSet *newBudgets = [NSMutableSet setWithArray:budgets];
        [newBudgets unionSet:oldBudgets];

        self.budgets = [newBudgets allObjects];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (void)setupRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(fetchBudgets)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex: 0];
}

- (void)setupTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BudgetCell" bundle:nil] forCellReuseIdentifier:@"BudgetCell"];
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    switch (index) {
        case 0:
        {
            BudgetFormViewController *vc = [[BudgetFormViewController alloc] initWithBudget:self.budgets[indexPath.row]];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:
        {
            // Delete from Parse
            [self.budgets[indexPath.row] deleteBudget];

            // Delete from model
            NSMutableArray *budgets = [self.budgets mutableCopy];
            [budgets removeObjectAtIndex:indexPath.row];
            self.budgets = budgets;

            // Delete from tableView
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            break;
        }
        default:
            break;
    }
}

#pragma mark - TransactionFormActionDelegate
-(void)transactionCreated:(Transaction*) transaction {
    [self.tableView beginUpdates];
    NSUInteger index = [self.budgets indexOfObject:transaction.budget];
    Budget *budget = self.budgets[index];
    [budget addTransaction: transaction];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];

}

#pragma mark - BudgetFormActionDelegate

-(void)budgetCreated:(Budget*) budget {
    [self.tableView beginUpdates];

    NSMutableArray *budgets = [self.budgets mutableCopy];
    [budgets addObject:budget];
    self.budgets = budgets;

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(budgets.count -1) inSection:0];

    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}
-(void)budgetUpdated:(Budget*) budget {
    [self.tableView beginUpdates];

    NSUInteger index = [self.budgets indexOfObject:budget];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];

    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

#pragma mark - AddButtonDelegate

- (void)addButtonView:(UIView *)view presentAlertController:(UIAlertController *)alert {
    [self.navigationController presentViewController:alert
                                            animated:YES
                                          completion:nil];
}

- (void)addButtonView:(UIView *)view alertControllerForNewBudget:(UIAlertController *)alert {
    BudgetFormViewController *vc = [[BudgetFormViewController alloc] init];
    vc.delegate = self;
    NavigationViewController *nvc = [[NavigationViewController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nvc
                                            animated:YES
                                          completion:nil];
}

- (void)addButtonView:(UIView *)view alertControllerForNewTransaction:(UIAlertController *)alert {
    TransactionFormViewController *vc = [[TransactionFormViewController alloc] init];
    vc.delegate = self;
    NavigationViewController *nvc = [[NavigationViewController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nvc
                                            animated:YES
                                          completion:nil];
}

@end
