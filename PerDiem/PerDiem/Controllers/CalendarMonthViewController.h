//
//  CalendarMonthViewController.h
//  PerDiem
//
//  Created by Florent Bonomo on 12/1/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+DateTools.h"
#import <DateTools/DateTools.h>
#import "PerDiem.h"

@class CalendarMonthViewController;

@protocol CalendarMonthViewControllerDelegate <NSObject>

- (void)calendarMonthViewController:(CalendarMonthViewController *)controller
                        updateTitle:(NSString *)title;
- (void)calendarMonthViewController:(CalendarMonthViewController *)controller
           navigateToDayWithPerDiem:(PerDiem *)perDiem
                           animated:(BOOL)animated;

@end

@interface CalendarMonthViewController : UIViewController

@property (nonatomic, assign) id<CalendarMonthViewControllerDelegate> delegate;
@property (nonatomic, strong) NSDate *date;

- (void)updateTitle;
- (void)updateTitleWithTitle:(NSString *)title;
- (UIView *)viewForPerDiem:(PerDiem *)perDiem;

@end
