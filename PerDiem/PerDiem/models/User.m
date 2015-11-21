//
//  User.m
//  Per Diem
//
//  Created by Francisco Rojas Gallegos on 11/20/15.
//  Copyright © 2015 Per Diem. All rights reserved.
//

#import "User.h"

@interface User ()
@end

@implementation User

+ (void)load {
    [self registerSubclass];
}

+ (User *)currentUser {
    return (User *)[PFUser currentUser];
}


@end
