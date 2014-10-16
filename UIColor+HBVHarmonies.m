//
//  UIColor+HBVHarmonies.m
//  Herbivore
//
//  Created by Travis Henspeter on 3/5/14.
//  Copyright (c) 2014 Herbivore. All rights reserved.
//

#import "UIColor+HBVHarmonies.h"

@implementation UIColor (HBVHarmonies)

#pragma mark - Public methods

- (UIColor *)jitterWithPercent:(CGFloat)percent
{
    UIColor *result = nil;
    CGFloat newComponents[3];
    for (NSInteger index = 0; index < 3; index ++) {
        CGFloat oldComponent = CGColorGetComponents(self.CGColor)[index];
        CGFloat random = ((CGFloat)arc4random_uniform(200) - 100.0f) * 0.01;
        CGFloat newComponent = oldComponent + random * percent * 0.01;
        newComponents[index] = [UIColor clipValue:newComponent withMin:0 max:1.0f];
    }
    
    result = [UIColor colorWithRed:newComponents[0] green:newComponents[1] blue:newComponents[2] alpha:1.0];
    return result;
}

- (UIColor *)complement
{
    return [self colorHarmonyWithExpression:^CGFloat(CGFloat value) {
       return 1.0f - value;
    } alpha:1.0];
}

+ (UIColor *)randomColor
{
    CGFloat red = (CGFloat)arc4random_uniform(255)/255.0f;
    CGFloat green = (CGFloat)arc4random_uniform(255)/255.0f;
    CGFloat blue = (CGFloat)arc4random_uniform(255)/255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

- (UIColor *)colorHarmonyWithExpression:(CGFloat(^)(CGFloat value))expression alpha:(CGFloat)alpha
{
    UIColor *result = nil;
    CGFloat newComponents[3];
    for (NSInteger index = 0; index < 3; index ++) {
        CGFloat oldComponent = CGColorGetComponents(self.CGColor)[index];
        CGFloat expressionResult = expression(oldComponent);
        newComponents[index] = [UIColor clipValue:expressionResult withMin:0 max:1.0f];
    }
    
    result = [UIColor colorWithRed:newComponents[0] green:newComponents[1] blue:newComponents[2] alpha:alpha];
    return result;
}

- (UIColor *)colorHarmonyWithExpressionOnComponents:(CGFloat*(^)(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha))componentsExpression;
{
    UIColor *result = nil;
    CGFloat oldComponents[4];
    for (NSInteger index = 0; index < 4; index ++) {
        CGFloat oldComponent = CGColorGetComponents(self.CGColor)[index];
        oldComponents[index] = oldComponent;
    }
    
    CGFloat *expressionResult = malloc(sizeof(CGFloat) * 4);
    expressionResult = componentsExpression(oldComponents[0],oldComponents[1],oldComponents[2],oldComponents[3]);
    CGFloat newComponents[4];
    for (NSInteger index = 0; index < 4; index ++) {
        newComponents[index] = [UIColor clipValue:expressionResult[index] withMin:0.0 max:1.0];
    }
    
    result = [UIColor colorWithRed:newComponents[0] green:newComponents[1] blue:newComponents[2] alpha:newComponents[3]];
    return result;
}

- (UIColor *)colorHarmonyWithComponentArray:(NSArray*(^)(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha))componentsExpression
{
    UIColor *result = nil;
    CGFloat oldComponents[4];
    for (NSInteger index = 0; index < 4; index ++) {
        CGFloat oldComponent = CGColorGetComponents(self.CGColor)[index];
        oldComponents[index] = oldComponent;
    }
    
    NSArray *expressionResult = componentsExpression(oldComponents[0],oldComponents[1],oldComponents[2],oldComponents[3]);
    CGFloat newComponents[4];
    for (NSInteger index = 0; index < expressionResult.count; index++) {
        newComponents[index] = [expressionResult[index] doubleValue];
    }
    
    result = [UIColor colorWithRed:newComponents[0] green:newComponents[1] blue:newComponents[2] alpha:newComponents[3]];
    return result;
}

#pragma mark - Private methods

+ (CGFloat)clipValue:(CGFloat)value withMin:(CGFloat)min max:(CGFloat)max
{
    CGFloat result;
    if (value < min) {
        result = min;
    } else if (value > max) {
        result = max;
    } else {
        result = value;
    }
    return result;
}

@end
