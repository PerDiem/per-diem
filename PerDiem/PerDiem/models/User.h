//
//  User.h
//  Per Diem
//
//  Created by Francisco Rojas Gallegos on 11/20/15.
//  Copyright © 2015 Per Diem. All rights reserved.
//
#import <Parse/Parse.h>

@class Organization;

@interface User : PFUser<PFSubclassing>

+ (User *)currentUser;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) Organization *organization;

//-(NSArray*) transactions;

@end
