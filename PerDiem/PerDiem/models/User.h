//
//  User.h
//  Per Diem
//
//  Created by Francisco Rojas Gallegos on 11/20/15.
//  Copyright © 2015 Per Diem. All rights reserved.
//
#import <Parse/Parse.h>
#import "DateTools.h"

@class Organization;

@interface User : PFUser<PFSubclassing>

+ (User *)currentUser;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) Organization *organization;

-(void) transactions:(void (^)(NSArray *transactions, NSError *error)) completation;
-(void) transactionsWithinPeriod: (DTTimePeriod*) timePeriod completation: (void (^)(NSArray *transactions, NSError *error)) completation;
-(void) transactionsOnDay: (NSDate*) day completation: (void (^)(NSArray *transactions, NSError *error)) completation;

-(void) budgets: (void (^)(NSArray *budgets, NSError *error)) completation;
@end
