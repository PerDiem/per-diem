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
#import "UIColor+PerDiem.h"
#import "JTProgressHUD.h"

@interface CalendarMonthViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation CalendarMonthViewController

#pragma mark - UIViewController

- (instancetype)initWithDate:(NSDate *)date
                  completion:(void(^)(NSArray<PerDiem *>*))completionHandler {
    if (self = [super initWithNibName:@"CalendarMonthViewController" bundle:nil]) {
        self.date = date;
        [self fetchPerDiemsWithCompletion:^(NSArray<PerDiem *> *perDiems) {
             [self.tableView reloadData];
            if (completionHandler != nil) {
                completionHandler(perDiems);
            }
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor backgroundColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"DayViewTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"cell"];
    [self setupRefreshControl];
}

- (void)setupRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(updatePerDiems)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex: 0];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.timePeriod.durationInDays;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DayViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.perDiem = [self.perDiems objectAtIndex:indexPath.row];
    [cell layoutSubviews];
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PerDiem *cellPerDiem = [self.perDiems objectAtIndex:indexPath.row];

    // Don't allow cells with $0 spent to be opened.
    if ([cellPerDiem.spent integerValue] == 0) {
        return;
    }

    if ([self.delegate respondsToSelector:@selector(calendarMonthViewController:navigateToDayWithPerDiem:animated:)]) {
        [self.delegate calendarMonthViewController:self
                          navigateToDayWithPerDiem:cellPerDiem
                                          animated:YES];
    }
}


#pragma mark - Private

- (void)fetchPerDiemsWithCompletion:(void(^)(NSMutableArray<PerDiem *>*))completionHandler {
    [JTProgressHUD showWithView:JTProgressHUDViewBuiltIn
                          style:JTProgressHUDStyleGradient
                     transition:JTProgressHUDTransitionFade
                backgroundAlpha:.5];
    [JTProgressHUD showWithTransition:JTProgressHUDTransitionFade];
    [PerDiem perDiemsForPeriod:self.timePeriod
                    completion:^void(NSMutableArray<PerDiem *> *perDiems, NSError *error) {
                        if ([JTProgressHUD isVisible]) {
                            [JTProgressHUD hide];
                        }
                        self.perDiems = perDiems;
                        [self.tableView reloadData];
                        if (completionHandler != nil) {
                            completionHandler(perDiems);
                        }
                    }];
}

- (void)updatePerDiems {
    [self fetchPerDiemsWithCompletion:^(NSArray<PerDiem *> *perDiems) {
        [self.refreshControl endRefreshing];
    }];
}

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

- (DayViewTableViewCell *)viewForPerDiem:(PerDiem *)perDiem {
    NSArray *cells = [self.tableView visibleCells];
    for (DayViewTableViewCell *cell in cells)
    {
        if (cell.perDiem == perDiem) {
            return cell;
        }
    }
    return nil;
}

@end
