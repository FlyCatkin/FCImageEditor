//
//  FCFontSaveViewController.m
//  FCFontKeyboard
//
//  Created by zz on 2017/7/6.
//  Copyright © 2017年 FlyCatkin. All rights reserved.
//

#import "FCFontEditViewController.h"
#import "FCEditTextViewController.h"
#import "FCTextToolView.h"
#import "UIImage+FCRotate.h"

@interface FCFontEditViewController ()<FCEditTextViewControllerDelegate,FCTextToolViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) FCTextToolView *textToolView;
@property (strong, nonatomic) FCEditTextViewController *editTextViewController;

@end

@implementation FCFontEditViewController

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
}


#pragma mark - FCEditTextViewControllerDelegate

- (void)editTextViewControllerEndEditWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color
{
    self.textToolView.textLabel.font = font;
    self.textToolView.textLabel.textColor = color;
    self.textToolView.textLabel.text = text;
    if (text.length < 1) {
        self.textToolView.placeholder = @"点击输入文字";
    }else{
        self.textToolView.placeholder = @"";
    }
}

#pragma mark - FCTextToolViewDelegate

- (void)textToolViewClick:(NSString *)text font:(UIFont *)font color:(UIColor *)color
{
    FCEditTextViewController *editTextViewController = [[FCEditTextViewController alloc] init];
    if (text.length > 1) {
        [editTextViewController setInitailColor:color font:font text:text];
    }
    editTextViewController.image = self.image;
    editTextViewController.delegate = self;
    [self presentViewController:editTextViewController animated:NO completion:nil];
}

#pragma mark - save 

- (void)buildClipImageShowHud:(BOOL)showHud clipedCallback:(void(^)(UIImage *clipedImage))clipedCallback {
    if (showHud) {
        //ShowBusyTextIndicatorForView(self.view, @"生成图片中...", nil);
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.imageView.image.size.width,
                                                          self.imageView.image.size.height),
                                               NO,
                                               self.imageView.image.scale);
        [self.imageView.image drawAtPoint:CGPointZero];
        [self.imageView.image drawInRect:CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height)];
        
        for (UIView *subV in self.backgroundView.subviews) {
            if ([subV isKindOfClass:[FCTextToolView class]]) {
                FCTextToolView *textToolView = (FCTextToolView *)subV;
                //进入正常状态
                [FCTextToolView prepareToSave:textToolView];

                UIImage *textImg = [self.class screenshot:textToolView
                                              orientation:UIDeviceOrientationPortrait
                                     usePresentationLayer:YES];
                CGFloat rotation = [[textToolView.layer valueForKeyPath:@"transform.rotation.z"] doubleValue];
                textImg = [textImg imageRotatedByRadians:rotation];
                
                CGFloat selfRw = self.imageView.bounds.size.width / self.imageView.image.size.width;
                CGFloat selfRh = self.imageView.bounds.size.height / self.imageView.image.size.height;
                
                CGFloat textImgW = textImg.size.width / selfRw;
                CGFloat textImgH = textImg.size.height / selfRh;
                CGFloat textImgX = (textToolView.frame.origin.x - self.imageView.frame.origin.x) / selfRw;
                CGFloat textImgY = (textToolView.frame.origin.y - self.imageView.frame.origin.y) / selfRh;
                [textImg drawInRect:CGRectMake(textImgX, textImgY, textImgW, textImgH)];
            }
        }
        
        UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //HideBusyIndicatorForView(self.view);
            UIImage *image = [UIImage imageWithCGImage:tmp.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
            clipedCallback(image);
            
        });
    });
}

+ (UIImage *)screenshot:(UIView *)view orientation:(UIDeviceOrientation)orientation usePresentationLayer:(BOOL)usePresentationLayer
{
    CGSize size = view.bounds.size;
    CGSize targetSize = CGSizeMake(size.width * [[view.layer valueForKeyPath:@"transform.scale.x"] doubleValue],
                                   size.height *  [[view.layer valueForKeyPath:@"transform.scale.y"] doubleValue]);
    
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    [view drawViewHierarchyInRect:CGRectMake(0, 0, targetSize.width, targetSize.height) afterScreenUpdates:NO];
    CGContextRestoreGState(ctx);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - private

- (void)setupSubviews
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = self.image;
    [self.backgroundView addSubview:imageView];
    self.imageView = imageView;
    
    FCTextToolView *textToolView = [[FCTextToolView alloc] init];
    textToolView.delegate = self;
    [self.backgroundView addSubview:textToolView];
    self.textToolView = textToolView;
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.image) {
        CGFloat magin = 40.f;
        CGFloat maxWidth = CGRectGetWidth(self.backgroundView.bounds) - 2 * magin;
        CGFloat maxHeight = CGRectGetHeight(self.backgroundView.bounds) - 2 * magin;
        CGFloat imageViewW = self.image.size.width;
        CGFloat imageViewH = self.image.size.height;
        if (imageViewW > maxWidth || imageViewH > maxHeight) {
            if (imageViewW / imageViewH > maxWidth / maxHeight) {
                imageViewH = imageViewH  * maxWidth / imageViewW;
                imageViewW = maxWidth;
            }else{
                imageViewW = imageViewW  * maxHeight / imageViewH;
                imageViewH = maxHeight;
            }
        }
        CGFloat imageViewX = (maxWidth - imageViewW) * 0.5 + magin;
        CGFloat imageViewY = (maxHeight - imageViewH) * 0.5 + magin;
        
        self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    }
//    CGFloat textToolVieMagin = 50.f;
    CGFloat textToolViewW = 240.0;
    CGFloat textToolViewH = 57.f;
    CGFloat textToolViewX = (CGRectGetWidth(self.backgroundView.bounds) - textToolViewW) * 0.5;
    CGFloat textToolViewY = 160.f;
    
    self.textToolView.frame = CGRectMake(textToolViewX, textToolViewY, textToolViewW, textToolViewH);
}

#pragma mark - click

- (IBAction)cancelClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(fontEditViewControllerDidCance:)])
    {
        [self.delegate fontEditViewControllerDidCance:self];
    }
}

- (IBAction)editTextClick:(id)sender {
    FCEditTextViewController *editTextViewController = [[FCEditTextViewController alloc] init];
    editTextViewController.image = self.image;
    editTextViewController.delegate = self;
    [self presentViewController:editTextViewController animated:NO completion:nil];
}

- (IBAction)saveClick:(id)sender {
    [self buildClipImageShowHud:YES clipedCallback:^(UIImage *clipedImage) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(fontEditViewControllerDidFinish:image:)])
        {
            [self.delegate fontEditViewControllerDidFinish:self image:clipedImage];
        }
    }];
    
}



@end
