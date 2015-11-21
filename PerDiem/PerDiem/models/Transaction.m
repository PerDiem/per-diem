//
//  Transaction.m
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/20/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "Transaction.h"

@implementation Transaction

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Transaction";
}

@end
