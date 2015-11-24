//
//  Budget.m
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/20/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "Budget.h"
#import "Organization.h"
#import "TransactionList.h"
#import "User.h"

@implementation Budget
{
    TransactionList* _transactionList;
}

@dynamic amount, name, organization;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Budget";
}

+(void) budgets:(void (^)(NSArray *budgets, NSError *error)) completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Budget"];
    [query whereKey:@"organization" equalTo:[User currentUser].organization];
    [query findObjectsInBackgroundWithBlock:^(NSArray *budgets, NSError * _Nullable error) {
        if(error) {
            completion(nil, error);
        } else {
            completion(budgets, nil);
        }
    }];
}

+(NSArray*) groupTransactions:(NSArray*) transactions {
    NSArray* budgets = [transactions valueForKeyPath:@"@distinctUnionOfObjects.budget"];

    for (Budget *budget in budgets) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"budget.objectId =%@", budget.objectId];
        NSArray *transactionsForBudget = [transactions filteredArrayUsingPredicate:predicate];
        budget.transactionList = [[TransactionList alloc] initWithTransactions:transactionsForBudget];
    }
    return budgets;
}


+(void) budgetsWithTransaction:(void (^)(NSArray *budgets, NSError *error)) completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
    [query whereKey:@"organization" equalTo:[User currentUser].organization];
    [query includeKey:@"budget"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *transactions, NSError * _Nullable error) {
        if(error) {
            completion(nil, error);
        } else {
            completion([self groupTransactions:transactions], nil);
        }
    }];
}
+(void) budgetsWithTransactionWithinPeriod: (DTTimePeriod*) timePeriod completion:(void (^)(NSArray *budgets, NSError *error)) completion {

    PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
    [query whereKey:@"organization" equalTo:[User currentUser].organization];
    [query includeKey:@"budget"];
    [query whereKey:@"transactionDate" greaterThanOrEqualTo:[timePeriod StartDate]];
    [query whereKey:@"transactionDate" lessThanOrEqualTo:[timePeriod EndDate]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *transactions, NSError * _Nullable error) {
        if(error) {
            completion(nil, error);
        } else {
            completion([self groupTransactions:transactions], nil);
        }
    }];
}
+(void) budgetsWithTransactionOnDay:(NSDate*) day completion: (void (^)(NSArray *budgets, NSError *error)) completion {

}
+(void) budgetNamedWithTransaction: (NSString*) name completion: (void (^)(NSArray *budgets, NSError *error)) completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
    [query whereKey:@"organization" equalTo:[User currentUser].organization];
    [query includeKey:@"budget"];
    PFQuery *innerQuery = [PFQuery queryWithClassName:@"Budget"];
    [innerQuery whereKey:@"name" equalTo:name];
    [query whereKey:@"budget" matchesQuery:innerQuery];

    [query findObjectsInBackgroundWithBlock:^(NSArray *transactions, NSError * _Nullable error) {
        if(error) {
            completion(nil, error);
        } else {
            completion([self groupTransactions:transactions], nil);
        }
    }];
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    } else if (![object isKindOfClass:[Budget class]]) {
        return NO;
    }

    Budget *budget = (Budget *)object;
    return [self.objectId isEqual:budget.objectId];
}

- (NSUInteger)hash {
    return [self.objectId hash];
}

- (TransactionList*) transactionList {
    return _transactionList;
}
-(void) setTransactionList:(TransactionList *)transactionList {
    _transactionList = transactionList;
}

@end
