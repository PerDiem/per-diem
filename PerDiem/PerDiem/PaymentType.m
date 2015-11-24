//
//  PaymentType.m
//  PerDiem
//
//  Created by Chad Jewsbury on 11/22/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "PaymentType.h"

@implementation PaymentType
@dynamic name, organization;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"PaymentType";
}

@end
