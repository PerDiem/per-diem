//
//  CalendarInnerPeriodViewController.h
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+DateTools.h"
#import <DateTools/DateTools.h>
#import "TransactionList.h"
#import "Budget.h"

@class CalendarInnerPeriodViewController;

@protocol CalendarInnerPeriodViewControllerDelegate <NSObject>

@optional
- (void)calendarInnerPeriodViewController:(CalendarInnerPeriodViewController *)controller
                            navigateToDay:(DTTimePeriod *)timePeriod;
- (void)calendarInnerPeriodViewController:(CalendarInnerPeriodViewController *)controller
                           navigateToWeek:(DTTimePeriod *)timePeriod;
- (void)calendarInnerPeriodViewController:(CalendarInnerPeriodViewController *)controller
                          navigateToMonth:(DTTimePeriod *)timePeriod;

@end

@interface CalendarInnerPeriodViewController : UIViewController

@property (nonatomic, assign) id<CalendarInnerPeriodViewControllerDelegate> delegate;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) DTTimePeriod *timePeriod;
@property (strong, nonatomic) TransactionList *transactionList;
@property (strong, nonatomic) NSArray<Budget *> *budgets;

@end
