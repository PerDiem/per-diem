//
//  CalendarSubSubViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "CalendarSubSubViewController.h"

@interface CalendarSubSubViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation CalendarSubSubViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateLabel];
}


#pragma mark - Private

- (void)setDate:(NSDate *)date {
    _date = date;
    [self updateLabel];
}

- (void)setTimePeriod:(DTTimePeriod *)timePeriod {
    _timePeriod = timePeriod;
    [self updateLabel];
}

- (void)updateLabel {
    NSString *from = [[self.timePeriod StartDate] formattedDateWithStyle:NSDateFormatterFullStyle];
    NSString *to = [[self.timePeriod EndDate] formattedDateWithStyle:NSDateFormatterFullStyle];
    self.label.text = [NSString stringWithFormat:@"%@ to %@", from, to];
}

@end
