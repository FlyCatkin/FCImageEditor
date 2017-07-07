//
//  FCFontBar.m
//  FCFontKeyboard
//
//  Created by zz on 2017/7/4.
//  Copyright © 2017年 FlyCatkin. All rights reserved.
//

#import "FCFontBar.h"


#define kUIScreenWidth [UIScreen mainScreen].bounds.size.width

@interface FCFontBar ()<UITextViewDelegate>
@property(nonatomic, strong) UIView *topLine;
@property(nonatomic, strong) UIView *bottomLine;
@property(nonatomic, assign) CGFloat textViewHeight;
@end

@implementation FCFontBar

#pragma mark - public

- (void)setInitailColor:(UIColor *)color font:(UIFont *)font text:(NSString *)text
{
    self.textView.text = text;
    if (font != nil) {
//        self.textView.font = font;
    }
    
    if (color != nil) {
//        self.textView.textColor = color;
    }
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
    self.backgroundColor = [UIColor colorWithWhite:239 / 255.0 alpha:1.0];
    [self addSubview:self.keyBoardButton];
    [self addSubview:self.styleButton];
    [self addSubview:self.fontButton];
    [self addSubview:self.textView];
    [self addSubview:self.sendButton];
    [self addSubview:self.topLine];
    [self addSubview:self.bottomLine];
}

#pragma mark - UITextViewDelegate


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(fontBar:sendMessage:)]) {
            [self.delegate fontBar:self sendMessage:self.textView.text];
        }
        return NO;
    }
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView {
    
    CGFloat width   = CGRectGetWidth(textView.frame);
    CGSize newSize  = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
    CGRect maxFrame = CGRectMake(CGRectGetMinX(textView.frame), CGRectGetMinY(textView.frame), width, kTextViewMaxHeight);
    CGRect newFrame = CGRectMake(CGRectGetMinX(textView.frame), CGRectGetMinY(textView.frame), width, newSize.height);
    _textViewHeight = newSize.height;
    if (_textViewHeight > kTextViewMaxHeight) {
        _textViewHeight = kTextViewMaxHeight;
    } else if (_textViewHeight < kTextViewMinHeight) {
        _textViewHeight = kTextViewMinHeight;
    }
    [UIView animateWithDuration:0.1 animations:^{
        if (newSize.height <= kTextViewMaxHeight) {
            
            textView.frame  = newFrame;
            textView.scrollEnabled = NO;
        }else {
            
            textView.frame = maxFrame;
            textView.scrollEnabled = YES;
        }
    }];
    [self setNeedsLayout];
    if (self.delegate && [self.delegate respondsToSelector:@selector(fontBarUpdateFrameWithHeigth:)]) {
        [self.delegate fontBarUpdateFrameWithHeigth:90 + _textViewHeight - 30];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(fontBarChangeText:)]) {
        [self.delegate fontBarChangeText:textView.text];
    }
}

#pragma mark - buttonClick

- (void)sendClick:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(fontBar:sendMessage:)]) {
        [self.delegate fontBar:self sendMessage:self.textView.text];
    }
}

#pragma mark - update views
- (void)layoutViews
{
    self.textViewHeight = 36.5;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textView.frame = CGRectMake(12, 4, kUIScreenWidth - 12 - 60, self.textViewHeight);
    self.sendButton.frame = CGRectMake(kUIScreenWidth - 50, CGRectGetMaxY(self.textView.frame) - 30, 40, 30);
    
    CGFloat buttonMargin = 50;
    CGFloat buttonWidth = (kUIScreenWidth - 100) / 3.0;
    self.keyBoardButton.frame = CGRectMake(buttonMargin , CGRectGetMaxY(self.textView.frame) + 10, buttonWidth, 40);
    self.styleButton.frame = CGRectMake(buttonMargin + buttonWidth, CGRectGetMaxY(self.textView.frame) + 10, buttonWidth, 40);
    self.fontButton.frame = CGRectMake(buttonWidth * 2 + buttonMargin, CGRectGetMaxY(self.textView.frame) + 10, buttonWidth, 40);
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), 90 + _textViewHeight - 30);
    self.bottomLine.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5);
    self.topLine.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.5);
}

#pragma mark - getter
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.layer.cornerRadius = 5;
        _textView.layer.borderWidth = 0.5f;
        _textView.layer.borderColor = [UIColor colorWithWhite:215/255.0 alpha:1.f].CGColor;
        _textView.scrollEnabled = YES;
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:17.0f];
        [_textView scrollRangeToVisible:NSMakeRange(_textView.text.length, 1)];
    }
    return _textView;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = [UIColor colorWithWhite:215/255.0 alpha:1.f];
    }
    return _bottomLine;
}

- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc]init];
        _topLine.backgroundColor = [UIColor colorWithWhite:215/255.0 alpha:1.f];
    }
    return _topLine;
}

- (UIButton *)keyBoardButton {
    
    if (!_keyBoardButton) {
        _keyBoardButton = [FCButton buttonWithType:UIButtonTypeCustom];
        [_keyBoardButton setImage:[UIImage imageNamed:@"fckeyboard_keyboard_unselect"] forState:UIControlStateNormal];
        [_keyBoardButton setImage:[UIImage imageNamed:@"fckeyboard_keyboard"] forState:UIControlStateSelected];
        [_keyBoardButton setTitle:@"键盘" forState:UIControlStateNormal];
        [_keyBoardButton setTitleColor:[UIColor colorWithRed:18 / 255.0 green:150.0 / 255.0 blue:219 / 255.0 alpha:1.0] forState:UIControlStateSelected];
        [_keyBoardButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [_keyBoardButton addTarget:self action:@selector(keyBoardClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _keyBoardButton;
}

- (UIButton *)styleButton {
    
    if (!_styleButton) {
        _styleButton = [FCButton buttonWithType:UIButtonTypeCustom];
        [_styleButton setImage:[UIImage imageNamed:@"fckeyboard_style_unselect"] forState:UIControlStateNormal];
        [_styleButton setImage:[UIImage imageNamed:@"fckeyboard_style"] forState:UIControlStateSelected];
        [_styleButton setTitle:@"样式" forState:UIControlStateNormal];
        [_styleButton setTitleColor:[UIColor colorWithRed:18 / 255.0 green:150.0 / 255.0 blue:219 / 255.0 alpha:1.0] forState:UIControlStateSelected];
        [_styleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [_styleButton addTarget:self action:@selector(styleClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _styleButton;
}

- (UIButton *)fontButton {
    
    if (!_fontButton) {
        _fontButton = [FCButton buttonWithType:UIButtonTypeCustom];
        [_fontButton setImage:[UIImage imageNamed:@"fckeyboard_font_unselect"] forState:UIControlStateNormal];
        [_fontButton setImage:[UIImage imageNamed:@"fckeyboard_font"] forState:UIControlStateSelected];
        [_fontButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_fontButton setTitleColor:[UIColor colorWithRed:18 / 255.0 green:150.0 / 255.0 blue:219 / 255.0 alpha:1.0] forState:UIControlStateSelected];
        [_fontButton setTitle:@"字体" forState:UIControlStateNormal];
//        [_fontButton addTarget:self action:@selector(fontClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fontButton;
}

- (UIButton *)sendButton {
    
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"完成" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

@end
