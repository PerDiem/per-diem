//
//  DayViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "DayViewController.h"

@interface DayViewController ()

@end

@implementation DayViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - TabBarViewController

- (void)setupUI {
    [self setupBarItemWithTitle:@"Today" imageNamed:@"calendar"];
}

@end
