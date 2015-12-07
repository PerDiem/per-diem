//
//  AddButtonView.h
//  PerDiem
//
//  Created by Florent Bonomo on 11/29/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddButtonView;

@protocol AddButtonDelegate <NSObject>

- (void)addButtonView:(AddButtonView *)view presentAlertController:(UIAlertController *)alert;
- (void)addButtonView:(UIView *)view alertControllerForNewBudget:(UIAlertController *)alert;
- (void)addButtonView:(UIView *)view alertControllerForNewTransaction:(UIAlertController *)alert;


@end

@interface AddButtonView : UIView

@property (nonatomic, assign) id<AddButtonDelegate> delegate;

@end
