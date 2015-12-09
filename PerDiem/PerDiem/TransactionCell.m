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
@property (weak, nonatomic) IBOutlet UILabel *pipeLabel;

@end

@implementation TransactionCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
}

- (void)setTransaction:(Transaction *)transaction {
    _transaction = transaction;

    if (self.hideDate) {
        self.dateLabel.text = @"";
    } else {
        self.dateLabel.text = [self formatDate:self.transaction.transactionDate];
    }
    
    self.budgetLabel.text = [self.transaction.budget.name uppercaseString];

    if (self.transaction.paymentType) {
        self.paymentTypeLabel.text = self.transaction.paymentType.name;
    } else {
        self.pipeLabel.hidden = YES;
        self.paymentTypeLabel.text = @"";
    }
    self.summaryLabel.text = self.transaction.summary;
    self.amountLabel.text = [self.amountFormatter stringFromNumber:self.transaction.amount];
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
}

@end
