//
//  CalendarViewController.h
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarViewController.h"
#import "CalendarMonthViewController.h"
#import "CalendarDayViewController.h"

@interface CalendarViewController : TabBarViewController

@property (nonatomic, strong) CalendarMonthViewController *pendingController;
@property (nonatomic, strong) CalendarMonthViewController *selectedController;

@end
