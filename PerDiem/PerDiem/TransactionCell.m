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
    }
    self.summaryLabel.text = self.transaction.summary;
    self.amountLabel.text = [self.amountFormatter stringFromNumber:self.transaction.amount];

//    if ([self.transaction.future boolValue]) {
//        [self styleFutureCell];
//    } else {
//        [self styleDefaultCell];
//    }
}

//- (void)styleFutureCell {
//    self.summaryLabel.font = [UIFont italicSystemFontOfSize:15];
//    self.amountLabel.font = [UIFont italicSystemFontOfSize:15];
//    self.summaryLabel.textColor = [UIColor darkBlueColor];
//    self.amountLabel.textColor = [UIColor darkBlueColor];
//    [self setBackgroundColor:[UIColor lightBlueColorWithAlpha:.3]];
//}
//
//- (void)styleDefaultCell {
//    self.summaryLabel.font = [UIFont systemFontOfSize:15];
//    self.amountLabel.font = [UIFont systemFontOfSize:15];
//    self.summaryLabel.textColor = [UIColor darkBlueColor];
//    self.amountLabel.textColor = [UIColor darkBlueColor];
//    [self setBackgroundColor:[UIColor whiteColor]];
//}

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
