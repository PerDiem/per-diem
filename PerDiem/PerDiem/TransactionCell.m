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

@interface TransactionCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *budgetLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end

@implementation TransactionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setTransaction:(Transaction *)transaction {
    _transaction = transaction;

    self.dateLabel.text = [self formatDate:self.transaction.transactionDate];
    self.budgetLabel.text = self.transaction.budget.name;
    self.paymentTypeLabel.text = self.transaction.paymentType.name;
    self.summaryLabel.text = self.transaction.summary;

    // @TODO - make common currency formatter method to be used throughout app.
    self.amountLabel.text = [NSString stringWithFormat:@"$%.2f", [self.transaction.amount floatValue]];
}

- (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm/yy"];

    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
