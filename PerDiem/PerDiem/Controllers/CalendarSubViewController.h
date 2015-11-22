//
//  CalendarSubViewController.h
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarSubSubViewController.h"
#import "NSDate+DateTools.h"

@interface CalendarSubViewController : UIViewController

@property (nonatomic, strong) CalendarSubSubViewController *pendingController;
@property (nonatomic, strong) CalendarSubSubViewController *selectedController;
@property (nonatomic, strong) NSDate *date;

@end
