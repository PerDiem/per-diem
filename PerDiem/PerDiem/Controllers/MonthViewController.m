//
//  MonthViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "MonthViewController.h"
#import "NSDate+DateTools.h"

@interface MonthViewController ()

@end

@implementation MonthViewController


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger incompleteWeek = (int)self.timePeriod.durationInDays % 4 > 0 ? 1 : 0;
    return 4 + incompleteWeek;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(calendarInnerPeriodViewController:navigateToWeek:)]) {
        [self.delegate calendarInnerPeriodViewController:self
                                          navigateToWeek:[self periodAtIndex:indexPath]];
    }
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - Private

- (void)setDate:(NSDate *)date {
    [super setDate:date];
    
    NSDate *startOfDay = [[NSCalendar currentCalendar] startOfDayForDate:date];
    NSInteger monthStartedDaysAgo = startOfDay.day - 1;
    NSDate *startOfMonth = [startOfDay dateBySubtractingDays:monthStartedDaysAgo];
    self.timePeriod = [DTTimePeriod timePeriodWithSize:DTTimePeriodSizeMonth
                                            startingAt:startOfMonth];
}

- (void)updateTitle {
    if ([self.delegate respondsToSelector:@selector(calendarInnerPeriodViewController:updateTitle:)]) {
        [self.delegate calendarInnerPeriodViewController:self
                                             updateTitle:[self.date formattedDateWithFormat:@"LLLL u"]];
    }
}

- (NSString *)innerPeriodLabelWithPeriod:(DTTimePeriod *)period {
    NSString *startDate = [[period StartDate] formattedDateWithFormat:@"LLL d"];
    NSString *endDate = [[period EndDate] formattedDateWithFormat:@"LLL d"];
    return [NSString stringWithFormat:@"%@ - %@", startDate, endDate];
}

- (DTTimePeriod *)periodAtIndex:(NSIndexPath *)indexPath {
    NSDate *day = [[self.timePeriod StartDate] dateByAddingWeeks:indexPath.row];
    NSDate *endOfMonthDay = [[[self.timePeriod StartDate] dateByAddingMonths:1] dateBySubtractingDays:1];

    DTTimePeriod *period;
    if (indexPath.row >= 4 && ![day isSameDay:endOfMonthDay]) {
        period = [DTTimePeriod timePeriodWithStartDate:day endDate:endOfMonthDay];
    } else {
        period = [DTTimePeriod timePeriodWithSize:DTTimePeriodSizeWeek
                                       startingAt:day];
        [period shortenWithAnchorDate:DTTimePeriodAnchorStart size:DTTimePeriodSizeSecond];
    }

    return period;
}

@end
