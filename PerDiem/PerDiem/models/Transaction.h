//
//  Transaction.h
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/20/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <Parse/Parse.h>
#import "DateTools.h"

@class User;
@class Budget;
@class Organization;
@class TransactionList;

@interface Transaction : PFObject<PFSubclassing>
+ (NSString *)parseClassName;
+ (void) transactions:(void (^)(TransactionList *transactions, NSError *error)) completation;
+(void) transactionsWithinPeriod: (DTTimePeriod*) timePeriod completation: (void (^)(TransactionList *transactions, NSError *error)) completation;
+(void) transactionsOnDay: (NSDate*) day completation: (void (^)(TransactionList *transactions, NSError *error)) completation;


@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSDate *transactionDate;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *note;

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Budget *budget;
@property (nonatomic, strong) Organization *organization;
@end
