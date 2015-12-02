//
//  CalendarMonthViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 12/1/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "CalendarMonthViewController.h"
#import "CalendarDayViewController.h"
#import <DateTools/DateTools.h>
#import <UIKit/UIKit.h>
#import "NSDate+DateTools.h"
#import "DayViewTableViewCell.h"
#import "TransactionList.h"
#import "Budget.h"

@interface CalendarMonthViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DTTimePeriod *timePeriod;
@property (strong, nonatomic) TransactionList *transactionList;
@property (strong, nonatomic) NSArray<Budget *> *budgets;

@end

@implementation CalendarMonthViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"DayViewTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"cell"];
    
    [Transaction transactionsWithinPeriod:self.timePeriod
                               completion:^(TransactionList *transactionList, NSError *error) {
                                   self.transactionList = transactionList;
                                   
                                   // This call should be parallelized with the previous one, probably...
                                   [Budget budgets:^(NSArray *budgets, NSError *error) {
                                       self.budgets = budgets;
                                       [self.tableView reloadData];
                                   }];
                               }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.timePeriod.durationInDays;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DayViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    DTTimePeriod *period = [self periodAtIndex:indexPath];
    cell.mainLabel.text = [self innerPeriodLabelWithPeriod:period];
    cell.transactionList = [TransactionList transactionListWithTransactionList:self.transactionList
                                                              filterWithPeriod:period];
    cell.budgets = self.budgets;
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self navigateToDayWithTimePeriod:[self periodAtIndex:indexPath]
                             animated:YES];
}


#pragma mark - Private

- (void)setDate:(NSDate *)date {
    _date = date;
    NSDate *startOfDay = [[NSCalendar currentCalendar] startOfDayForDate:date];
    NSInteger monthStartedDaysAgo = startOfDay.day - 1;
    NSDate *startOfMonth = [startOfDay dateBySubtractingDays:monthStartedDaysAgo];
    self.timePeriod = [DTTimePeriod timePeriodWithSize:DTTimePeriodSizeMonth
                                            startingAt:startOfMonth];
    [self.tableView reloadData];
}

- (void)setTimePeriod:(DTTimePeriod *)timePeriod {
    _timePeriod = timePeriod;
    [self.tableView reloadData];
}

- (NSString *)innerPeriodLabelWithPeriod:(DTTimePeriod *)period {
    return [[period StartDate] formattedDateWithFormat:@"ccc d"];
}

- (DTTimePeriod *)periodAtIndex:(NSIndexPath *)indexPath {
    NSDate *day = [[self.timePeriod StartDate] dateByAddingDays:indexPath.row];
    DTTimePeriod *period = [DTTimePeriod timePeriodWithSize:DTTimePeriodSizeDay
                                                 startingAt:day];
    return period;
}

- (void)updateTitle {
    [self updateTitleWithTitle:[self.date formattedDateWithFormat:@"LLL u"]];
}

- (void)updateTitleWithTitle:(NSString *)title {
    if ([self.delegate respondsToSelector:@selector(calendarMonthViewController:updateTitle:)]) {
        [self.delegate calendarMonthViewController:self
                                       updateTitle:title];
    }
}

- (void)navigateToDayWithTimePeriod:(DTTimePeriod *)timePeriod
                           animated:(BOOL)animated {
    CalendarDayViewController *controller = [[CalendarDayViewController alloc] initWithNibName:@"CalendarDayViewController"
                                                                                        bundle:nil];
    controller.timePeriod = timePeriod;
    [self.navigationController pushViewController:controller
                                         animated:animated];
}

@end
