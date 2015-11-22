//
//  TransactionFormViewController.h
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "XLFormViewController.h"

@class Transaction;

@interface TransactionFormViewController : XLFormViewController

-(id) initWithTransaction: (Transaction*) transaction;

@end
