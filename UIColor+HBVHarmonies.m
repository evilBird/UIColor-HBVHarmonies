//
//  UIColor+HBVHarmonies.m
//  Herbivore
//
//  Created by Travis Henspeter on 3/5/14.
//  Copyright (c) 2014 Herbivore. All rights reserved.
//

#import "UIColor+HBVHarmonies.h"

static void _getRGBA(UIColor *color, CGFloat rgba[])
{
    rgba[0] = CGColorGetComponents(color.CGColor)[0];
    rgba[1] = CGColorGetComponents(color.CGColor)[1];
    rgba[2] = CGColorGetComponents(color.CGColor)[2];
    rgba[3] = CGColorGetComponents(color.CGColor)[3];
}

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

- (UIColor *)setAlpha:(CGFloat)alpha
{
    CGFloat myComponents[4];
    _getRGBA(self, myComponents);
    return [UIColor colorWithRed:myComponents[0] green:myComponents[1] blue:myComponents[2] alpha:alpha];
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

- (UIColor *)blendWithColor:(UIColor *)color
{
    return [self blendWithColor:color weight:0.5];
}

- (UIColor *)blendWithColor:(UIColor *)color weight:(CGFloat)weight
{
    CGFloat myComponents[4];
    CGFloat theirComponents[4];
    CGFloat blendedComponents[4];
    _getRGBA(self, myComponents);
    _getRGBA(color, theirComponents);
    blendedComponents[0] = (myComponents[0] * (1.0 - weight) + theirComponents[0] * weight);
    blendedComponents[1] = (myComponents[1] * (1.0 - weight) + theirComponents[1] * weight);
    blendedComponents[2] = (myComponents[2] * (1.0 - weight) + theirComponents[2] * weight);
    blendedComponents[3] = (myComponents[3] * (1.0 - weight) + theirComponents[3] * weight);
    
    return [UIColor colorWithRed:blendedComponents[0] green:blendedComponents[1] blue:blendedComponents[2] alpha:blendedComponents[3]];

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
