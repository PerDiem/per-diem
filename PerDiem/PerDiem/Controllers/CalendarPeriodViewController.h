//
//  CalendarPeriodViewController.h
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarInnerPeriodViewController.h"
#import "NSDate+DateTools.h"

@class CalendarPeriodViewController;

@protocol CalendarPeriodViewControllerDelegate <NSObject>

@optional
- (void)calendarPeriodViewController:(CalendarPeriodViewController *)periodViewController
   calendarInnerPeriodViewController:(CalendarInnerPeriodViewController *)innerPeriodViewController
                       navigateToDay:(DTTimePeriod *)timePeriod;
- (void)calendarPeriodViewController:(CalendarPeriodViewController *)periodViewController
   calendarInnerPeriodViewController:(CalendarInnerPeriodViewController *)innerPeriodViewController
                      navigateToWeek:(DTTimePeriod *)timePeriod;
- (void)calendarPeriodViewController:(CalendarPeriodViewController *)periodViewController
   calendarInnerPeriodViewController:(CalendarInnerPeriodViewController *)innerPeriodViewController
                     navigateToMonth:(DTTimePeriod *)timePeriod;

@end

@interface CalendarPeriodViewController : UIViewController

@property (nonatomic, assign) id<CalendarPeriodViewControllerDelegate> delegate;
@property (nonatomic, strong) CalendarInnerPeriodViewController *pendingController;
@property (nonatomic, strong) CalendarInnerPeriodViewController *selectedController;
@property (strong, nonatomic) UIPageViewController *pageController;
@property (nonatomic, strong) NSDate *date;

- (CalendarInnerPeriodViewController *)viewControllerWithDate:(NSDate *)date;

@end
