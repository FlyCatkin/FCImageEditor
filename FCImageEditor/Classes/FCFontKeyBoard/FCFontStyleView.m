//
//  FCFontStyleView.m
//  FCFontKeyboard
//
//  Created by zz on 2017/7/5.
//  Copyright © 2017年 FlyCatkin. All rights reserved.
//

#import "FCFontStyleView.h"
#import "FCColorSlider.h"
#import "FCAlphaSlider.h"

#define kUIScreenWidth [UIScreen mainScreen].bounds.size.width
#define kUIScreenHeight [UIScreen mainScreen].bounds.size.height
@interface FCFontStyleView ()<FCColorSliderDelegate, FCAlphaSliderDelegate>
@property (strong, nonatomic) UIView *colorView;
@property (strong, nonatomic) FCColorSlider *colorSlider;
@property (strong, nonatomic) UILabel *alphaLabel;
@property (strong, nonatomic) FCAlphaSlider *alphaSlider;

@end

@implementation FCFontStyleView

#pragma mark - public

- (void)setInitailColor:(UIColor *)color
{
    self.colorView.backgroundColor = [color colorWithAlphaComponent:1.0];
    const CGFloat *componentColors = CGColorGetComponents(color.CGColor);
    
    CGFloat alpha = componentColors[3];
    self.alphaLabel.text = [NSString stringWithFormat:@"%ld%%", (NSInteger)(alpha * 100)];
    [self.alphaSlider setInitailValue:alpha * 100];
}

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self setupSubViews];
        [self layoutViews];
    }
    return self;
}

- (void)setupSubViews{
    [self addSubview:self.colorView];
    [self addSubview:self.colorSlider];
    [self addSubview:self.alphaLabel];
    [self addSubview:self.alphaSlider];
    self.backgroundColor = [UIColor whiteColor];
}

#pragma mark - update views
- (void)layoutViews
{
    self.colorView.frame = CGRectMake(12, 40, 26, 26);
    self.colorView.layer.cornerRadius = 8.f;
    self.colorView.layer.borderWidth = 2.0;
    self.colorView.layer.borderColor = [UIColor grayColor].CGColor;
    
    
    CGFloat colorSilderX = CGRectGetMaxX(self.colorView.frame) + 12;
    CGFloat colorSilderW = kUIScreenWidth - colorSilderX - 20;
    CGFloat colorSilderH = 30;
    CGFloat colorSilderY = CGRectGetMidY(self.colorView.frame) - colorSilderH / 2;
    self.colorSlider.frame = CGRectMake(colorSilderX, colorSilderY, colorSilderW, colorSilderH);
    
    self.alphaLabel.frame = CGRectMake(12, CGRectGetMaxY(self.colorView.frame) + 40, 26, 26);
    self.alphaLabel.layer.cornerRadius = 13.f;
    self.alphaLabel.clipsToBounds = YES;
    
    

    CGFloat alphaLabelX = CGRectGetMaxX(self.alphaLabel.frame) + 12;
    CGFloat alphaLabelW = kUIScreenWidth - alphaLabelX - 20;
    CGFloat alphaLabelH = 10;
    CGFloat alphaLabelY = CGRectGetMidY(self.alphaLabel.frame) - alphaLabelH / 2;
    self.alphaSlider.frame = CGRectMake(alphaLabelX, alphaLabelY, alphaLabelW, alphaLabelH);
}

#pragma mark - delegate
#pragma mark -FCColorSilderDelegate

- (void)colorSliderSelectColor:(UIColor *)color
{
    self.colorView.backgroundColor = color;
    if (self.delegate  && [self.delegate respondsToSelector:@selector(fontStyleViewChangeColor:)]) {
        [self.delegate fontStyleViewChangeColor:color];
    }
}

#pragma mark FCAlphaSliderDelegate

- (void)alphaSliderValue:(CGFloat)value
{
    self.alphaLabel.text = [NSString stringWithFormat:@"%ld%%",(NSInteger)value];
    if (self.delegate  && [self.delegate respondsToSelector:@selector(fontStyleViewChangeAlpha:)]) {
        [self.delegate fontStyleViewChangeAlpha:value / 100.f];
    }
}

#pragma mark - setter

- (UIView *)colorView
{
    if (!_colorView) {
        _colorView = [[UIView alloc] init];
        _colorView.backgroundColor = [UIColor whiteColor];
        
    }
    return _colorView;
}

- (FCColorSlider *)colorSlider
{
    if (!_colorSlider) {
        _colorSlider = [[FCColorSlider alloc] init];
        _colorSlider.colorDelegate = self;
    }
    return _colorSlider;
}

- (UILabel *)alphaLabel
{
    if (!_alphaLabel) {
        _alphaLabel = [[UILabel alloc] init];
        _alphaLabel.backgroundColor = [UIColor colorWithWhite:100 / 255.f alpha:1.0];
        _alphaLabel.textColor = [UIColor whiteColor];
        _alphaLabel.text = @"100%";
        _alphaLabel.textAlignment = NSTextAlignmentCenter;
        _alphaLabel.font = [UIFont systemFontOfSize:8.f];
    }
    
    return _alphaLabel;
}

- (FCAlphaSlider *)alphaSlider
{
    if (!_alphaSlider) {
        _alphaSlider = [[FCAlphaSlider alloc] init];
        _alphaSlider.alphaDelegate = self;
    }
    return _alphaSlider;
}

@end
