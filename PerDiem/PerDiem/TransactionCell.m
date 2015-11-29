//
//  TransactionCell.m
//  PerDiem
//
//  Created by Chad Jewsbury on 11/22/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "TransactionCell.h"
#import "Budget.h"
#import "PaymentType.h"
#import "UIColor+PerDiem.h"

@interface TransactionCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *budgetLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) NSNumberFormatter *amountFormatter;

@end

@implementation TransactionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setTransaction:(Transaction *)transaction {
    _transaction = transaction;

    self.dateLabel.text = [self formatDate:self.transaction.transactionDate];
    self.budgetLabel.text = self.transaction.budget.name;

    if (transaction.paymentType) {
        self.paymentTypeLabel.text = self.transaction.paymentType.name;
    }
    self.summaryLabel.text = self.transaction.summary;
    self.amountLabel.text = [self.amountFormatter stringFromNumber:self.transaction.amount];

    if (self.transaction.future) {
        [self styleFutureCell];
    }
}

- (void)styleFutureCell {
    self.summaryLabel.font = [UIFont italicSystemFontOfSize:15];
    self.amountLabel.font = [UIFont italicSystemFontOfSize:15];
    self.summaryLabel.textColor = [UIColor darkBlueColor];
    self.amountLabel.textColor = [UIColor darkBlueColor];
    [self setBackgroundColor:[UIColor lightBlueColorWithAlpha:.3]];
}

- (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd"];

    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

- (NSNumberFormatter *)amountFormatter {
    if (!_amountFormatter) {
        _amountFormatter = [[NSNumberFormatter alloc] init];
        [_amountFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    }
    return _amountFormatter;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
