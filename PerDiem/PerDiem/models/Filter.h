//
//  Filter.h
//  PerDiem
//
//  Created by Chad Jewsbury on 12/2/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Filter : NSObject

@property (nonatomic, strong) NSMutableArray *budgets;
@property (nonatomic, strong) NSMutableArray *paymentTypes;
@property (nonatomic, assign) BOOL futures;

- (id)initWithFormFilters:(NSDictionary *)formFilters;

@end
