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

@property (weak, nonatomic) IBOutlet UIView *progressBarBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *progressBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
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
    self.progressBarBackgroundView.backgroundColor = [UIColor colorWithBudgetProgress:percentage alpha:.4];
    self.widthConstraint.constant = percentage * (self.frame.size.width / 100);
}


@end
