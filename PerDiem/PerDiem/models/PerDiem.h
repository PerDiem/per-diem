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

+ (void) PerDiemOnDay: (NSDate*) day completion: (void (^)(PerDiem *perDiem, NSError *error)) completion;

@property (strong, nonatomic) NSNumber *budget;
@property (strong, nonatomic) NSNumber *spent;

@end
