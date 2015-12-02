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
    if ([self.delegate respondsToSelector:@selector(addButtonView:onButtonTap:)]) {
        [self.delegate addButtonView:self onButtonTap:sender];
    }
}

@end
