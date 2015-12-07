//
//  PerDiemView.m
//  PerDiem
//
//  Created by Florent Bonomo on 12/2/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "PerDiemView.h"
#import "UIColor+PerDiem.h"

@interface PerDiemView ()

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *spentLabel;

@end

@implementation PerDiemView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initSubview];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubview];
    }
    return self;
}

- (void) initSubview {
    UINib *nib = [UINib nibWithNibName:@"PerDiemView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    self.view.frame = [self bounds];
    self.view.backgroundColor = [UIColor backgroundColor];
    [self addSubview:self.view];
}

- (void)setPerDiem:(PerDiem *)perDiem {
    _perDiem = perDiem;
    [self updateUI];
}

- (void)addRoundedCorners {
    [self.progressBarBackgroundView setNeedsLayout];
    [self.progressBarBackgroundView layoutIfNeeded];

    [self.progressBarBackgroundView.layer setCornerRadius:5.0f];
    [self.progressBarBackgroundView.layer setMasksToBounds:YES];

    CGFloat height = self.bounds.size.height - 6;
    CGFloat width = self.bounds.size.width -12;

    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    NSLog(@"Width: %f", width);
    NSLog(@"Height: %f", height);
    shape.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, width, height)
                                       byRoundingCorners:UIRectCornerBottomRight|UIRectCornerTopRight
                                             cornerRadii:CGSizeMake(height / 2, height / 2)].CGPath;
    self.progressBarBackgroundView.layer.mask = shape;
}

- (void)updateUI {
    NSNumberFormatter *amountFormatter = [[NSNumberFormatter alloc] init];
    [amountFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    self.dayLabel.text = [[self.perDiem.date formattedDateWithFormat:@"ccc d"] uppercaseString];
    
    NSString *budgetAmountString = [amountFormatter stringFromNumber:self.perDiem.budget];
    NSString *spentAmountString = [amountFormatter stringFromNumber:self.perDiem.spent];
    self.spentLabel.text = [NSString stringWithFormat:@"Spent %@ of %@", spentAmountString, budgetAmountString];
    NSInteger percentage = 0;
    if (self.perDiem.budget > 0) {
        percentage = [self.perDiem.spent integerValue] * 100 / [self.perDiem.budget integerValue];
    }

    self.progressBarView.backgroundColor = [UIColor colorWithBudgetProgress:percentage alpha:1];
    self.progressBarBackgroundWidthConstraint.constant = self.frame.size.width - 12;
    self.progressBarBackgroundView.backgroundColor = [UIColor colorWithBudgetProgress:percentage alpha:.4];
    self.progressBarWidthConstraint.constant = percentage * (self.frame.size.width / 100);
    [self addRoundedCorners];
}


@end
