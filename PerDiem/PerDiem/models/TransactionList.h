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
#import "Filter.h"

@interface TransactionList : NSObject

@property (strong, nonatomic) NSMutableArray<Transaction *>*transactions;
@property (strong, nonatomic) NSNumber *sum;

- (id)initWithTransactions:(NSArray*)transactions;
+ (id)transactionListWithTransactionList:(TransactionList *)transactionList
                        filterWithPeriod:(DTTimePeriod *)timePeriod;

+ (id)transactionListWithTransactionList:(TransactionList *)transactionList
                        filterWithFilter:(Filter *)filter;

- (void)addTransaction:(Transaction *)transaction;
//- (void)updateTransaction:(Transaction *)transaction;

@end
