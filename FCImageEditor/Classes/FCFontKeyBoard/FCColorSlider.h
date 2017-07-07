//
//  FCColorSilder.h
//  FCFontKeyboard
//
//  Created by zz on 2017/7/5.
//  Copyright © 2017年 FlyCatkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FCColorSliderDelegate <NSObject>

- (void)colorSliderSelectColor:(UIColor *)color;

@end

@interface FCColorSlider : UIView
@property (strong, nonatomic, readonly) UIColor *selectedColor;
@property (weak, nonatomic) id<FCColorSliderDelegate> colorDelegate;

@end
