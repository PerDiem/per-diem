//
//  User.h
//  Per Diem
//
//  Created by Francisco Rojas Gallegos on 11/20/15.
//  Copyright © 2015 Per Diem. All rights reserved.
//

#import <Parse/Parse.h>

@interface User : PFUser<PFSubclassing>

+ (User *)currentUser;
@end
