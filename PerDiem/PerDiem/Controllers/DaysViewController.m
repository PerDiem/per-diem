//
//  DaysViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "DaysViewController.h"
#import "DayViewController.h"

@interface DaysViewController () <CalendarInnerPeriodViewControllerDelegate>

@end

@implementation DaysViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSDate *date = [((DayViewController *)viewController).date dateBySubtractingDays:1];
    return [self viewControllerWithDate:date];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSDate *date = [((DayViewController *)viewController).date dateByAddingDays:1];
    return [self viewControllerWithDate:date];
}


#pragma mark - Public

- (CalendarInnerPeriodViewController *)viewControllerWithDate:(NSDate *)date {
    DayViewController *controller = [[DayViewController alloc] initWithNibName:@"CalendarInnerPeriodViewController" bundle:nil];
    controller.date = date;
    controller.delegate = self;
    return controller;
}


@end
