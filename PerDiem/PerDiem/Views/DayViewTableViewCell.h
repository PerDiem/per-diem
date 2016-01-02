//
//  DayViewTableViewCell.h
//  PerDiem
//
//  Created by Florent Bonomo on 11/27/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PerDiem.h"
#import "PerDiemView.h"

@interface DayViewTableViewCell : UITableViewCell

@property (nonatomic, strong) PerDiem *perDiem;
@property (weak, nonatomic) IBOutlet PerDiemView *perDiemView;
- (void)setPerDiem:(PerDiem *)perDiem animated:(BOOL)animated;

@end
