//
//  CalendarViewController.h
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarViewController.h"
#import "CalendarSubViewController.h"
#import "NSDate+DateTools.h"

@interface CalendarViewController : TabBarViewController

@property (nonatomic, strong) CalendarSubViewController *pendingController;
@property (nonatomic, strong) CalendarSubViewController *selectedController;
@property (strong, nonatomic) NSDate *date;

@end
