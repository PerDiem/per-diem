//
//  User.m
//  Per Diem
//
//  Created by Francisco Rojas Gallegos on 11/20/15.
//  Copyright © 2015 Per Diem. All rights reserved.
//

#import "User.h"
#import "Organization.h"
#import "Transaction.h"

@interface User ()
@end

@implementation User
@dynamic username, email, organization;

+ (void)load {
    [self registerSubclass];
}

+ (User *)currentUser {
    return (User *)[PFUser currentUser];
}

+ (void)logOut {
    [super logOut];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userLoggedOut" object:nil];
}

- (void)transactions:(void (^)(NSArray *transactions, NSError *error)) completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
    [query whereKey:@"organization" equalTo:self.organization];
    [query includeKey:@"organization"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *transactions, NSError * _Nullable error) {
        if(error) {
            completion(nil, error);
        } else {
            completion(transactions, nil);
        }
    }];
}

- (void)transactionsWithinPeriod: (DTTimePeriod*) timePeriod completion: (void (^)(NSArray *transactions, NSError *error)) completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
    [query whereKey:@"organization" equalTo:self.organization];
    [query includeKey:@"organization"];
    [query whereKey:@"transactionDate" greaterThanOrEqualTo:[timePeriod StartDate]];
    [query whereKey:@"transactionDate" lessThanOrEqualTo:[timePeriod EndDate]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *transactions, NSError * _Nullable error) {
        if(error) {
            completion(nil, error);
        } else {
            completion(transactions, nil);
        }
    }];
}

- (void)transactionsOnDay: (NSDate*) day completion: (void (^)(NSArray *transactions, NSError *error)) completion {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *startDate = [calendar startOfDayForDate:day];
    NSDate *endDate = [[startDate dateByAddingDays:1] dateBySubtractingSeconds:1];

    DTTimePeriod *timePeriod = [[DTTimePeriod alloc] initWithStartDate:startDate endDate:endDate];

    [self transactionsWithinPeriod:timePeriod completion:completion];
}

- (void)budgets: (void (^)(NSArray *budgets, NSError *error)) completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Budget"];
    [query whereKey:@"organization" equalTo:self.organization];
    [query findObjectsInBackgroundWithBlock:^(NSArray *budgets, NSError * _Nullable error) {
        if(error) {
            completion(nil, error);
        } else {
            completion(budgets, nil);
        }
    }];
}

@end
