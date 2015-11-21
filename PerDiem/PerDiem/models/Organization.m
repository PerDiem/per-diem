//
//  Organization.m
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "Organization.h"

@implementation Organization
@dynamic name;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Organization";
}


@end
