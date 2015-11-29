//
//  MonthsViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "MonthsViewController.h"
#import "MonthViewController.h"

@interface MonthsViewController () <CalendarInnerPeriodViewControllerDelegate>

@end

@implementation MonthsViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSDate *date = [((MonthViewController *)viewController).date dateBySubtractingMonths:1];
    return [self viewControllerWithDate:date];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSDate *date = [((MonthViewController *)viewController).date dateByAddingMonths:1];
    return [self viewControllerWithDate:date];
}


#pragma mark - Public

- (CalendarInnerPeriodViewController *)viewControllerWithDate:(NSDate *)date {
    MonthViewController *controller = [[MonthViewController alloc] initWithNibName:@"CalendarInnerPeriodViewController" bundle:nil];
    controller.date = date;
    controller.delegate = self;
    return controller;
}

@end
