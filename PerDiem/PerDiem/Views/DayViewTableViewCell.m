//
//  DayViewTableViewCell.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/27/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "DayViewTableViewCell.h"

@interface DayViewTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation DayViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setTransactionList:(TransactionList *)transactionList {
    _transactionList = transactionList;
}

- (void)setBudgets:(NSArray<Budget *> *)budgets {
    _budgets = budgets;
    [self updateUI];
}

- (void)updateUI {
    self.label.text = @"";
    self.widthConstraint.constant = 0;
    
    if (self.budgets != nil && self.transactionList != nil) {
        NSNumber *budgetsSum = [NSNumber numberWithInt:0];
        for (Budget *budget in self.budgets) {
            budgetsSum = @([budgetsSum integerValue] + [budget.amount integerValue]);
        }
        NSNumber *transactionsSum = [NSNumber numberWithInt:0];
        for (Transaction *transaction in self.transactionList.transactions) {
            transactionsSum = @([transactionsSum integerValue] + [transaction.amount integerValue]);
        }
        
        NSNumberFormatter *amountFormatter = [[NSNumberFormatter alloc] init];
        [amountFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        NSString *budgetsSumString = [amountFormatter stringFromNumber:budgetsSum];
        NSString *transactionsSumString = [amountFormatter stringFromNumber:transactionsSum];
        
        NSInteger budgetUsedPercentage = [transactionsSum integerValue] * 100 / [budgetsSum integerValue];
        NSInteger pointsPerPercent = self.frame.size.width / 100;
        if (budgetUsedPercentage > 0) {
            self.label.text = [NSString stringWithFormat:@"%@ / %@", transactionsSumString, budgetsSumString];
            self.widthConstraint.constant = budgetUsedPercentage * pointsPerPercent;
        }

    }
}

@end
