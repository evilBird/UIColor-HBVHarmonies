//
//  ViewController.m
//  UIColor+HBVHarmoniesExample
//
//  Created by Travis Henspeter on 10/16/14.
//  Copyright (c) 2014 Herbivore. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+HBVHarmonies.h"

@interface ViewController ()
@property (nonatomic,strong)NSTimer *demoTimer;
@property (nonatomic,strong)NSArray *demoColors;
@property (nonatomic,strong)NSArray *colorNames;
@property (strong, nonatomic) IBOutlet UILabel *demoLabel;

- (IBAction)startDemo:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)doDemo
{
    UIColor *red = [UIColor redColor];
    UIColor *burgundy = [self burgundy];
    UIColor *blue = [UIColor blueColor];
    UIColor *aqua = [self aqua];
    UIColor *aquaComplement = [aqua complement];
    UIColor *jitter10 = [aquaComplement jitterWithPercent:10];
    UIColor *jitter50 = [jitter10 jitterWithPercent:50];
    UIColor *random1 = [UIColor randomColor];
    UIColor *random2 = [UIColor randomColor];
    self.demoColors = @[red,burgundy,blue,aqua,aquaComplement,jitter10,jitter50,random1,random2];
    self.colorNames = @[@"system red",@"Red component * 0.4 = burgundy",@"system blue",@"Blue + math = aqua",@"aqua complement",@"jitter by 10%",@"jitter by 50%",@"just a random color",@"just another random color"];
    [self nextColor];
    self.demoTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextColor) userInfo:nil repeats:YES];
}

- (void)nextColor
{
    static NSInteger index;
    if (index >= self.demoColors.count) {
        [self.demoTimer invalidate];
        self.demoTimer = nil;
        self.view.backgroundColor = [UIColor whiteColor];
        self.demoLabel.text = @"That's all folks!";
        self.demoLabel.textColor = [UIColor blackColor];
        return;
    }
    
    __weak ViewController *weakself =self;

    [UIView animateWithDuration:0.3 animations:^{
        weakself.view.backgroundColor = self.demoColors[index];
        weakself.demoLabel.text = self.colorNames[index];
        weakself.demoLabel.textColor = [self.view.backgroundColor complement];
    }];

    index++;
}

- (UIColor *)burgundy
{
    UIColor *red = [UIColor redColor];
    UIColor *burgundy = [red colorHarmonyWithExpressionOnComponents:^CGFloat *(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha) {
        CGFloat *result = malloc(sizeof(CGFloat) * 4);
        result[0] = red * 0.4;
        result[1] = green;
        result[2] = blue;
        result[3] = alpha;
        return result;
    }];
    
    return burgundy;
}

- (UIColor *)aqua
{
    UIColor *blue = [UIColor blueColor];
    UIColor *aqua = [blue colorHarmonyWithComponentArray:^NSArray *(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha) {
        CGFloat newRed = red;
        CGFloat newBlue = (blue-0.1)*(blue-0.1);
        CGFloat newGreen = newBlue * 0.9;
        CGFloat newAlpha = alpha;
        return @[@(newRed),@(newGreen),@(newBlue),@(newAlpha)];
    }];
    
    return aqua;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startDemo:(id)sender {
    
    [self doDemo];
}
@end
