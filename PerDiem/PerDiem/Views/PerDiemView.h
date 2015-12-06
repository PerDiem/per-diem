//
//  PerDiemView.h
//  PerDiem
//
//  Created by Florent Bonomo on 12/2/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PerDiem.h"

@interface PerDiemView : UIView

@property (strong, nonatomic) IBOutlet UIView *view;
@property (nonatomic, strong) PerDiem *perDiem;

@end
