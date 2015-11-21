//
//  Organization.h
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <Parse/Parse.h>

@interface Organization : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

@property (nonatomic, strong) NSString *name;
@end
