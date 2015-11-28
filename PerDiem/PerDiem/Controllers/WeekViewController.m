//
//  WeekViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "WeekViewController.h"
#import "NSDate+DateTools.h"
#import "Budget.h"
#import "Transaction.h"
#import "TransactionList.h"
#import "DayViewTableViewCell.h"

@interface WeekViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TransactionList *transactionList;
@property (strong, nonatomic) NSArray<Budget *> *budgets;

@end

@implementation WeekViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 30.0;
    
    [Transaction transactionsWithinPeriod:self.timePeriod
                               completion:^(TransactionList *transactionList, NSError *error) {
                                   self.transactionList = transactionList;
                                   
                                   // This call should be parallelized with the previous one, probably...
                                   [Budget budgets:^(NSArray *budgets, NSError *error) {
                                       self.budgets = budgets;
                                       [self.tableView reloadData];
                                   }];
                               }];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DayViewTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"dayCell"];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *day = [[self.timePeriod StartDate] dateByAddingDays:indexPath.row];
    DTTimePeriod *period = [DTTimePeriod timePeriodWithSize:DTTimePeriodSizeDay
                                                 startingAt:day];
    DayViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dayCell"];
    cell.transactionList = [TransactionList transactionListWithTransactionList:self.transactionList
                                                              filterWithPeriod:period];
    cell.budgets = self.budgets;
    return cell;
}


#pragma mark - Private

- (void)setDate:(NSDate *)date {
    [super setDate:date];
    
    NSDate *startOfDay = [[NSCalendar currentCalendar] startOfDayForDate:date];
    NSInteger weekStartedDaysAgo = startOfDay.weekday - 1;
    NSDate *startOfWeek = [startOfDay dateBySubtractingDays:weekStartedDaysAgo];
    self.timePeriod = [DTTimePeriod timePeriodWithSize:DTTimePeriodSizeWeek
                                            startingAt:startOfWeek];
    [[self.timePeriod EndDate] dateBySubtractingSeconds:1];
}

- (void)updateLabel {
    self.label.text = [NSString stringWithFormat:@"%@ to %@", [[self.timePeriod StartDate] formattedDateWithFormat:@"LLL d"], [[self.timePeriod EndDate] formattedDateWithFormat:@"LLL d"]];
}

@end
