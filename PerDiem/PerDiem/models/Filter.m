//
//  Filter.m
//  PerDiem
//
//  Created by Chad Jewsbury on 12/2/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "Filter.h"

@implementation Filter

- (id)initWithFormFilters:(NSDictionary *)formFilters {
    self.budgets = [@[] mutableCopy];
    self.paymentTypes = [@[] mutableCopy];
    self.futures = YES;
    
    for (NSString *key in formFilters) {
        NSArray *values = [key componentsSeparatedByString:@"_"];

        if ([values[0] isEqualToString:@"futures"]) {
            self.futures = [[formFilters objectForKey:key] boolValue];
        } else if ([values[0] isEqualToString:@"budget"] &&
                   [[formFilters objectForKey:key] integerValue] == 1) {
            [self.budgets addObject:values[1]];
        } else if ([values[0] isEqualToString:@"paymentType"] &&
                   [[formFilters objectForKey:key] integerValue] == 1) {
            [self.paymentTypes addObject:values[1]];
        }
    }

    return self;
}

@end
