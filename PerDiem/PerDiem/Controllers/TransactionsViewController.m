//
//  TransactionsViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "NavigationViewController.h"
#import "BudgetFormViewController.h"
#import "TransactionsViewController.h"
#import "TransactionFormViewController.h"
#import "TransactionCell.h"
#import "BudgetCell.h"
#import "Transaction.h"
#import "Budget.h"
#import "FiltersFormViewController.h"
#import "Filter.h"
#import "AddButtonView.h"
#import <SWTableViewCell.h>
#import "UIColor+PerDiem.h"
#import "JTProgressHUD.h"

@interface TransactionsViewController () <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate, TransactionFormActionDelegate, FiltersFormViewControllerDelegate, AddButtonDelegate>

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) Filter *filters;
@property (weak, nonatomic) IBOutlet AddButtonView *addButtonView;

@end

@implementation TransactionsViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backgroundColor];

    [self setupNavigationBar];
    [self setupTableView];
    self.addButtonView.delegate = self;

    [self updateTitle];
    if (self.budget != nil) {
        self.transactionList = self.budget.transactionList;
    } else {
        [self fetchTransactions];
    }
    [self setupRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateTitle];
}

- (void)updateTitle {
    if (self.budget != nil) {
        self.navigationItem.title = self.budget.name;
    } else {
        self.navigationItem.title = (self.filters) ? @"Filtered Transactions" : @"All Transactions";
    }
}

#pragma mark - Model Interaction Methods

- (void)fetchTransactions {
    if (self.budget != nil) {
        [JTProgressHUD showWithView:JTProgressHUDViewBuiltIn
                              style:JTProgressHUDStyleGradient
                         transition:JTProgressHUDTransitionFade
                    backgroundAlpha:.5];
        [self.refreshControl endRefreshing];
        [Budget budgetNamedWithTransaction:self.budget.name completion:^(Budget *budget, NSError *error) {
            if (budget) {
                self.transactionList = budget.transactionList;
                [self.tableView reloadData];
            } else {
                NSLog(@"Error: %@", error);
            }
            if ([JTProgressHUD isVisible]) {
                [JTProgressHUD hide];
            }
            [self.refreshControl endRefreshing];
        }];

    } else if (self.period != nil) {
        [Transaction transactionsWithinPeriod:self.period
                                   completion:^(TransactionList *transactions, NSError *error) {
                                       if (transactions) {
                                           self.transactionList = transactions;
                                           [self.tableView reloadData];
                                       } else {
                                           NSLog(@"Error: %@", error);
                                       }
                                       if ([JTProgressHUD isVisible]) {
                                           [JTProgressHUD hide];
                                       }
                                       [self.refreshControl endRefreshing];
                                   }];
    } else {
        [JTProgressHUD showWithView:JTProgressHUDViewBuiltIn
                              style:JTProgressHUDStyleGradient
                         transition:JTProgressHUDTransitionFade
                    backgroundAlpha:.5];
        [self.refreshControl endRefreshing];
        [Transaction transactions:^(TransactionList *transactions, NSError *error) {
            if (transactions) {
                self.transactionList = transactions;
                [self.tableView reloadData];
            } else {
                NSLog(@"Error: %@", error);
            }
            if ([JTProgressHUD isVisible]) {
                [JTProgressHUD hide];
            }
            [self.refreshControl endRefreshing];
        }];
    }
}

#pragma mark TransactionViewController public methods

- (id) initWithBudget: (Budget*) budget {
    self = [super init];
    if (self) {
        _budget = budget;
    }
    return self;
}

- (id)initWithTimePeriod:(DTTimePeriod *)period {
    self = [super init];
    if (self) {
        _period = period;
    }
    return self;
}

#pragma mark - Setup methods

- (void)setupTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"TransactionCell" bundle:nil] forCellReuseIdentifier:@"transactionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BudgetCell" bundle:nil] forCellReuseIdentifier:@"budgetCell"];
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)setupNavigationBar {
    UIBarButtonItem *filters = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic-filter"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self action:@selector(onFilters)];

    self.navigationItem.rightBarButtonItem = filters;
}

- (void)setupRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(fetchTransactionsAndClearFilters)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex: 0];
}

- (void)fetchTransactionsAndClearFilters {
    [self fetchTransactions];
    self.filters = nil;
    [self updateTitle];
}


#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    int count = 0;
    count += self.transactionList.transactions.count;
    if (self.budget != nil) {
        count++;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && self.budget) {
        BudgetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"budgetCell"];
        cell.arrowView.hidden = true;
        cell.budget = self.budget;
        return cell;
    } else {
        TransactionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"transactionCell"];
        if ([self.period durationInDays] <= 1 && self.period) {
            cell.hideDate = YES;
        }
        if (self.budget != nil) {
            cell.transaction = self.transactionList.transactions[indexPath.row - 1];
        } else {
            cell.transaction = self.transactionList.transactions[indexPath.row];
        }
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
        return cell;
    }
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

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger indexPathNumber = indexPath.row;
    if (self.budget) {
        indexPathNumber = indexPath.row - 1;
    }
    switch (index) {
        case 0:
        {
            TransactionFormViewController *vc = [[TransactionFormViewController alloc] initWithTransaction:self.transactionList.transactions[indexPathNumber]];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:
        {
            // Delete from Parse
            [self.transactionList.transactions[indexPathNumber] deleteTransaction];

            // Delete from model
            NSMutableArray *transactions = [self.transactionList.transactions mutableCopy];
            [transactions removeObjectAtIndex:indexPathNumber];
            self.transactionList.transactions = transactions;

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

-(void)transactionCreated:(Transaction *)transaction {
    [self.tableView beginUpdates];

    NSMutableArray *transactions = self.transactionList.transactions;
    [transactions insertObject:transaction atIndex:0];
    self.transactionList = [[TransactionList alloc] initWithTransactions:transactions];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

#pragma mark - TranscationFormActionDelegate

-(void)transactionUpdated:(Transaction *)transaction {
    [self.tableView beginUpdates];

    NSUInteger index = [self.transactionList.transactions indexOfObject:transaction];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];

    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

#pragma mark - FiltersFormViewDelegate

- (void)filtersFormViewController:(FiltersFormViewController *)filtersFormViewController didChangeFilters:(NSDictionary *)filters {
    [JTProgressHUD showWithView:JTProgressHUDViewBuiltIn
                          style:JTProgressHUDStyleGradient
                     transition:JTProgressHUDTransitionFade
                backgroundAlpha:.5];

    self.filters = [[Filter alloc] initWithFormFilters:filters];

    [Transaction transactions:^(TransactionList *transactions, NSError *error) {
        if (transactions) {
            self.transactionList = [TransactionList transactionListWithTransactionList:transactions
                                                                      filterWithFilter:self.filters];
            [self.tableView reloadData];
            if ([JTProgressHUD isVisible]) {
                [JTProgressHUD hide];
            }
        } else {
            NSLog(@"Error: %@", error);
            if ([JTProgressHUD isVisible]) {
                [JTProgressHUD hide];
            }
        }
    }];
}

#pragma mark - AddButtonDelegate

- (void)addButtonView:(UIView *)view presentAlertController:(UIAlertController *)alert {
    [self.navigationController presentViewController:alert
                                            animated:YES
                                          completion:nil];
}

- (void)addButtonView:(UIView *)view alertControllerForNewBudget:(UIAlertController *)alert {
    BudgetFormViewController *vc = [[BudgetFormViewController alloc] init];
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

#pragma mark - User interactions

- (void)onFilters {
    FiltersFormViewController *vc = [[FiltersFormViewController alloc] init];
    vc.delegate = self;
    NavigationViewController *nvc = [[NavigationViewController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nvc animated:YES completion:nil];
}

#pragma mark - TabBarViewController

- (void)setupUI {
    [self setupBarItemWithImageNamed:@"ic-listview" selectedImageName:@"ic-listview-selected" title:@"All Transactions"];
}

@end
