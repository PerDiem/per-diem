//
//  MonthViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "MonthViewController.h"

@interface MonthViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation MonthViewController


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

- (void)updateLabel {
    self.label.text = [self.date formattedDateWithFormat:@"LLLL u"];
}

@end
