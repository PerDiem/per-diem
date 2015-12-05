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
+ (UIColor *)transactionColor;
+ (UIColor *)darkGreyColor;
+ (UIColor *)darkGreyColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)darkBlueColor;
+ (UIColor *)darkBlueColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)lightBlueColor;
+ (UIColor *)lightBlueColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)lightGreyColor;
+ (UIColor *)lightGreyColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)redHighlightColor;
+ (UIColor *)redHighlightColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)greenHighlightColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)greenHighlightColor;
+ (UIColor *)yellowHighlightColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)yellowHighlightColor;
+ (UIColor *)colorWithBudgetProgress:(CGFloat)budgetProgress alpha:(CGFloat)alpha;
+ (UIColor *)colorWithBudgetProgress:(CGFloat)budgetProgress;

@end