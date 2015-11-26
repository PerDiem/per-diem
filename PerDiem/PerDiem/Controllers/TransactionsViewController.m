//
//  TransactionsViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "TransactionsViewController.h"
#import "TransactionFormViewController.h"
#import "TransactionCell.h"
#import "Transaction.h"
#import "TransactionList.h"
#import "Budget.h"
#import <SWTableViewCell.h>

@interface TransactionsViewController () <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate, TransactionFormActionDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TransactionList *transactionList;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation TransactionsViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupNavigationBar];
    [self setupTableView];

    if (self.budget) {
        self.title = self.budget.name;
        self.transactionList = self.budget.transactionList;
    } else {
        self.title = @"All Transactions";
        [self fetchTransactions];
        [self setupRefreshControl];
    }
}

#pragma mark - Model Interaction Methods

- (void)fetchTransactions {
    [Transaction transactions:^(TransactionList *transactions, NSError *error) {
        if (transactions) {
            self.transactionList = transactions;
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@", error);
        }
        [self.refreshControl endRefreshing];
    }];

}

#pragma mark TransactionViewController public methods

- (id) initWithBudget: (Budget*) budget {
    self = [super init];
    if (self) {
        _budget = budget;
    }
    return self;
}

#pragma mark - Setup methods

- (void)setupTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"TransactionCell" bundle:nil] forCellReuseIdentifier:@"transactionCell"];
    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)setupNavigationBar {
    UIBarButtonItem *filters = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"filters_icon"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self action:@selector(onFilters)];

    self.navigationItem.rightBarButtonItem = filters;
}

- (void)setupRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(fetchTransactions)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex: 0];
}


#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.transactionList.transactions.count > 0) {
        return self.transactionList.transactions.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"transactionCell"];
    cell.transaction = self.transactionList.transactions[indexPath.row];
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

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    switch (index) {
        case 0:
        {
            TransactionFormViewController *vc = [[TransactionFormViewController alloc] initWithTransaction:self.transactionList.transactions[indexPath.row]];
            vc.delegator = self;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:
        {
            // Delete from Parse
            [self.transactionList.transactions[indexPath.row] deleteTransaction];

            // Delete from model
            NSMutableArray *transactions = [self.transactionList.transactions mutableCopy];
            [transactions removeObjectAtIndex:indexPath.row];
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

#pragma mark - TranscationFormActionDelegate

-(void)transactionUpdated:(Transaction *)transaction {
    [self.tableView beginUpdates];

    NSUInteger index = [self.transactionList.transactions indexOfObject:transaction];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];

    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

#pragma mark - User interactions

- (void)onFilters {
    NSLog(@"Filters Tapped");
}

#pragma mark - TabBarViewController

- (void)setupUI {
    [self setupBarItemWithImageNamed:@"transactions"];
}

@end
