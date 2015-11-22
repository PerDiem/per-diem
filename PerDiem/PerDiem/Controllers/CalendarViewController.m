//
//  CalendarViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "CalendarViewController.h"
#import "MonthsViewController.h"
#import "WeeksViewController.h"
#import "DaysViewController.h"

@interface CalendarViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) MonthsViewController *monthsController;
@property (strong, nonatomic) WeeksViewController *weeksController;
@property (strong, nonatomic) DaysViewController *daysController;
@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSArray *controllers;

@end

@implementation CalendarViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MonthsViewController *months = [[MonthsViewController alloc] initWithNibName:@"MonthsViewController" bundle:nil];
    WeeksViewController *weeks = [[WeeksViewController alloc] initWithNibName:@"WeeksViewController" bundle:nil];
    DaysViewController *days = [[DaysViewController alloc] initWithNibName:@"DaysViewController" bundle:nil];
    months.date = self.date;
    weeks.date = self.date;
    days.date = self.date;
    self.controllers = @[months, weeks, days];
    self.selectedController = days;

    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationVertical
                                                                        options:nil];
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    
    [self.pageController.view setFrame:self.view.bounds];
    [self.pageController setViewControllers:@[self.selectedController]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:YES
                                 completion:nil];
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
}


#pragma mark - TabBarViewController

- (void)setupUI {
    [self setupBarItemWithImageNamed:@"calendar"];
}


#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(CalendarSubViewController *)viewController {
    NSUInteger index = [self.controllers indexOfObject:viewController];
    if (index == 0) {
        return nil;
    }
    return self.controllers[index - 1];    
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(CalendarSubViewController *)viewController {
    NSUInteger index = [self.controllers indexOfObject:viewController];
    
    if (index == [self.controllers count] - 1) {
        return nil;
    }
    return self.controllers[index + 1];
}


#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    self.pendingController = (CalendarSubViewController *)pendingViewControllers[0];
    self.pendingController.selectedController.date = self.selectedController.selectedController.date;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    self.selectedController = self.pendingController;
    self.pendingController = nil;
}


#pragma mark - Private

- (NSDate *)date {
    if (!_date) {
        _date = [[NSDate alloc] init];
    }
    return _date;
}

@end
