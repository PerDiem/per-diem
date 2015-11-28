//
//  UIColor+PerDiem.m
//  PerDiem
//
//  Created by Chad Jewsbury on 11/24/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "UIColor+PerDiem.h"

@implementation UIColor (PerDiemColors)

// Colors from: https://color.adobe.com/Rise-color-theme-3648332/
// Dark Grey: #2B3A42 [UIColor colorWithRed:0.17 green:0.23 blue:0.26 alpha:1.0];
// Dark Blue: #3F5765 [UIColor colorWithRed:0.25 green:0.34 blue:0.40 alpha:1.0];
// Light Blue: #BDD4DE [UIColor colorWithRed:0.74 green:0.83 blue:0.87 alpha:1.0];
// Light Grey: #EFEFEF [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];
// RedHighlight: #E74C3C [UIColor colorWithRed:0.91 green:0.30 blue:0.24 alpha:1.0];

// Dark Grey
+ (UIColor *)darkGreyColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:0.17 green:0.23 blue:0.26 alpha:alpha];
}
+ (UIColor *)darkGreyColor {
    return [[self class] darkGreyColorWithAlpha:1];
}

// Dark Blue
+ (UIColor *)darkBlueColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:0.25 green:0.34 blue:0.40 alpha:alpha];
}
+ (UIColor *)darkBlueColor {
    return [[self class] darkBlueColorWithAlpha:1];
}

// Light Blue
+ (UIColor *)lightBlueColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:0.74 green:0.83 blue:0.87 alpha:alpha];
}
+ (UIColor *)lightBlueColor {
    return [[self class] lightBlueColorWithAlpha:1];
}

// Light Grey
+ (UIColor *)lightGreyColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:alpha];
}
+ (UIColor *)lightGreyColor {
    return [[self class] lightGreyColorWithAlpha:1];
}

// Red Highlight
+ (UIColor *)redHighlightColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:0.91 green:0.30 blue:0.24 alpha:alpha];
}
+ (UIColor *)redHighlightColor {
    return [[self class] redHighlightColorWithAlpha:1];
}

// Green Highlight
+ (UIColor *)greenHighlightColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:0.36 green:0.72 blue:0.36 alpha:alpha];
}
+ (UIColor *)greenHighlightColor {
    return [[self class] greenHighlightColorWithAlpha:1];
}

// Yellow Highlight
+ (UIColor *)yellowHighlightColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:1.00 green:0.84 blue:0.00 alpha:alpha];
}
+ (UIColor *)yellowHighlightColor {
    return [[self class] yellowHighlightColorWithAlpha:1];
}

// Budget Progress
+ (UIColor *)colorWithBudgetProgress:(CGFloat)budgetProgress alpha:(CGFloat)alpha {
    UIColor *color = [[self class] greenHighlightColorWithAlpha:alpha];
    if (budgetProgress >= 60) {
        color = [[self class] yellowHighlightColorWithAlpha:alpha];
    }
    if (budgetProgress >= 100) {
        color = [[self class] redHighlightColorWithAlpha:alpha];
    }
    return color;
}
+ (UIColor *)colorWithBudgetProgress:(CGFloat)budgetProgress {
    return [[self class] colorWithBudgetProgress:budgetProgress alpha:1];
}

@end