//
//  CalendarInnerPeriodViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "CalendarInnerPeriodViewController.h"
#import "TransactionsViewController.h"
#import "DayViewTableViewCell.h"

@interface CalendarInnerPeriodViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *transactionsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *budgetsHeightContraint;
@property (strong, nonatomic) TransactionsViewController *transactionsViewController;

@end

@implementation CalendarInnerPeriodViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.scrollEnabled = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"DayViewTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"cell"];
    
    [Transaction transactionsWithinPeriod:self.timePeriod
                               completion:^(TransactionList *transactionList, NSError *error) {
                                   self.transactionList = transactionList;
                                   
                                   // This call should be parallelized with the previous one, probably...
                                   [Budget budgets:^(NSArray *budgets, NSError *error) {
                                       self.budgets = budgets;
                                       [self.tableView reloadData];
                                       [self adjustHeightOfTableview];
                                   }];
                               }];
    [self adjustHeightOfTableview];
    
    self.transactionsViewController = [[TransactionsViewController alloc] initWithTimePeriod:self.timePeriod];
    [self.transactionsView addSubview:self.transactionsViewController.view];
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


#pragma mark - Private

- (void)setDate:(NSDate *)date {
    _date = date;
    [self.tableView reloadData];
}

- (void)setTimePeriod:(DTTimePeriod *)timePeriod {
    _timePeriod = timePeriod;
    [self.tableView reloadData];
}

- (void)updateTitle {
    NSString *from = [[self.timePeriod StartDate] formattedDateWithStyle:NSDateFormatterFullStyle];
    NSString *to = [[self.timePeriod EndDate] formattedDateWithStyle:NSDateFormatterFullStyle];
    
    if ([self.delegate respondsToSelector:@selector(calendarInnerPeriodViewController:updateTitle:)]) {
        [self.delegate calendarInnerPeriodViewController:self
                                             updateTitle:[NSString stringWithFormat:@"%@ to %@", from, to]];
    }
}

- (DTTimePeriod *)periodAtIndex:(NSIndexPath *)indexPath {
    NSDate *day = [[self.timePeriod StartDate] dateByAddingDays:indexPath.row];
    return [DTTimePeriod timePeriodWithSize:DTTimePeriodSizeDay
                                 startingAt:day];
}

- (NSString *)innerPeriodLabelWithPeriod:(DTTimePeriod *)period {
    return @"";
}

- (void)adjustHeightOfTableview {
    CGFloat height = self.tableView.contentSize.height;
    CGFloat maxHeight = self.tableView.superview.frame.size.height - self.tableView.frame.origin.y;
    
    if (height > maxHeight) {
        height = maxHeight;
    }

    self.budgetsHeightContraint.constant = height;
    [self.tableView setNeedsUpdateConstraints];
}

@end
