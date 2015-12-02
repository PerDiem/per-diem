//
//  TransactionsViewController.h
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarViewController.h"
#import <DateTools/DateTools.h>

@class Budget;

@interface TransactionsViewController : TabBarViewController

@property (strong, nonatomic) Budget *budget;
@property (strong, nonatomic) DTTimePeriod *period;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (id)initWithBudget:(Budget *)budget;
- (id)initWithTimePeriod:(DTTimePeriod *)period;

@end
