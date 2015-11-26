//
//  Budget.h
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/20/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <Parse/Parse.h>
#import "DateTools.h"

@class Organization;
@class TransactionList;
@interface Budget : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

+(void) budgets:(void (^)(NSArray *budgets, NSError *error)) completion;
+(void) budgetsWithTransaction:(void (^)(NSArray *budgets, NSError *error)) completion;
+(void) budgetsWithTransactionWithinPeriod:(DTTimePeriod*) timePeriod completion:(void (^)(NSArray *budgets, NSError *error)) completion;
+(void) budgetsWithTransactionOnDay:(NSDate*) day completion: (void (^)(NSArray *budgets, NSError *error)) completion;
+(void) budgetNamedWithTransaction: (NSString*) name completion: (void (^)(Budget *budget, NSError *error)) completion;

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Organization *organization;
@property (nonatomic, strong) TransactionList *transactionList;

@end
