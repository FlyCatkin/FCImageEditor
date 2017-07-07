//
//  FCFontEditorViewController.h
//  FCFontKeyboard
//
//  Created by zz on 2017/7/6.
//  Copyright © 2017年 FlyCatkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FCEditTextViewControllerDelegate <NSObject>

- (void)editTextViewControllerEndEditWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color;

@end

@interface FCEditTextViewController : UIViewController
@property (weak, nonatomic) id<FCEditTextViewControllerDelegate> delegate;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) UIColor *color;
@property (copy, nonatomic) NSString *text;

- (void)setInitailColor:(UIColor *)color font:(UIFont *)font text:(NSString *)text;
@end
