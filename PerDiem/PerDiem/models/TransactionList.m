//
//  TransactionList.m
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "TransactionList.h"
#import "Transaction.h"
#import "Budget.h"
#import "PaymentType.h"

@implementation TransactionList

- (id)initWithTransactions:(NSArray*)transactions {
    self = [super init];
    if (self) {
        self.transactions = [NSMutableArray arrayWithArray:transactions];
        float sum = 0;

        for (Transaction *transaction in transactions) {
            sum += [transaction.amount floatValue];
        }
        self.sum = [NSNumber numberWithFloat:sum];
    }
    return self;
}

- (void)addTransaction:(Transaction *)transaction {
    self.sum = [NSNumber numberWithFloat:[self.sum floatValue] + [transaction.amount floatValue]];
    [self.transactions addObject:transaction];
}

+ (id)transactionListWithTransactionList:(TransactionList *)transactionList
                        filterWithPeriod:(DTTimePeriod *)timePeriod {
    NSMutableArray *transactions = [NSMutableArray arrayWithArray:@[]];
    for (Transaction *transaction in transactionList.transactions) {
        if ([timePeriod containsDate:transaction.transactionDate
                            interval:DTTimePeriodIntervalOpen]) {
            [transactions addObject:transaction];
        }
    }
    return [[TransactionList alloc] initWithTransactions:transactions];
}

+ (id)transactionListWithTransactionList:(TransactionList *)transactionList
                        filterWithFilter:(Filter *)filter {
    NSMutableArray *transactions = [transactionList.transactions mutableCopy];
    for (Transaction *transaction in transactionList.transactions) {
        if (!filter.futures && [transaction.future boolValue]) {
            [transactions removeObject:transaction];
            continue;
        }
        if (![filter.paymentTypes containsObject:transaction.paymentType.objectId]) {
            [transactions removeObject:transaction];
            continue;
        }
        if (![filter.budgets containsObject:transaction.budget.objectId]) {
            [transactions removeObject:transaction];
            continue;
        }
    }

    return [[TransactionList alloc] initWithTransactions:transactions];
}

@end
