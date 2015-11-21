//
//  User.m
//  Per Diem
//
//  Created by Francisco Rojas Gallegos on 11/20/15.
//  Copyright © 2015 Per Diem. All rights reserved.
//

#import "User.h"
#import "Organization.h"

@interface User ()
@end

@implementation User
@dynamic username, email, organization;

+ (void)load {
    [self registerSubclass];
}

+ (User *)currentUser {
    return (User *)[PFUser currentUser];
}


@end
