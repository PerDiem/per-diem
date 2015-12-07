//
//  UIColor+PerDiem.m
//  PerDiem
//
//  Created by Chad Jewsbury on 11/24/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "UIColor+PerDiem.h"

@implementation UIColor (PerDiemColors)

// Background Color
+ (UIColor *)backgroundColor {
    return [UIColor colorWithRed:0.17 green:0.23 blue:0.26 alpha:1.0];
}

// PerDiem Empty
+ (UIColor *)emptyColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:0.22 green:0.30 blue:0.35 alpha:alpha];
}
+ (UIColor *)emptyColor {
    return [[self class] emptyColorWithAlpha:1];
}

// PerDiem OK
+ (UIColor *)okColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:0.35 green:0.68 blue:0.28 alpha:alpha];
}
+ (UIColor *)okColor {
    return [[self class] okColorWithAlpha:1];
}

// PerDiem Warning
+ (UIColor *)warningColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:1.00 green:0.78 blue:0.00 alpha:alpha];
}
+ (UIColor *)warningColor {
    return [[self class] warningColorWithAlpha:1];
}

// PerDiem Alert
+ (UIColor *)alertColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:0.91 green:0.29 blue:0.21 alpha:alpha];
}
+ (UIColor *)alertColor {
    return [[self class] alertColorWithAlpha:1];
}

// PerDiem Progress
+ (UIColor *)colorWithProgress:(CGFloat)perDiemProgress alpha:(CGFloat)alpha {
    UIColor *color = [[self class] emptyColorWithAlpha:alpha];
    if (perDiemProgress > 0) {
        color = [[self class] okColorWithAlpha:alpha];
    }
    if (perDiemProgress >= 60) {
        color = [[self class] warningColorWithAlpha:alpha];
    }
    if (perDiemProgress >= 100) {
        color = [[self class] alertColorWithAlpha:alpha];
    }
    return color;
}
+ (UIColor *)colorWithProgress:(CGFloat)perDiemProgress {
    return [[self class] colorWithProgress:perDiemProgress alpha:1];
}

// Perdiem Input
+ (UIColor *)inputColor {
    return [[self class] emptyColorWithAlpha:1];
}


@end