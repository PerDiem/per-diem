//
//  CalendarViewController.h
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarViewController.h"
#import "CalendarPeriodViewController.h"
#import "NSDate+DateTools.h"

@interface CalendarViewController : TabBarViewController

@property (nonatomic, strong) CalendarPeriodViewController *pendingController;
@property (nonatomic, strong) CalendarPeriodViewController *selectedController;
@property (strong, nonatomic) NSDate *date;

@end
