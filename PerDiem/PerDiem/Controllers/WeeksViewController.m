//
//  WeeksViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "WeeksViewController.h"
#import "WeekViewController.h"

@interface WeeksViewController () <CalendarInnerPeriodViewControllerDelegate>

@end

@implementation WeeksViewController


#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSDate *date = [((WeekViewController *)viewController).date dateBySubtractingWeeks:1];
    return [self viewControllerWithDate:date];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSDate *date = [((WeekViewController *)viewController).date dateByAddingWeeks:1];
    return [self viewControllerWithDate:date];
}


#pragma mark - Public

- (CalendarInnerPeriodViewController *)viewControllerWithDate:(NSDate *)date {
    WeekViewController *controller = [[WeekViewController alloc] initWithNibName:@"CalendarInnerPeriodViewController" bundle:nil];
    controller.date = date;
    controller.delegate = self;
    return controller;
}

@end
