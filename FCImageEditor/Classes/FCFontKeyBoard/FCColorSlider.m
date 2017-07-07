//
//  FCColorSilder.m
//  FCFontKeyboard
//
//  Created by zz on 2017/7/5.
//  Copyright © 2017年 FlyCatkin. All rights reserved.
//

#import "FCColorSlider.h"

#define kColorSilderHeight 6
@interface FCColorSlider ()
@property(strong,nonatomic) CAGradientLayer *gradientLayer;
@property(strong,nonatomic) NSMutableArray *colors;
@end

@implementation FCColorSlider

//+ (instancetype)colorSilderViewWithFrame:

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDatas];
        [self setupViews];
    }
    return self;
}

- (void)initDatas
{
    NSArray *colors = @[[UIColor whiteColor], [UIColor grayColor], [UIColor blackColor], [UIColor greenColor],[UIColor blueColor], [UIColor brownColor],[UIColor cyanColor],[UIColor magentaColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor redColor],[UIColor yellowColor]];
    self.colors = [NSMutableArray arrayWithArray:colors];
}

- (void)setupViews
{
    for (int i = 0; i< self.colors.count; i++) {
        UIView *view = [[UIView alloc] init];
        view.tag = 1000 + i;
        view.backgroundColor = self.colors[i];
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor colorWithWhite:200/255.f alpha:1].CGColor;
        [self addSubview:view];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (int i = 0; i< self.colors.count; i++) {
        UIView *view = [self viewWithTag:1000+i];
        CGFloat viewW = CGRectGetWidth(self.frame) / (self.colors.count * 1.0);
        CGFloat viewX = viewW * i;
        view.frame = CGRectMake(viewX, CGRectGetMidY(self.bounds) - 0.5 * kColorSilderHeight, viewW, kColorSilderHeight);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    CGFloat x = touchPoint.x;
    CGFloat viewW = CGRectGetWidth(self.frame) / (self.colors.count * 1.0);
    NSInteger index = (NSInteger)(x / viewW);
    UIColor *color = self.colors[index];
    if (self.colorDelegate && [self.colorDelegate respondsToSelector:@selector(colorSliderSelectColor:)]) {
        [self.colorDelegate colorSliderSelectColor:color];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    CGFloat x = touchPoint.x;
    CGFloat viewW = CGRectGetWidth(self.frame) / (self.colors.count * 1.0);
    NSInteger index = (NSInteger)(x / viewW);
    if (index >= self.colors.count) {
        index = self.colors.count - 1;
    }else if(index < 0) {
        index = 0;
    }
    UIColor *color = self.colors[index];
    if (self.colorDelegate && [self.colorDelegate respondsToSelector:@selector(colorSliderSelectColor:)]) {
        [self.colorDelegate colorSliderSelectColor:color];
    }
}

@end
