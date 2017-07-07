//
//  FCFontBar.h
//  FCFontKeyboard
//
//  Created by zz on 2017/7/4.
//  Copyright © 2017年 FlyCatkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCButton.h"

#define kTextViewMaxHeight 57.f
#define kTextViewMinHeight 36.5
@class FCFontBar;
@protocol FCFontBarDelegate <NSObject>

- (void)fontBar:(FCFontBar *)fontBar sendMessage:(NSString *)message;
- (void)fontBarUpdateFrameWithHeigth:(CGFloat)height;
- (void)fontBarChangeText:(NSString *)text;
@end

@class FCFontBarDelegate;
typedef NS_ENUM(NSUInteger, FCFontBarType){
    FCFontBarTypeKeyboard /**< 显示键盘 */,
    FCFontBarTypeStyle /**样式*/,
    FCFontBarTypeFont /**< 字体*/,
};

@interface FCFontBar : UIView

@property (weak, nonatomic) id<FCFontBarDelegate> delegate;
@property (strong, nonatomic) FCButton *keyBoardButton;
@property (strong, nonatomic) FCButton *styleButton;
@property (strong, nonatomic) FCButton *fontButton;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *sendButton;

-(void)setInitailColor:(UIColor *)color font:(UIFont *)font text:(NSString *)text;

@end

