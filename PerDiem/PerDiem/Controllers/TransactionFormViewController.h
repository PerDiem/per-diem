//
//  TransactionFormViewController.h
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "XLFormViewController.h"

@class Transaction;

@protocol TransactionFormActionDelegate <NSObject>

@optional
-(void)transactionCreated:(Transaction*) transaction;
-(void)transactionUpdated:(Transaction*) transaction;

@end

@interface TransactionFormViewController : XLFormViewController

@property (weak, nonatomic) id<TransactionFormActionDelegate> delegator;

-(id) initWithTransaction: (Transaction*) transaction;

@end
