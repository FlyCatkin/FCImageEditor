//
//  FCAlphaSilder.h
//  FCFontKeyboard
//
//  Created by zz on 2017/7/5.
//  Copyright © 2017年 FlyCatkin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FCAlphaSliderDelegate <NSObject>

- (void)alphaSliderValue:(CGFloat)value;

@end
@interface FCAlphaSlider : UIView
@property (weak, nonatomic) id<FCAlphaSliderDelegate> alphaDelegate;

- (void)setInitailValue:(CGFloat)value;

@end
