//
//  TransactionCell.h
//  PerDiem
//
//  Created by Chad Jewsbury on 11/22/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>
#import "Transaction.h"

@interface TransactionCell : SWTableViewCell

@property (strong, nonatomic) Transaction *transaction;
@property (assign, nonatomic) BOOL hideDate;

@end
