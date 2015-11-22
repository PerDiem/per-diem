//
//  CalendarSubViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "CalendarSubViewController.h"
#import "MonthViewController.h"
#import "WeekViewController.h"
#import "DayViewController.h"
#import "NSDate+DateTools.h"

@interface CalendarSubViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageController;

@end

@implementation CalendarSubViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    
    self.selectedController = [self viewControllerWithDate:self.date];
    self.pageController.delegate = self;
    [self.pageController.view setFrame:self.view.bounds];
    [self.pageController setViewControllers:@[self.selectedController]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:YES completion:nil];
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
}

- (void)viewWillAppear:(BOOL)animated {
    // Clear cacheed controllers (that probably need their `date` to reflect the current state).
    // http://stackoverflow.com/a/21624169/237637
    self.pageController.dataSource = nil;
    self.pageController.dataSource = self;
}


#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    return nil;
}


#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    self.pendingController = (CalendarSubSubViewController *)pendingViewControllers[0];
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    self.selectedController = self.pendingController;
    self.pendingController = nil;
}


#pragma mark - Private

- (CalendarSubSubViewController *)viewControllerWithDate:(NSDate *)date {
    return nil;
}

@end
