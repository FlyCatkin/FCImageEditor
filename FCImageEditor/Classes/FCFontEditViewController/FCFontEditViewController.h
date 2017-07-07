//
//  FCFontSaveViewController.h
//  FCFontKeyboard
//
//  Created by zz on 2017/7/6.
//  Copyright © 2017年 FlyCatkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FCFontEditViewController;
@protocol FCFontEditViewControllerDelegate <NSObject>

- (void)fontEditViewControllerDidFinish:(FCFontEditViewController *)viewController image:(UIImage *)image;
- (void)fontEditViewControllerDidCance:(FCFontEditViewController *)viewController;


@end

@interface FCFontEditViewController : UIViewController
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) id<FCFontEditViewControllerDelegate> delegate;

@end
