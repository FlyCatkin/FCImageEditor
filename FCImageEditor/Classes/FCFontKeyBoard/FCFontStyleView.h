//
//  FCFontStyleView.h
//  FCFontKeyboard
//
//  Created by zz on 2017/7/5.
//  Copyright © 2017年 FlyCatkin. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FCFontStyleViewDelegate <NSObject>

- (void)fontStyleViewChangeColor:(UIColor *)color;
- (void)fontStyleViewChangeAlpha:(CGFloat)alpha;

@end

@interface FCFontStyleView : UIView
@property (weak, nonatomic) id<FCFontStyleViewDelegate> delegate;

- (void)setInitailColor:(UIColor *)color;

@end
