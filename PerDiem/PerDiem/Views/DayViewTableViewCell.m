//
//  DayViewTableViewCell.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/27/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "DayViewTableViewCell.h"
#import "PerDiemView.h"

@interface DayViewTableViewCell ()

@end

@implementation DayViewTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setPerDiem:(PerDiem *)perDiem animated:(BOOL)animated {
    self.perDiem = perDiem;
    [self.perDiemView setPerDiem:perDiem animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.perDiemView updateUI];
}

@end
