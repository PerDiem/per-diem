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

+(void) budgets:(void (^)(NSArray *budgets, NSError *error)) completation;
+(void) budgetsWithTransaction:(void (^)(NSArray *budgets, NSError *error)) completation;
+(void) budgetsWithTransactionWithinPeriod:(DTTimePeriod*) timePeriod completation:(void (^)(NSArray *budgets, NSError *error)) completation;
+(void) budgetsWithTransactionOnDay:(NSDate*) day completation: (void (^)(NSArray *budgets, NSError *error)) completation;
+(void) budgetNamedWithTransaction: (NSString*) name completation: (void (^)(NSArray *budgets, NSError *error)) completation;

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Organization *organization;
@property (nonatomic, strong) TransactionList *transactionList;

@end
