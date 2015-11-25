//
//  CalendarSubSubViewController.h
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+DateTools.h"
#import <DateTools/DateTools.h>

@interface CalendarSubSubViewController : UIViewController

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) DTTimePeriod *timePeriod;

@end
