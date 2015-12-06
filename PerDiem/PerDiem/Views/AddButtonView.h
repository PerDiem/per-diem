//
//  AddButtonView.h
//  PerDiem
//
//  Created by Florent Bonomo on 11/29/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddButtonView;

@protocol AddTransactionButtonDelegate <NSObject>

- (void)addButtonView:(AddButtonView *)view presentAlertController:(UIAlertController *)alert;
- (void)addButtonView:(UIView *)view alertControllerForNewBudget:(UIAlertController *)alert;
- (void)addButtonView:(UIView *)view alertControllerForNewTransaction:(UIAlertController *)alert;
- (void)addButtonView:(UIView *)view alertControllerForScanReceipt:(UIAlertController *)alert;

@end

@interface AddButtonView : UIView

@property (nonatomic, assign) id<AddTransactionButtonDelegate> delegate;

@end
