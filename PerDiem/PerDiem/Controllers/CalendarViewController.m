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
#import "BudgetFormViewController.h"
#import "SnapReceiptViewController.h"
#import "CalendarTransition.h"
#import "NSDate+DateTools.h"
#import "Transaction.h"

@interface CalendarViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, AddButtonDelegate, CalendarMonthViewControllerDelegate, UINavigationControllerDelegate, TransactionFormActionDelegate>

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
    
    self.pageController = [[PageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                        navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                      options:nil];
    self.pageController.delegate = self;
    [self.pageController.view setFrame:self.view.bounds];
    [self navigateToCurrentMonth];
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

- (void)pageViewController:(UIPageViewController *)pageViewController
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
    [self setupBarItemWithImageNamed:@"ic-calendar" selectedImageName:@"ic-calendar-selected" title:@"This Month"];
}


#pragma mark - AddButtonDelegate

- (void)addButtonView:(UIView *)view presentAlertController:(UIAlertController *)alert {
    [self.navigationController presentViewController:alert
                                            animated:YES
                                          completion:nil];
}

- (void)addButtonView:(UIView *)view alertControllerForNewBudget:(UIAlertController *)alert {
    BudgetFormViewController *vc = [[BudgetFormViewController alloc] init];
    NavigationViewController *nvc = [[NavigationViewController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nvc
                                            animated:YES
                                          completion:nil];
}

- (void)addButtonView:(UIView *)view alertControllerForNewTransaction:(UIAlertController *)alert {
    TransactionFormViewController *vc = [[TransactionFormViewController alloc] init];
    vc.delegate = self;
    NavigationViewController *nvc = [[NavigationViewController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nvc
                                            animated:YES
                                          completion:nil];
}

- (void)addButtonView:(UIView *)view alertControllerForScanReceipt:(UIAlertController *)alert {
    SnapReceiptViewController *vc = [[SnapReceiptViewController alloc] init];
    [self.navigationController pushViewController:vc
                                         animated:NO];    
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


#pragma mark - TransactionFormActionDelegate

- (void)transactionCreated:(Transaction *)transaction {
    PerDiem *perDiem = [self.selectedController.perDiems objectAtIndex:transaction.transactionDate.day - 1];
    perDiem.spent = [NSNumber numberWithFloat:([perDiem.spent floatValue] + [transaction.amount floatValue])];
    [self.selectedController.tableView reloadData];
}


#pragma mark - Private

- (void)navigateToCurrentMonth {
    [self navigateToCurrentMonthWithCompletion:nil animated:YES];
}

- (void)navigateToCurrentMonthWithCompletion:(void(^)(NSArray<PerDiem *> *))completionHandler animated:(BOOL)animated {
    NSDate *currentMonth = [NSDate date];
    self.selectedController = [self viewControllerWithDate:currentMonth
                                                completion:^(NSArray<PerDiem *> *perDiems) {
                                                    if (completionHandler != nil) {
                                                        completionHandler(perDiems);
                                                    }
    }];
    [self.selectedController updateTitle];
    [self.pageController setViewControllers:@[self.selectedController]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:animated
                                 completion:nil];
}

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
    NSDate *today = [NSDate date];
    
    void (^navigateToToday)(NSArray<PerDiem *> *perDiems) = ^void(NSArray<PerDiem *> *perDiems) {
        PerDiem *perDiem = [perDiems objectAtIndex:today.day - 1];
        [self navigateToDayWithPerDiem:perDiem animated:YES];
    };
    
    if ([self.selectedController.timePeriod containsDate:today interval:DTTimePeriodIntervalOpen]) {
        navigateToToday(self.selectedController.perDiems);
    } else {
        [self navigateToCurrentMonthWithCompletion:navigateToToday animated:YES];
    }
}

- (CalendarMonthViewController *)viewControllerWithDate:(NSDate *)date {
    return [self viewControllerWithDate:date completion:nil];
}

- (CalendarMonthViewController *)viewControllerWithDate:(NSDate *)date completion:(void(^)(NSArray<PerDiem *>*))completionHandler {
    CalendarMonthViewController *controller = [[CalendarMonthViewController alloc] initWithDate:date
                                                                                     completion:^(NSArray<PerDiem *> *perDiems) {
                                                                                         if (completionHandler != nil) {
                                                                                             completionHandler(perDiems);
                                                                                         }
                                                                                     }];
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
