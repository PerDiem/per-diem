//
//  PerDiem.h
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/30/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DateTools.h"

@interface PerDiem : NSObject

+ (void)perDiemsForPeriod:(DTTimePeriod *)period
          relatedToPeriod:(DTTimePeriod *)relatedPeriod
               completion:(void (^)(NSMutableArray<PerDiem *>*, NSError *error))completion;
+ (void)perDiemsForPeriod:(DTTimePeriod *)period
               completion:(void (^)(NSMutableArray<PerDiem *>*, NSError *error))completion;
+ (void)perDiemsForDate:(NSDate *)date
             completion:(void (^)(PerDiem *, NSError *error))completion;

@property (strong, nonatomic) NSNumber *budget;
@property (strong, nonatomic) NSNumber *spent;
@property (strong, nonatomic) NSDate *date;

@end
