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

@interface CalendarViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, CalendarPeriodViewControllerDelegate>

@property (strong, nonatomic) MonthsViewController *months;
@property (strong, nonatomic) WeeksViewController *weeks;
@property (strong, nonatomic) DaysViewController *days;
@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSArray *controllers;

@end

@implementation CalendarViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Prevent content being pushed by navigation controller
    // http://stackoverflow.com/a/19989136/237637
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.months = [[MonthsViewController alloc] initWithNibName:@"CalendarPeriodViewController" bundle:nil];
    self.weeks = [[WeeksViewController alloc] initWithNibName:@"CalendarPeriodViewController" bundle:nil];
    self.days = [[DaysViewController alloc] initWithNibName:@"CalendarPeriodViewController" bundle:nil];
    self.months.date = self.date;
    self.weeks.date = self.date;
    self.days.date = self.date;
    self.controllers = @[self.months, self.weeks, self.days];
    self.selectedController = self.days;

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
    
    
    UIBarButtonItem *todayButton = [[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStylePlain target:self action:@selector(onTodayButton)];
    
    self.navigationItem.leftBarButtonItem = todayButton;
}


#pragma mark - TabBarViewController

- (void)setupUI {
    [self setupBarItemWithImageNamed:@"calendar"];
}


#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(CalendarPeriodViewController *)viewController {
    NSUInteger index = [self.controllers indexOfObject:viewController];
    if (index == 0) {
        return nil;
    }
    return self.controllers[index - 1];    
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(CalendarPeriodViewController *)viewController {
    NSUInteger index = [self.controllers indexOfObject:viewController];
    
    if (index == [self.controllers count] - 1) {
        return nil;
    }
    return self.controllers[index + 1];
}


#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    self.pendingController = (CalendarPeriodViewController *)pendingViewControllers[0];
    self.pendingController.delegate = self;
    self.pendingController.selectedController.date = self.selectedController.selectedController.date;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    self.selectedController = self.pendingController;
    self.pendingController = nil;
}


#pragma mark - CalendarPeriodViewControllerDelegate

- (void)calendarPeriodViewController:(CalendarPeriodViewController *)periodViewController
   calendarInnerPeriodViewController:(CalendarInnerPeriodViewController *)innerPeriodViewController
                       navigateToDay:(DTTimePeriod *)timePeriod {
    
    self.selectedController = self.days;
    CalendarInnerPeriodViewController *selectedDayViewController = [self.days viewControllerWithDate:[timePeriod StartDate]];

    void (^completionBlock)(BOOL finished) = ^void(BOOL finished) {
        [self.pageController setViewControllers:@[self.selectedController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    };
    [self.selectedController.pageController setViewControllers:@[selectedDayViewController]
                                                     direction:UIPageViewControllerNavigationDirectionForward
                                                      animated:NO
                                                    completion:completionBlock];
}

- (void)calendarPeriodViewController:(CalendarPeriodViewController *)periodViewController
   calendarInnerPeriodViewController:(CalendarInnerPeriodViewController *)innerPeriodViewController
                      navigateToWeek:(DTTimePeriod *)timePeriod {
    self.selectedController = self.weeks;
    CalendarInnerPeriodViewController *selectedWeekViewController = [self.weeks viewControllerWithDate:[timePeriod StartDate]];

    void (^completionBlock)(BOOL finished) = ^void(BOOL finished) {
        [self.pageController setViewControllers:@[self.selectedController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    };
    [self.selectedController.pageController setViewControllers:@[selectedWeekViewController]
                                                     direction:UIPageViewControllerNavigationDirectionForward
                                                      animated:NO
                                                    completion:completionBlock];
}

- (void)calendarPeriodViewController:(CalendarPeriodViewController *)periodViewController
   calendarInnerPeriodViewController:(CalendarInnerPeriodViewController *)innerPeriodViewController
                     navigateToMonth:(DTTimePeriod *)timePeriod {
    self.selectedController = self.months;
    CalendarInnerPeriodViewController *selectedMonthViewController = [self.days viewControllerWithDate:[timePeriod StartDate]];
    void (^completionBlock)(BOOL finished) = ^void(BOOL finished) {
        [self.pageController setViewControllers:@[self.selectedController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    };
    [self.selectedController.pageController setViewControllers:@[selectedMonthViewController]
                                                     direction:UIPageViewControllerNavigationDirectionForward
                                                      animated:NO
                                                    completion:completionBlock];
}



#pragma mark - Private

- (NSDate *)date {
    if (!_date) {
        _date = [[NSDate alloc] init];
    }
    return _date;
}

- (void)onTodayButton {
    self.selectedController = self.days;
    CalendarInnerPeriodViewController *selectedDayViewController = [self.days viewControllerWithDate:[[NSDate alloc] init]];
    
    void (^completionBlock)(BOOL finished) = ^void(BOOL finished) {
        [self.pageController setViewControllers:@[self.selectedController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    };
    [self.selectedController.pageController setViewControllers:@[selectedDayViewController]
                                                     direction:UIPageViewControllerNavigationDirectionForward
                                                      animated:NO
                                                    completion:completionBlock];
}

@end
