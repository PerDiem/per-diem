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

@property (weak, nonatomic) IBOutlet PerDiemView *perDiemView;

@end

@implementation DayViewTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setPerDiem:(PerDiem *)perDiem {
    _perDiem = perDiem;
    self.perDiemView.perDiem = perDiem;
}

@end
