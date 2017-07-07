//
//  FCFontEditorViewController.m
//  FCFontKeyboard
//
//  Created by zz on 2017/7/6.
//  Copyright © 2017年 FlyCatkin. All rights reserved.
//

#import "FCEditTextViewController.h"
#import "FCFontEditViewController.h"
#import "FCKeyboardView.h"

@interface FCEditTextViewController ()<FCKeyboardViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@property (strong, nonatomic) UIVisualEffectView *effectView;
@property (strong, nonatomic) FCFontEditViewController *fontEditViewController;
@end

@implementation FCEditTextViewController

#pragma mark - life 

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    FCKeyboardView *keyBoardView = [FCKeyboardView showKeyBoardInView:self.view];
    if (self.text.length > 1) {
        [keyBoardView setInitailColor:self.color font:self.font text:self.text];
        self.textView.text = self.text;
        if (self.color != nil) {
            self.textView.textColor = self.color;
        }
        
        if (self.font != nil) {
            self.textView.font = self.font;
        }
    }
    keyBoardView.delegate = self;
}

- (void)setupSubViews
{
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    self.textView.layer.borderWidth = 1.f;
    self.textView.textColor = [UIColor whiteColor];
    self.textView.editable = NO;
    
    self.backgroundImageView.image = self.image;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.backgroundImageView addSubview:effectView];
    self.effectView = effectView;
}

#pragma mark - public

- (void)setInitailColor:(UIColor *)color font:(UIFont *)font text:(NSString *)text
{
    self.color = color;
    self.font = font;
    self.text = text;
    
    self.textView.text = self.text;
    if (color != nil) {
        self.textView.textColor = self.color;
    }
    
    if (font != nil) {
        self.textView.font = self.font;
    }
}

#pragma mark - FCKeyboardViewDelegate

- (void)fontKeyboardChangeTextColor:(UIColor *)color
{
    self.textView.editable = YES;
    [self.textView setTextColor:color];
    self.textView.editable = NO;
}

- (void)fontKeyboardChangeFont:(UIFont *)font
{
    self.textView.editable = YES;
    self.textView.font = font;
    self.textView.editable = NO;
    [self textViewDidChange];
}

- (void)fontKeyboardChangeText:(NSString *)text
{
    self.textView.text = text;
    [self textViewDidChange];
}

- (void)fontKeyboardSendMessage:(NSString *)text
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(editTextViewControllerEndEditWithText:font:color:)]) {
        [self.delegate editTextViewControllerEndEditWithText:self.textView.text
                                                          font:self.textView.font
                                                         color:self.textView.textColor];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)textViewDidChange
{
    CGFloat height = kTextViewMinHeight;
    CGFloat width   = CGRectGetWidth(self.textView.frame);
    CGSize newSize  = [self.textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
    if (newSize.height > kTextViewMaxHeight) {
        height = kTextViewMaxHeight;
    }else if(newSize.height < kTextViewMinHeight){
        height = kTextViewMinHeight;
    }else{
        height = newSize.height;
    }
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length - 1, 1)];
    self.textViewHeightConstraint.constant = height;

}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

