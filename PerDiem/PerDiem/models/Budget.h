//
//  Budget.h
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/20/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <Parse/Parse.h>

@class Organization;

@interface Budget : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Organization *organization;
@end
