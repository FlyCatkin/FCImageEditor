//
//  FCImageEditorViewController.h
//  FCFontKeyboard
//
//  Created by zz on 2017/7/6.
//  Copyright © 2017年 FlyCatkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FCImageEditorViewController;
@protocol FCImageEditorViewControllerDelegate <NSObject>

- (void)imageEditorViewControllerDidFinish:(FCImageEditorViewController *)viewController image:(UIImage *)image;
- (void)imageEditorViewControllerDidCancel:(FCImageEditorViewController *)viewController;

@end

@interface FCImageEditorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) id<FCImageEditorViewControllerDelegate> delegate;

- (instancetype)initWith:(UIImage *)image;

@end
