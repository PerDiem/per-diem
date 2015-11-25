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
@dynamic amount, transactionDate, summary, note, user, budget,  paymentType, organization;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Transaction";
}

+ (void) transactions:(void (^)(TransactionList *transactions, NSError *error)) completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
    [query whereKey:@"organization" equalTo:[User currentUser].organization];
    [query includeKey:@"organization"];
    [query includeKey:@"budget"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *transactions, NSError * _Nullable error) {
        if(error) {
            completion(nil, error);
        } else {
            TransactionList *transactionList = [[TransactionList alloc] initWithTransactions:transactions];
            completion(transactionList, nil);
        }
    }];
}

+(void) transactionsWithinPeriod: (DTTimePeriod*) timePeriod completion: (void (^)(TransactionList *transactions, NSError *error)) completion {

    PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
    [query whereKey:@"organization" equalTo:[User currentUser].organization];
    [query includeKey:@"organization"];
    [query includeKey:@"budget"];
    [query whereKey:@"transactionDate" greaterThanOrEqualTo:[timePeriod StartDate]];
    [query whereKey:@"transactionDate" lessThanOrEqualTo:[timePeriod EndDate]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *transactions, NSError * _Nullable error) {
        if(error) {
            completion(nil, error);
        } else {
            TransactionList *transactionList = [[TransactionList alloc] initWithTransactions:transactions];
            completion(transactionList, nil);
        }
    }];
}

+(void) transactionsOnDay: (NSDate*) day completion: (void (^)(TransactionList *transactions, NSError *error)) completion {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *startDate = [calendar startOfDayForDate:day];
    NSDate *endDate = [[startDate dateByAddingDays:1] dateBySubtractingSeconds:1];

    DTTimePeriod *timePeriod = [[DTTimePeriod alloc] initWithStartDate:startDate endDate:endDate];

    [self transactionsWithinPeriod:timePeriod completion:completion];
}

-(void)deleteTransaction {
    [self deleteEventually];
}


@end
