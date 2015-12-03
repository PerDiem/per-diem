//
//  DayViewTableViewCell.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/27/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "DayViewTableViewCell.h"
#import "UIColor+PerDiem.h"

@interface DayViewTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *progressBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *spentLabel;
@property (weak, nonatomic) IBOutlet UILabel *budgetLabel;
@end

@implementation DayViewTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setPerDiem:(PerDiem *)perDiem {
    _perDiem = perDiem;
    [self updateUI];
}

- (void)updateUI {
    NSNumberFormatter *amountFormatter = [[NSNumberFormatter alloc] init];
    [amountFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];

    self.dayLabel.text = [self.perDiem.date formattedDateWithFormat:@"ccc d"];
    
    NSString *budgetAmountString = [amountFormatter stringFromNumber:self.perDiem.budget];
    self.budgetLabel.text = [NSString stringWithFormat:@"%@ total", budgetAmountString];
    
    NSString *spentAmountString = [amountFormatter stringFromNumber:self.perDiem.spent];
    self.spentLabel.text = [NSString stringWithFormat:@"%@", spentAmountString];
    
    
    NSInteger percentage = 0;
    if (self.perDiem.budget > 0) {
        percentage = [self.perDiem.spent integerValue] * 100 / [self.perDiem.budget integerValue];
    }
    
    self.progressBarView.backgroundColor = [UIColor colorWithBudgetProgress:percentage alpha:.3];
    self.contentView.backgroundColor = [UIColor colorWithBudgetProgress:percentage alpha:.1];
    self.widthConstraint.constant = percentage * (self.frame.size.width / 100);
}

@end
