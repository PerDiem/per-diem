//
//  PaymentType.h
//  PerDiem
//
//  Created by Chad Jewsbury on 11/22/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <Parse/Parse.h>

@class Organization;

@interface PaymentType : PFObject<PFSubclassing>
+ (NSString *)parseClassName;


@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Organization *organization;

@end
