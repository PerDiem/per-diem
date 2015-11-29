//
//  TransactionList.h
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DateTools.h"
#import "Transaction.h"

@interface TransactionList : NSObject

@property (strong, nonatomic) NSArray<Transaction *>*transactions;
@property (strong, nonatomic) NSNumber *sum;

- (id)initWithTransactions:(NSArray*)transactions;
+ (id)transactionListWithTransactionList:(TransactionList *)transactionList
                        filterWithPeriod:(DTTimePeriod *)timePeriod;

@end
