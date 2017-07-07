//
//  FCKeyboardView.m
//  FCFontKeyboard
//
//  Created by zz on 2017/7/5.
//  Copyright © 2017年 FlyCatkin. All rights reserved.
//

#import "FCKeyboardView.h"

#define kUIScreenWidth [UIScreen mainScreen].bounds.size.width
#define kUIScreenHeight [UIScreen mainScreen].bounds.size.height
#define kKeyBoardTipTime 0.1
@interface FCKeyboardView ()<FCFontBarDelegate,FCFontStyleViewDelegate,FCFontViewDelegate>
@property (strong, nonatomic) FCFontBar *fontBar;
@property (strong, nonatomic) FCFontView *fontView;
@property (strong, nonatomic) FCFontStyleView *styleView;
@property (assign, nonatomic) CGFloat keyBoardHeight;
@property (assign, nonatomic) CGFloat fontAlpha;
@property (strong, nonatomic) UIColor *fontColor;
@end

@implementation FCKeyboardView

#pragma mark - public
+ (instancetype)showKeyBoardInView:(UIView *)view {
    
    if (!view) {return nil;}
    FCKeyboardView *keyboard = [[self alloc]init];
    [view addSubview:keyboard];
    [view addSubview:keyboard.fontBar];
    return keyboard;
}

-(void)setInitailColor:(UIColor *)color font:(UIFont *)font text:(NSString *)text
{
    [self.fontBar setInitailColor:color font:font text:text];
    [self.styleView setInitailColor:color];
    [self.fontView setInitailFont:font];
}

#pragma mark - life
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self methods];
    }
    return self;
}

#pragma mark - methods

- (void)methods {
    
    [self initSomeThing];
    [self configureSubViews];
    [self initSubViewFrames];
    [self addNotifations];
    [self keyBoardButtonClick:self.fontBar.keyBoardButton];
}

- (void)initSomeThing {
    self.fontAlpha = 1.0;
    self.backgroundColor = [UIColor greenColor];
}

- (void)configureSubViews {
    
    [self addSubview:self.fontView];
    [self addSubview:self.styleView];
    [self.fontBar.keyBoardButton addTarget:self action:@selector(keyBoardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.fontBar.styleButton addTarget:self action:@selector(styleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.fontBar.fontButton addTarget:self action:@selector(fontButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initSubViewFrames {
    
    self.frame = CGRectMake(0, kUIScreenHeight, kUIScreenWidth, self.keyBoardHeight);
    self.fontBar.frame = CGRectMake(0, kUIScreenHeight - self.keyBoardHeight - 90.f, kUIScreenWidth, 90.f);
}

- (void)addNotifations {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - click

- (void)keyBoardButtonClick:(UIButton *)button
{
    if (button.selected == YES) {
        return ;
    }else {
        self.fontBar.styleButton.selected = NO;
        self.fontBar.fontButton.selected = NO;
        button.selected = YES;
        [self changeToKeyBoardView];
        [self.fontBar.textView becomeFirstResponder];
    }
}

- (void)styleButtonClick:(UIButton *)button
{
    if (button.selected == YES) {
        return ;
    }else {
        self.fontBar.keyBoardButton.selected = NO;
        self.fontBar.fontButton.selected = NO;
        button.selected = YES;
        [self.fontBar.textView becomeFirstResponder];
        [self changeToStyleView];
    }
}

- (void)fontButtonClick:(UIButton *)button
{
    if (button.selected == YES) {
        return ;
    }else {
        self.fontBar.styleButton.selected = NO;
        self.fontBar.keyBoardButton.selected = NO;
        button.selected = YES;
        [self.fontBar.textView becomeFirstResponder];
        [self changeToFontView];
    }
}

#pragma mark - Delegate

#pragma mark FCFontBarDelegate

- (void)fontBarUpdateFrameWithHeigth:(CGFloat)height
{
    self.fontBar.frame = CGRectMake(0, kUIScreenHeight - self.keyBoardHeight - height, kUIScreenWidth, height);
}

- (void)fontBar:(FCFontBar *)fontBar sendMessage:(NSString *)message
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(fontKeyboardSendMessage:)]) {
        [self.delegate  fontKeyboardSendMessage:message];
    }
}

- (void)fontBarChangeText:(NSString *)text
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(fontKeyboardChangeText:)]) {
        [self.delegate  fontKeyboardChangeText:text];
    }
}

#pragma mark  FCFontStyleViewDelegate

- (void)fontStyleViewChangeAlpha:(CGFloat)alpha
{
    self.fontAlpha = alpha;
    UIColor *temp = [self.fontColor colorWithAlphaComponent:self.fontAlpha];
    if (self.delegate && [self.delegate respondsToSelector:@selector(fontKeyboardChangeTextColor:)]) {
        [self.delegate fontKeyboardChangeTextColor:temp];
    }
}

- (void)fontStyleViewChangeColor:(UIColor *)color
{
    self.fontColor = color;
    UIColor *temp = [self.fontColor colorWithAlphaComponent:self.fontAlpha];
    if (self.delegate && [self.delegate respondsToSelector:@selector(fontKeyboardChangeTextColor:)]) {
        [self.delegate fontKeyboardChangeTextColor:temp];
    }
}

#pragma mark FCFontViewDelegate

- (void)fontViewChangeFont:(UIFont *)font
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(fontKeyboardChangeFont:)]) {
        [self.delegate fontKeyboardChangeFont:font];
    }
}

#pragma mark - keyBoard Notification

- (void)keyBoardWillShow:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    NSValue *beginValue    = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    NSValue *endValue      = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect beginFrame      = beginValue.CGRectValue;
    CGRect endFrame        = endValue.CGRectValue;
    self.keyBoardHeight = endFrame.size.height;
    BOOL isNeedHandle = beginFrame.size.height > 0 && beginFrame.origin.y - endFrame.origin.y > 0;
    //处理键盘走多次
    if (isNeedHandle) {
        //处理键盘弹出
        [self handleKeyBoardShow:endFrame];
    }
}

- (void)keyBoardWillHide:(NSNotification *)noti {
    
    if (self.fontBar.textView.isFirstResponder) {
        [self.fontBar.textView resignFirstResponder];
    }
    [UIView animateWithDuration:kKeyBoardTipTime animations:^{
        self.fontBar.frame = CGRectMake(0, kUIScreenHeight - CGRectGetHeight(self.fontBar.frame), CGRectGetWidth(self.fontBar.frame), CGRectGetHeight(self.fontBar.frame));
        self.frame = CGRectMake(0, kUIScreenHeight, kUIScreenWidth, self.keyBoardHeight);
    }];
}


- (void)handleKeyBoardShow:(CGRect)frame {
    [UIView animateWithDuration:kKeyBoardTipTime animations:^{
        self.fontBar.frame = CGRectMake(0, kUIScreenHeight - CGRectGetHeight(self.fontBar.frame) - self.keyBoardHeight, CGRectGetWidth(self.fontBar.frame), CGRectGetHeight(self.fontBar.frame));
        self.frame = CGRectMake(0, kUIScreenHeight - self.keyBoardHeight, kUIScreenWidth, self.keyBoardHeight);
    }];
}

- (void)changeToKeyBoardView{
    [self.fontView removeFromSuperview];
    [self.styleView removeFromSuperview];
}

- (void)changeToStyleView{
    [self.fontView removeFromSuperview];
    [self.styleView removeFromSuperview];
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    UIView * keyview=[[window subviews] lastObject];
    self.styleView.frame = CGRectMake(0, kUIScreenHeight - self.keyBoardHeight, kUIScreenWidth, self.keyBoardHeight);
    [keyview addSubview:self.styleView];
}

- (void)changeToFontView{
    [self.fontView removeFromSuperview];
    [self.styleView removeFromSuperview];
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    UIView * keyview=[[window subviews] lastObject];
    self.fontView.frame = CGRectMake(0, kUIScreenHeight - self.keyBoardHeight, kUIScreenWidth, self.keyBoardHeight);
    [keyview addSubview:self.fontView];
}


#pragma mark - setter

- (FCFontBar *)fontBar{
    if (!_fontBar) {
        _fontBar = [[FCFontBar alloc] init];
        _fontBar.delegate = self;
    }
    return _fontBar;
}


- (FCFontView *)fontView{
    if (!_fontView) {
        _fontView = [[FCFontView alloc] init];
        _fontView.delegate = self;
    }
    
    return _fontView;
}

- (FCFontStyleView *)styleView {
    if (!_styleView) {
        _styleView = [[FCFontStyleView alloc] init];
        _styleView.delegate = self;
    }
    return _styleView;
}

@end
