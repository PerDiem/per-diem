//
//  BudgetFormViewController.h
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/24/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <XLForm/XLForm.h>

@class Budget;

@interface BudgetFormViewController : XLFormViewController

-(id) initWithBudget: (Budget*) budget;

@end
