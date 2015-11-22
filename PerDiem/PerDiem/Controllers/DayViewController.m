//
//  DayViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "DayViewController.h"

@interface DayViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@end

@implementation DayViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dayLabel.text = [NSString stringWithFormat:@"Day %lu", (unsigned long)self.indexNumber];
}


#pragma mark - TabBarViewController

- (void)setupUI {
    [self setupBarItemWithImageNamed:@"calendar"];
}

@end
