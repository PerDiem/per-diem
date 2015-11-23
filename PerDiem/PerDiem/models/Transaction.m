//
//  Transaction.m
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/20/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "Transaction.h"
#import "User.h"
#import "Budget.h"
#import "Organization.h"
#import "TransactionList.h"

@implementation Transaction
@dynamic amount, transactionDate, summary, note, user, budget, organization;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Transaction";
}

+ (void) transactions:(void (^)(TransactionList *transactions, NSError *error)) completation {
    PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
    [query whereKey:@"organization" equalTo:[User currentUser].organization];
    [query includeKey:@"organization"];
    [query includeKey:@"budget"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *transactions, NSError * _Nullable error) {
        if(error) {
            completation(nil, error);
        } else {
            TransactionList *transactionList = [[TransactionList alloc] initWithTransactions:transactions];
            completation(transactionList, nil);
        }
    }];
}
+(void) transactionsWithinPeriod: (DTTimePeriod*) timePeriod completation: (void (^)(TransactionList *transactions, NSError *error)) completation {

    PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
    [query whereKey:@"organization" equalTo:[User currentUser].organization];
    [query includeKey:@"organization"];
    [query includeKey:@"budget"];
    [query whereKey:@"transactionDate" greaterThanOrEqualTo:[timePeriod StartDate]];
    [query whereKey:@"transactionDate" lessThanOrEqualTo:[timePeriod EndDate]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *transactions, NSError * _Nullable error) {
        if(error) {
            completation(nil, error);
        } else {
            TransactionList *transactionList = [[TransactionList alloc] initWithTransactions:transactions];
            completation(transactionList, nil);
        }
    }];
}

+(void) transactionsOnDay: (NSDate*) day completation: (void (^)(TransactionList *transactions, NSError *error)) completation {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *startDate = [calendar startOfDayForDate:day];
    NSDate *endDate = [[startDate dateByAddingDays:1] dateBySubtractingSeconds:1];

    DTTimePeriod *timePeriod = [[DTTimePeriod alloc] initWithStartDate:startDate endDate:endDate];

    [self transactionsWithinPeriod:timePeriod completation:completation];
}


@end
