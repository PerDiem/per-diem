//
//  WeekViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "WeekViewController.h"

@interface WeekViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation WeekViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
