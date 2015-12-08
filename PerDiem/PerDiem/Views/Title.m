//
//  LoadingTitle.m
//  PerDiem
//
//  Created by Florent Bonomo on 12/8/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "Title.h"
#import "FBShimmeringView.h"

@interface Title ()

@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) FBShimmeringView *shimmeringView;

@end

@implementation Title

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubview:self.label];
}

- (void)loading {
    self.shimmeringView.shimmering = YES;
}

- (void)loaded {
    self.shimmeringView.shimmering = NO;
}

- (FBShimmeringView *)shimmeringView {
    if (!_shimmeringView) {
        _shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.label.bounds];
        [self addSubview:_shimmeringView];
        UILabel *loadingLabel = [[UILabel alloc] init];//[[self class] labelFactory];
        [loadingLabel setFrame:_shimmeringView.bounds];
        loadingLabel.textColor = [UIColor whiteColor];
        _shimmeringView.contentView = loadingLabel;
    }
    return _shimmeringView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[self class] labelFactory];
    }
    return _label;
}

+ (UILabel *)labelFactory {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200,32)];
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [label setFont:[UIFont boldSystemFontOfSize:18]];
    [label setTextColor:[UIColor blackColor]];
    return label;
}

@end
