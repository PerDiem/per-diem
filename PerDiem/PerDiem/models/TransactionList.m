//
//  TransactionList.m
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "TransactionList.h"
#import "Transaction.h"

@implementation TransactionList

- (id)initWithTransactions:(NSArray*)transactions {
    self = [super init];
    if (self) {
        self.transactions = transactions;
        float sum = 0;

        for (Transaction *transaction in transactions) {
            sum += [transaction.amount floatValue];
        }
        self.sum = [NSNumber numberWithFloat:sum];
    }
    return self;
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

@end
