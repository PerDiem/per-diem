//
//  CalendarViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "CalendarViewController.h"
#import "NavigationViewController.h"
#import "PageViewController.h"
#import "AddButtonView.h"
#import "TransactionFormViewController.h"
#import "CalendarTransition.h"

@interface CalendarViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, AddTransactionButtonDelegate, CalendarMonthViewControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSArray *controllers;
@property (weak, nonatomic) IBOutlet AddButtonView *addButtonView;
@property (strong, nonatomic) CalendarTransition *transitionHelper;

@end

@implementation CalendarViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.delegate = self;
    
    UIBarButtonItem *todayButton = [[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStylePlain target:self action:@selector(navigateToToday)];
    self.navigationItem.leftBarButtonItem = todayButton;
    
    self.selectedController = [self viewControllerWithDate:[[NSDate alloc] init]];
    [self.selectedController updateTitle];

    self.pageController = [[PageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                        navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                      options:nil];
    self.pageController.delegate = self;
    [self.pageController.view setFrame:self.view.bounds];
    [self.pageController setViewControllers:@[self.selectedController]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:YES
                                 completion:nil];
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
    
    self.addButtonView.delegate = self;
    [self.view bringSubviewToFront:self.addButtonView];
    
//    [self navigateToToday];
}

- (void)viewWillAppear:(BOOL)animated {
    // Clear cached controllers (that probably need their `date` to reflect the current state).
    // http://stackoverflow.com/a/21624169/237637
    self.pageController.dataSource = nil;
    self.pageController.dataSource = self;
}


#pragma mark - UINavigationControllerDelegate

- (CalendarTransition *)navigationController:(UINavigationController *)navigationController
             animationControllerForOperation:(UINavigationControllerOperation)operation
                          fromViewController:(UIViewController *)fromVC
                            toViewController:(UIViewController *)toVC {
    return self.transitionHelper;
}

- (CalendarTransition *)navigationController:(UINavigationController *)navigationController
 interactionControllerForAnimationController:(CalendarTransition *)animationController {
    if (!animationController.isPresenting) {
        return animationController;
    } else {
        return nil;
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(CalendarMonthViewController *)viewController {
    NSDate *date = [((CalendarMonthViewController *)viewController).date dateBySubtractingMonths:1];
    return [self viewControllerWithDate:date];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController
                viewControllerAfterViewController:(CalendarMonthViewController *)viewController {
    NSDate *date = [((CalendarMonthViewController *)viewController).date dateByAddingMonths:1];
    return [self viewControllerWithDate:date];
}


#pragma mark - UIPageViewControllerDelegate

-       (void)pageViewController:(UIPageViewController *)pageViewController
 willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    self.pendingController = (CalendarMonthViewController *)pendingViewControllers[0];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    self.selectedController = self.pendingController;
    self.pendingController = nil;
    [self.selectedController updateTitle];
}


#pragma mark - TabBarViewController

- (void)setupUI {
    [self setupBarItemWithImageNamed:@"calendar" title:@"This Month"];
}


#pragma mark - AddTransactionButtonDelegate

- (void)addButtonView:(UIView *)view
          onButtonTap:(UIButton *)button {
    TransactionFormViewController *vc = [[TransactionFormViewController alloc] init];
    NavigationViewController *nvc = [[NavigationViewController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nvc
                                            animated:YES
                                          completion:nil];
}


#pragma mark - CalendarMonthViewController

- (void)calendarMonthViewController:(CalendarMonthViewController *)controller
                        updateTitle:(NSString *)title {
    self.navigationItem.title = title;
}

- (void)calendarMonthViewController:(CalendarMonthViewController *)monthController
           navigateToDayWithPerDiem:(PerDiem *)perDiem
                           animated:(BOOL)animated {
    [self navigateToDayWithPerDiem:perDiem animated:animated];
}

#pragma mark - Private

- (void)navigateToDayWithPerDiem:(PerDiem *)perDiem
                        animated:(BOOL)animated {
    CalendarDayViewController *controller = [[CalendarDayViewController alloc] initWithNibName:@"CalendarDayViewController"
                                                                                        bundle:nil];
    controller.perDiem = perDiem;
    controller.transitionHelper = self.transitionHelper;
    self.transitionHelper.isPresenting = YES;
    [self.navigationController pushViewController:controller
                                         animated:animated];
}

- (void)navigateToToday {
    [PerDiem perDiemsForDate:[NSDate new]
                  completion:^(PerDiem *perDiem, NSError *error) {
                      if (!error) {
                          [self navigateToDayWithPerDiem:perDiem animated:NO];
                      }
                  }];
}

- (CalendarMonthViewController *)viewControllerWithDate:(NSDate *)date {
    CalendarMonthViewController *controller = [[CalendarMonthViewController alloc] initWithNibName:@"CalendarMonthViewController"
                                                                                            bundle:nil];
    controller.date = date;
    controller.delegate = self;
    return controller;
}

- (CalendarTransition *)transitionHelper {
    if (!_transitionHelper) {
        _transitionHelper = [[CalendarTransition alloc] initWithTransitioningController:self];
    }
    return _transitionHelper;
}

@end
