//
//  FCTextToolView.m
//  FCFontKeyboard
//
//  Created by zz on 2017/7/6.
//  Copyright © 2017年 FlyCatkin. All rights reserved.
//

#import "FCTextToolView.h"

@interface FCTextToolView ()<UITextViewDelegate>
@property (strong, nonatomic) UILabel *placeHolderLabel;

@end
@implementation FCTextToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self addGestures];
    }
    return self;
}

+ (void)prepareToSave:(FCTextToolView *)textToolView
{
    [CATransaction begin];
    textToolView.layer.borderWidth = 0.f;
    textToolView.layer.borderColor = [UIColor clearColor].CGColor;
    textToolView.layer.cornerRadius = 0;
    textToolView.placeHolderLabel.hidden = YES;
    [CATransaction commit];
    
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    if (_placeholder.length < 1) {
        self.placeHolderLabel.hidden = YES;
        self.placeHolderLabel.text = placeholder;
    }else{
        self.placeHolderLabel.hidden = NO;
        self.placeHolderLabel.text = placeholder;
    }
}
#pragma mark - GestureRecognize

- (void)rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    UIView *view = rotationGestureRecognizer.view;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
}

- (void)pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}

- (void)panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}

- (void)tap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textToolViewClick:font:color:)]) {
        [self.delegate textToolViewClick:self.textLabel.text
                                    font:self.textLabel.font
                                   color:self.textLabel.textColor];
    }
}

#pragma mark - private

- (void)setupSubviews
{
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.userInteractionEnabled = YES;
    textLabel.minimumScaleFactor = 0.1;
    textLabel.adjustsFontSizeToFitWidth = YES;
    textLabel.frame = self.bounds;
    textLabel.numberOfLines = 0;
    textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:24.f];
    textLabel.textColor = [UIColor whiteColor];
    self.textLabel = textLabel;
    [self addSubview:textLabel];
    
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.frame = self.bounds;
    placeHolderLabel.font = [UIFont systemFontOfSize:24.f];
    placeHolderLabel.textColor = [UIColor whiteColor];
    placeHolderLabel.textAlignment = NSTextAlignmentCenter;
    placeHolderLabel.text = @"点击输入文字";
    self.placeHolderLabel = placeHolderLabel;
    [self addSubview:placeHolderLabel];
    
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1.f;
    self.layer.cornerRadius = 2.f;
}

- (void)addGestures
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                             action:@selector(tap:)];
    tapRecognizer.numberOfTouchesRequired = 1; //手指数
    tapRecognizer.numberOfTapsRequired = 1; //tap次数
    [self addGestureRecognizer:tapRecognizer];
    
    // 旋转手势
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    [self addGestureRecognizer:rotationGestureRecognizer];
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self addGestureRecognizer:pinchGestureRecognizer];
    
    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self addGestureRecognizer:panGestureRecognizer];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = self.bounds;
    self.placeHolderLabel.frame = self.bounds;
    self.textLabel.userInteractionEnabled = YES;
}


@end
