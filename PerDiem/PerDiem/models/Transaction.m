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

@implementation Transaction
@dynamic amount, transactionDate, summary, note, user, budget, organization;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Transaction";
}

@end
