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

+ (void)perDiemsForPeriod:(DTTimePeriod *)period
               completion:(void (^)(NSArray<PerDiem *>*, NSError *error))completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();

        __block NSArray *budgets = nil;
        dispatch_group_async(group, queue, ^{
            PFQuery *queryBudgets = [PFQuery queryWithClassName:@"Budget"];
            budgets = [queryBudgets findObjects];
        });

        __block NSArray *transactions = nil;
        dispatch_group_async(group, queue, ^{
            PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
            [query whereKey:@"organization" equalTo:[User currentUser].organization];
            [query includeKey:@"organization"];
            [query includeKey:@"budget"];
            [query includeKey:@"paymentType"];
            [query whereKey:@"transactionDate" greaterThanOrEqualTo:[period StartDate]];
            [query whereKey:@"transactionDate" lessThanOrEqualTo:[period EndDate]];
            transactions = [query findObjects];
        });

        // Wait until the group is done
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

        CGFloat totalBudget = 0;
        for (Budget *budget in budgets) {
            totalBudget += [budget.amount floatValue];
        }
        
        NSMutableArray<PerDiem *> *perDiems = [NSMutableArray arrayWithArray:@[]];
        
        NSDate *day = [period StartDate];
        for (NSInteger dayIndex = 0; dayIndex < [period durationInDays]; dayIndex ++) {
            CGFloat totalSpentSoFar = 0;
            CGFloat spentOnThatDay = 0;
            for (Transaction *transaction in transactions) {
                if ([transaction.transactionDate earlierDate:day]) {
                    totalSpentSoFar += [transaction.amount floatValue];
                }
                if([transaction.transactionDate isSameDay:day]) {
                    spentOnThatDay += [transaction.amount floatValue];
                }
            }
            
            CGFloat dailyBudget = (totalBudget - totalSpentSoFar) / [day daysInMonth];
            PerDiem *perDiem = [[PerDiem alloc] init];
            perDiem.budget = @(dailyBudget);
            perDiem.spent = @(spentOnThatDay);
            perDiem.date = day;
            [perDiems addObject:perDiem];
            
            day = [day dateByAddingDays:1];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            completion(perDiems, nil);
        });
    });
}

+ (void)perDiemsForDate:(NSDate *)date
             completion:(void (^)(PerDiem *, NSError *error))completion {
    DTTimePeriod *period = [DTTimePeriod timePeriodWithSize:DTTimePeriodSizeDay
                                                 startingAt:[[NSCalendar currentCalendar] startOfDayForDate:date]];
    [[self class] perDiemsForPeriod:period
                         completion:^(NSArray<PerDiem *> *perDiems, NSError *error) {
                             if (!error) {
                                 PerDiem *perDiem = perDiems[0];
                                 completion(perDiem, nil);
                             } else {
                                 completion(nil, error);
                             }
                        }];
}

@end
