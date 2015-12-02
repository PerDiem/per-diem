//
//  PerDiem.m
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/30/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "PerDiem.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Budget.h"
#import "Transaction.h"


@implementation PerDiem

+ (void) PerDiemOnDay: (NSDate*) day completion: (void (^)(PerDiem *perDiem, NSError *error)) completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();

        __block NSArray *budgets = nil;
        dispatch_group_async(group, queue, ^{
            PFQuery *queryBudgets = [PFQuery queryWithClassName:@"Budget"];
            budgets = [queryBudgets findObjects];
        });

        NSDate *startDate = [NSDate dateWithYear:day.year month:day.month day:1];
        NSDate *endDate = [startDate dateByAddingMonths:1];

        __block NSArray *transactions = nil;
        dispatch_group_async(group, queue, ^{
            PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
            [query whereKey:@"organization" equalTo:[User currentUser].organization];
            [query includeKey:@"organization"];
            [query includeKey:@"budget"];
            [query includeKey:@"paymentType"];
            [query whereKey:@"transactionDate" greaterThanOrEqualTo:startDate];
            [query whereKey:@"transactionDate" lessThanOrEqualTo:endDate];
            transactions = [query findObjects];
        });

        //Wait until the group is done
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

        float totalBudget = 0;
        for (Budget *budget in budgets) {
            totalBudget += [budget.amount floatValue];
        }
        float totalSpentSoFar = 0;
        float spentOnThatDay = 0;
        for (Transaction *transaction in transactions) {
            if ([transaction.transactionDate earlierDate:day]) {
                totalSpentSoFar += [transaction.amount floatValue];
            }
            if([transaction.transactionDate isSameDay:day]) {
                spentOnThatDay += [transaction.amount floatValue];
            }
        }

        float dailyBudget = (totalBudget - totalSpentSoFar) / [day daysInMonth];
        PerDiem *per = [[PerDiem alloc] init];
        per.budget = @(dailyBudget);
        per.spent = @(spentOnThatDay);
        dispatch_sync(dispatch_get_main_queue(), ^{
            completion(per, nil);
        });
    });

}

@end
