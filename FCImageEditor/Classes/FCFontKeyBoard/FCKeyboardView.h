//
//  FCKeyboardView.h
//  FCFontKeyboard
//
//  Created by zz on 2017/7/5.
//  Copyright © 2017年 FlyCatkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCFontBar.h"
#import "FCFontView.h"
#import "FCFontStyleView.h"

@protocol FCKeyboardViewDelegate <NSObject>

@optional
- (void)fontKeyboardChangeTextColor:(UIColor *)color;
- (void)fontKeyboardChangeFont:(UIFont *)font;
- (void)fontKeyboardChangeText:(NSString *)text;
- (void)fontKeyboardSendMessage:(NSString *)text;

@end

@interface FCKeyboardView : UIView

@property (weak, nonatomic) id<FCKeyboardViewDelegate> delegate;
+ (instancetype)showKeyBoardInView:(UIView *)view;
- (void)setInitailColor:(UIColor *)color font:(UIFont *)font text:(NSString *)text;

@end
