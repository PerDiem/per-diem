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

- (void)updateLabel {
    self.label.text = [NSString stringWithFormat:@"Date: %@", [self.date formattedDateWithStyle:NSDateFormatterShortStyle] ];
}

@end
