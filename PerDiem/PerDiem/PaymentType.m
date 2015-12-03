//
//  PaymentType.m
//  PerDiem
//
//  Created by Chad Jewsbury on 11/22/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "PaymentType.h"
#import "User.h"

@implementation PaymentType
@dynamic name, organization;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"PaymentType";
}

+ (void) paymentTypes:(void (^)(NSArray *paymentTypes, NSError *error)) completion {
    PFQuery *query = [PFQuery queryWithClassName:@"PaymentType"];
    [query whereKey:@"organization" equalTo:[User currentUser].organization];
    [query includeKey:@"organization"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *paymentTypes, NSError * _Nullable error) {
        if(error) {
            completion(nil, error);
        } else {
            completion(paymentTypes, nil);
        }
    }];
}

@end
