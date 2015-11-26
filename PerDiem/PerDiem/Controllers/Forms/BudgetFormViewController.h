//
//  BudgetFormViewController.h
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/24/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <XLForm/XLForm.h>

@class Budget;

@protocol BudgetFormActionDelegate <NSObject>

@optional
-(void)budgetCreated:(Budget*) budget;
-(void)budgetUpdated:(Budget*) budget;
@end

@interface BudgetFormViewController : XLFormViewController

@property (weak, nonatomic) id<BudgetFormActionDelegate> delegator;
-(id) initWithBudget: (Budget*) budget;

@end
