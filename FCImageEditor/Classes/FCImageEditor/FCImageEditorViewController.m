//
//  FCImageEditorViewController.m
//  FCFontKeyboard
//
//  Created by zz on 2017/7/6.
//  Copyright © 2017年 FlyCatkin. All rights reserved.
//

#import "FCImageEditorViewController.h"
#import "TOCropViewController.h"
#import "FCFontEditViewController.h"
#import "FCButton.h"

@interface FCImageEditorViewController ()<TOCropViewControllerDelegate,FCFontEditViewControllerDelegate>
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) TOCropViewController *cropViewController;
@property (strong, nonatomic) FCFontEditViewController *editorViewController;
@property (assign, nonatomic) NSInteger selectIndex;
@property (weak, nonatomic) IBOutlet UIButton *revokeButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet FCButton *galleryButton;
@property (weak, nonatomic) IBOutlet FCButton *fontButton;
@property (weak, nonatomic) IBOutlet FCButton *cutButton;
@property (strong, nonatomic) UIImage *image;

@end

@implementation FCImageEditorViewController

- (instancetype)initWith:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.image) {
        self.imageView.image = self.image;
        [self.images addObject:self.image];
    }
    [self.revokeButton setImage:[UIImage imageNamed:@"fckeyboard_revoke_neable"] forState:UIControlStateNormal];
    [self.revokeButton setImage:[UIImage imageNamed:@"fckeyboard_revoke"] forState:UIControlStateDisabled];
    
    [self.forwardButton setImage:[UIImage imageNamed:@"fckeyboard_forward_enable"] forState:UIControlStateNormal];
    [self.forwardButton setImage:[UIImage imageNamed:@"fckeyboard_forward"] forState:UIControlStateDisabled];
    [self.galleryButton setTitle:@"图库" forState:UIControlStateNormal];
    [self.galleryButton setTitleColor:[UIColor colorWithWhite:138 / 255.0 alpha:1.f] forState:UIControlStateNormal];
    [self.fontButton setTitle:@"字体" forState:UIControlStateNormal];
    [self.fontButton setTitleColor:[UIColor colorWithWhite:138 / 255.0 alpha:1.f] forState:UIControlStateNormal];
    [self.cutButton setTitle:@"裁剪" forState:UIControlStateNormal];
    [self.cutButton setTitleColor:[UIColor colorWithWhite:138 / 255.0 alpha:1.f] forState:UIControlStateNormal];
}

#pragma mark - click

- (IBAction)back:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageEditorViewControllerDidCancel:)]) {
        [self.delegate imageEditorViewControllerDidCancel:self];
    }
}

- (IBAction)save:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageEditorViewControllerDidFinish:image:)]) {
        [self.delegate imageEditorViewControllerDidFinish:self image:self.images[self.selectIndex]];
    }
}

- (IBAction)revokeClick:(id)sender {
    if (self.selectIndex > 0) {
        self.selectIndex--;
        self.forwardButton.enabled = YES;
    }
    if (self.selectIndex <= 0) {
        self.revokeButton.enabled = NO;
    }else{
        self.revokeButton.enabled = YES;
    }

    self.imageView.image = self.images[self.selectIndex];
}

- (IBAction)forward:(id)sender {
    UIButton *button = sender;
    if (self.selectIndex < self.images.count - 1) {
        self.selectIndex++;
        self.revokeButton.enabled = YES;
    }
    if (self.selectIndex >= self.images.count - 1) {
        button.enabled = NO;
    }else{
        button.enabled = YES;
    }
    
    self.imageView.image = self.images[self.selectIndex];
}

- (IBAction)galleryClick:(id)sender {
    
}

- (IBAction)fontClick:(id)sender {
    FCFontEditViewController *fontEditorVC = [[FCFontEditViewController alloc] init];
    fontEditorVC.image = self.images[self.selectIndex];
    fontEditorVC.delegate = self;
    self.editorViewController = fontEditorVC;
    [self presentViewController:fontEditorVC animated:YES completion:nil];
}

- (IBAction)cutClick:(id)sender {
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:self.imageView.image];
    self.cropViewController = cropController;
    cropController.delegate = self;
    CGRect viewFrame = [self.view convertRect:self.imageView.frame toView:self.navigationController.view];
    [cropController presentAnimatedFromParentViewController:self
                                                  fromImage:self.imageView.image
                                                   fromView:nil
                                                  fromFrame:viewFrame
                                                      angle:0
                                               toImageFrame:CGRectZero
                                                      setup:^{
                                                      }
                                                 completion:^{
                                                     
                                                 }];

}

#pragma mark - TOCropViewControllerDelegate

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [self updateImageViewWithImage:image fromCropViewController:cropViewController];
}

- (void)updateImageViewWithImage:(UIImage *)image fromCropViewController:(TOCropViewController *)cropViewController
{
    [self addImage:image];
    [self.cropViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled
{
    [self.cropViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - FCFontEditViewControllerDelegate

- (void)fontEditViewControllerDidFinish:(FCFontEditViewController *)viewController image:(UIImage *)image
{
    [self addImage:image];
    [viewController dismissViewControllerAnimated:NO completion:nil];
}

- (void)fontEditViewControllerDidCance:(FCFontEditViewController *)viewController
{
    [viewController dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - update views
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.imageView.image) {
        CGFloat magin = 40.f;
        CGFloat maxWidth = CGRectGetWidth(self.backgroundView.frame) - 2 * magin;
        CGFloat maxHeight = CGRectGetHeight(self.backgroundView.frame) - 2 * magin;
        CGFloat imageViewW = self.imageView.image.size.width;
        CGFloat imageViewH = self.imageView.image.size.height;
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
}

#pragma mark - function

- (void)addImage:(UIImage *)image
{
    if (self.images.count > self.selectIndex + 1) {
        [self.images removeObjectsInRange:NSMakeRange(self.selectIndex + 1, self.images.count - self.selectIndex - 1)];
    }
    [self.images addObject:image];
    self.selectIndex = self.images.count - 1;
    self.imageView.image = image;
    self.revokeButton.enabled = YES;
    self.forwardButton.enabled = NO;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (NSMutableArray *)images
{
    if (!_images) {
        _images = [NSMutableArray new];
    }
    return _images;
}

@end
