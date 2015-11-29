//
//  DayViewTableViewCell.h
//  PerDiem
//
//  Created by Florent Bonomo on 11/27/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionList.h"
#import "Budget.h"

@interface DayViewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (nonatomic, strong) TransactionList *transactionList;
@property (nonatomic, strong) NSArray<Budget *> *budgets;

@end
