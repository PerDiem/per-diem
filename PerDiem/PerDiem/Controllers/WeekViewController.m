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

@interface WeekViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WeekViewController


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(calendarInnerPeriodViewController:navigateToDay:)]) {
        [self.delegate calendarInnerPeriodViewController:self
                                           navigateToDay:[self periodAtIndex:indexPath]];
    }
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

- (NSString *)innerPeriodLabelWithPeriod:(DTTimePeriod *)period {
    return [[period StartDate] formattedDateWithFormat:@"ccc d"];
}

@end
