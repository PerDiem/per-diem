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

- (void)loading:(BOOL)loading {
    self.shimmeringView.shimmering = loading;
    self.label.hidden = loading;
    self.loadingLabel.hidden = !loading;
}

- (FBShimmeringView *)shimmeringView {
    if (!_shimmeringView) {
        _shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.label.bounds];
        [self addSubview:_shimmeringView];
        self.loadingLabel = [self labelFactory];
        self.loadingLabel.textColor = [UIColor whiteColor];
        self.loadingLabel.text = @"Loading";
        self.loadingLabel.hidden = YES;
        [self.loadingLabel sizeToFit];
        _shimmeringView.contentView = self.loadingLabel;
//        _shimmeringView.shimmeringOpacity = 0.7;
        _shimmeringView.shimmeringSpeed = 200;
    }
    return _shimmeringView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [self labelFactory];
    }
    return _label;
}

- (UILabel *)labelFactory {
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont boldSystemFontOfSize:18]];
    [label setTextColor:[UIColor whiteColor]];
    return label;
}

@end
