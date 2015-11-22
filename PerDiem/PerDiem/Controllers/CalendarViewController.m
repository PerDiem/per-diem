//
//  CalendarViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "CalendarViewController.h"
#import "DayViewController.h"

@interface CalendarViewController () <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;

@end

@implementation CalendarViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageController.dataSource = self;
    [self.pageController.view setFrame:self.view.bounds];
    [self.pageController setViewControllers:@[[self viewControllerAtIndex:0]]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:YES completion:nil];
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
}


#pragma mark - TabBarViewController

- (void)setupUI {
    [self setupBarItemWithImageNamed:@"calendar"];
}


#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = ((DayViewController *)viewController).indexNumber;

    if (index == 0) {
        return nil;
    }

    return [self viewControllerAtIndex:index - 1];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = ((DayViewController *)viewController).indexNumber;

    if (index >= 3) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index + 1];
}


#pragma mark - Private

- (DayViewController *)viewControllerAtIndex:(NSUInteger)index {
    DayViewController *vc = [[DayViewController alloc] initWithNibName:@"DayViewController" bundle:nil];
    vc.indexNumber = index;
    return vc;
}

@end
