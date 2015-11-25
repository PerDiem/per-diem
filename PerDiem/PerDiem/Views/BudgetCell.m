//
//  BudgetCell.m
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/24/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "BudgetCell.h"
#import "TransactionList.h"
#import "Budget.h"

@interface BudgetCell ()

@property (weak, nonatomic) IBOutlet UILabel *budgetNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *baseBudgetLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountSpentBudgetLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountBadgetLabel;
@property (weak, nonatomic) IBOutlet UIView *charView;

@end

@implementation BudgetCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setBudget:(Budget *)budget {
    _budget = budget;

    self.budgetNameLabel.text = budget.name;
    self.amountBadgetLabel.text = [NSString stringWithFormat:@"$ %@", budget.amount];
    if (budget.transactionList) {
        NSLog(@"%@", budget.transactionList.sum);
        self.amountSpentBudgetLabel.text = [NSString stringWithFormat:@"$ %@", budget.transactionList.sum ];
        self.amountSpentBudgetLabel.hidden = NO;
    } else {
        self.amountSpentBudgetLabel.hidden = YES;
    }
}

@end
