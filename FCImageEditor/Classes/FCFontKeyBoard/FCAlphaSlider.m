//
//  FCAlphaSilder.m
//  FCFontKeyboard
//
//  Created by zz on 2017/7/5.
//  Copyright © 2017年 FlyCatkin. All rights reserved.
//

#import "FCAlphaSlider.h"

@interface FCAlphaSlider ()
@property (strong, nonatomic) UISlider *slider;

@end

@implementation FCAlphaSlider

- (void)setInitailValue:(CGFloat)value
{
    self.slider.value = value;
}

#pragma mark -life
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

#pragma  mark - update views
- (void)setupViews
{
    [self addSubview:self.slider];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.slider.frame = CGRectMake(0, CGRectGetMidY(self.bounds) - 8, CGRectGetWidth(self.frame), 26);
}

- (void)sliderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    if (self.alphaDelegate && [self.alphaDelegate respondsToSelector:@selector(alphaSliderValue:)]) {
        [self.alphaDelegate alphaSliderValue:slider.value];
    }
}

#pragma mark - getter

- (UISlider *)slider
{
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        _slider.minimumValue = 0;// 设置最小值
        _slider.maximumValue = 100;// 设置最大值
        _slider.value = _slider.maximumValue;// 设置初始值
        _slider.continuous = YES;// 设置可连续变化
//        _slider.minimumTrackTintColor = [UIColor blueColor]; //滑轮左边颜色，如果设置了左边的图片就不会显示
//        _slider.maximumTrackTintColor = [UIColor grayColor]; //滑轮右边颜色，如果设置了右边的图片就不会显示
//        _slider.thumbTintColor = [UIColor blueColor];//设置了滑轮的颜色，如果设置了滑轮的样式图片就不会显示
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
    }
    return _slider;
}

@end
