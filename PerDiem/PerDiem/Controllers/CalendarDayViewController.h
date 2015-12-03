//
//  CalendarDayViewController.h
//  PerDiem
//
//  Created by Florent Bonomo on 12/1/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DateTools/DateTools.h>
#import "PerDiem.h"

@interface CalendarDayViewController : UIViewController

@property (strong, nonatomic) DTTimePeriod *timePeriod;
@property (strong, nonatomic) PerDiem *perDiem;

@end
