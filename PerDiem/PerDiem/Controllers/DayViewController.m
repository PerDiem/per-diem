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

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation DayViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - Private

- (void)setDate:(NSDate *)date {
    [super setDate:date];

    NSDate *startOfDay = [[NSCalendar currentCalendar] startOfDayForDate:date];
    self.timePeriod = [DTTimePeriod timePeriodWithSize:DTTimePeriodSizeDay
                                            startingAt:startOfDay];
    [[self.timePeriod EndDate] dateBySubtractingSeconds:1];
}

- (void)updateLabel {
    self.label.text = [self.date formattedDateWithFormat:@"cccc, LLL d"];
}

@end
