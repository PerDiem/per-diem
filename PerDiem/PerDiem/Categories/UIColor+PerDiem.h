//
//  UIColor+PerDiem.h
//  PerDiem
//
//  Created by Chad Jewsbury on 11/24/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (PerDiemColors)

+ (UIColor *)backgroundColor;
+ (UIColor *)emptyColor;
+ (UIColor *)emptyColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)okColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)okColor;
+ (UIColor *)warningColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)warningColor;
+ (UIColor *)alertColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)alertColor;
+ (UIColor *)colorWithProgress:(CGFloat)perDiemProgress alpha:(CGFloat)alpha;
+ (UIColor *)colorWithProgress:(CGFloat)perDiemProgress;

@end