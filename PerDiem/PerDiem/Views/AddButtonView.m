//
//  AddButtonView.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/29/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "AddButtonView.h"

@interface AddButtonView ()

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation AddButtonView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initSubview];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubview];
    }
    return self;
}

- (void) initSubview {
    UINib *nib = [UINib nibWithNibName:@"AddButtonView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    self.view.frame = [self bounds];
    [self addSubview:self.view];
}

- (IBAction)buttonTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addButtonView:presentAlertController:)]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add New Item" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];

        UIAlertAction *newBudget = [UIAlertAction
                                 actionWithTitle:@"New Budget"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     if ([self.delegate respondsToSelector:@selector(addButtonView:alertControllerForNewBudget:)]) {
                                         [self.delegate addButtonView:self alertControllerForNewBudget:alert];
                                     }
                                 }];
        UIAlertAction *newTransaction = [UIAlertAction
                                         actionWithTitle:@"New Transaction"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             if ([self.delegate respondsToSelector:@selector(addButtonView:alertControllerForNewTransaction:)]) {
                                                 [self.delegate addButtonView:self alertControllerForNewTransaction:alert];
                                             }
                                         }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction * action) {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
        
        [alert addAction:newTransaction];
        [alert addAction:newBudget];
        [alert addAction:cancel];
        
        [self.delegate addButtonView:self presentAlertController:alert];
    }
}

@end
