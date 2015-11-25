//
//  TransactionsViewController.h
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarViewController.h"

@class Budget;

@interface TransactionsViewController : TabBarViewController

- (id) initWithBudget: (Budget*) budget;
@property (strong, nonatomic) Budget* budget;

@end
