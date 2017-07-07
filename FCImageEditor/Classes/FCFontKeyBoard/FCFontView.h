//
//  FCFontView.h
//  FCFontKeyboard
//
//  Created by zz on 2017/7/4.
//  Copyright © 2017年 FlyCatkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FCFontViewDelegate <NSObject>

- (void)fontViewChangeFont:(UIFont *)font;

@end

@interface FCFontView : UIView
@property (weak, nonatomic) id<FCFontViewDelegate> delegate;

- (void)setInitailFont:(UIFont *)font;

@end

@interface FCFontViewCell :UITableViewCell
@property (strong, nonatomic) UIImageView *selectImageView;
@property (strong, nonatomic) UILabel *fontLabel;
@property (strong, nonatomic) UIButton *downloadFontButton;


@end
