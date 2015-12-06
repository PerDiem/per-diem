//
//  CalendarDayViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 12/1/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "CalendarDayViewController.h"
#import "TransactionsViewController.h"
#import "UIColor+PerDiem.h"

@interface CalendarDayViewController ()

@property (strong, nonatomic) TransactionsViewController *transactionsViewController;

@end

@implementation CalendarDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate *startOfDay = [[NSCalendar currentCalendar] startOfDayForDate:self.perDiem.date];
    DTTimePeriod *timePeriod = [DTTimePeriod timePeriodWithSize:DTTimePeriodSizeDay startingAt:startOfDay];
    [[timePeriod EndDate] dateBySubtractingSeconds:1];
    
    self.transactionsViewController = [[TransactionsViewController alloc] initWithTimePeriod:timePeriod];
    [self.transactionsView addSubview:self.transactionsViewController.view];
    self.perDiemView.perDiem = self.perDiem;
    [self.view sendSubviewToBack:self.transactionsView];
    self.view.backgroundColor = [UIColor backgroundColor];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.alpha = 0;
}

- (IBAction)onPerDiemPanGesture:(UIPanGestureRecognizer *)sender {
    if (self.transitionHelper) {
        self.transitionHelper.isPresenting = NO;
        [self.transitionHelper onPanGesture:sender];
    }
}

@end
