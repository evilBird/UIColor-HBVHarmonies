//
//  UIColor+HBVHarmonies.h
//  Herbivore
//
//  Created by Travis Henspeter on 3/5/14.
//  Copyright (c) 2014 Herbivore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HBVHarmonies)

//Create a color harmony from the caller by applying one expression to each color component (R,G,B, range 0.0 - 1.0) of a UIColor instance. Expression block must return a CGFloat, double, or float. Alpha is set directly.
- (UIColor *)colorHarmonyWithExpression:(CGFloat(^)(CGFloat value))expression alpha:(CGFloat)alpha;

//Create a color harmony from the caller by apply an abitrary expression to each color component and alpha channel. Expression block must return a C array containing 4 CGFloats, doubles, or floats.
- (UIColor *)colorHarmonyWithExpressionOnComponents:(CGFloat*(^)(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha))componentsExpression;

//Same as above, but expression block must return an NSArray containing NSNumber instances representing the R-G-B-A components of the desired return instance. For those squeamish about using malloc.
- (UIColor *)colorHarmonyWithComponentArray:(NSArray*(^)(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha))componentsExpression;

//Class method, returns an instance of UIColor composed of random (uniform) R-G-B components
+ (UIColor *)randomColor;

//Convenience method returns color complement of the calling instance by applying the expression (1-x) to each color component
- (UIColor *)complement;

//Returns an instance of UIColor in which the caller's RGB components are jittered by a proportion (percent, range 0.0 - 100.0) of the caller's RGB component values.
- (UIColor *)jitterWithPercent:(CGFloat)percent;

@end
