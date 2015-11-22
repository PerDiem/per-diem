//
//  WeeksViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "WeeksViewController.h"
#import "WeekViewController.h"

@interface WeeksViewController ()

@end

@implementation WeeksViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSDate *date = [((WeekViewController *)viewController).date dateBySubtractingWeeks:1];
    return [self viewControllerWithDate:date];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSDate *date = [((WeekViewController *)viewController).date dateByAddingWeeks:1];
    return [self viewControllerWithDate:date];
}


#pragma mark - Private

- (CalendarSubSubViewController *)viewControllerWithDate:(NSDate *)date {
    WeekViewController *controller = [[WeekViewController alloc] initWithNibName:@"WeekViewController" bundle:nil];
    controller.date = date;
    return controller;
}

@end
