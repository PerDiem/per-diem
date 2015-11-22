//
//  DaysViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "DaysViewController.h"
#import "DayViewController.h"

@interface DaysViewController ()

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


#pragma mark - Private

- (CalendarSubSubViewController *)viewControllerWithDate:(NSDate *)date {
    DayViewController *controller = [[DayViewController alloc] initWithNibName:@"DayViewController" bundle:nil];
    controller.date = date;
    return controller;
}


@end
