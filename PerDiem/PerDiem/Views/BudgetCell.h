//
//  BudgetCell.h
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/24/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>

@class Budget;

@interface BudgetCell : SWTableViewCell

@property(strong, nonatomic) Budget *budget;
@property (weak, nonatomic) IBOutlet UIImageView *arrowView;

@end
