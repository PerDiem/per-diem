//
//  TransactionsViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "TransactionsViewController.h"
#import "TransactionCell.h"


@interface TransactionsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TransactionsViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"All Transactions";

    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupNavigationBar];
    [self setupTableView];
}

#pragma mark - Setup methods

- (void)setupTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
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


#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"transactionCell"];
    return cell;
}

- (void)onFilters {
    NSLog(@"Filters Tapped");
}

#pragma mark - TabBarViewController

- (void)setupUI {
    [self setupBarItemWithImageNamed:@"transactions"];
}

@end
