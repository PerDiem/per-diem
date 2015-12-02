//
//  DayViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "DayViewController.h"
#import <DateTools/DateTools.h>

@interface DayViewController ()

@end

@implementation DayViewController


#pragma mark - Private

- (void)setDate:(NSDate *)date {
    [super setDate:date];

    NSDate *startOfDay = [[NSCalendar currentCalendar] startOfDayForDate:date];
    self.timePeriod = [DTTimePeriod timePeriodWithSize:DTTimePeriodSizeDay
                                            startingAt:startOfDay];
    [[self.timePeriod EndDate] dateBySubtractingSeconds:1];
}

- (void)updateTitle {
    if ([self.delegate respondsToSelector:@selector(calendarInnerPeriodViewController:updateTitle:)]) {
        [self.delegate calendarInnerPeriodViewController:self
                                             updateTitle:[self.date formattedDateWithFormat:@"cccc, LLL d"]];
    }
}

- (NSString *)innerPeriodLabelWithPeriod:(DTTimePeriod *)period {
    return @"";
}

@end
