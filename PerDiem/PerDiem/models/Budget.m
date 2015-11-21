//
//  Budget.m
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/20/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "Budget.h"
#import "Organization.h"

@implementation Budget
@dynamic amount, name, organization;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Budget";
}

@end
