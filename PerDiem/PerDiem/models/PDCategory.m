//
//  Category.m
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/20/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "PDCategory.h"

@implementation PDCategory
+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Category";
}

@end
