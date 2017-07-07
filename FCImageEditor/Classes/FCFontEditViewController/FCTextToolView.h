//
//  FCTextToolView.h
//  FCFontKeyboard
//
//  Created by zz on 2017/7/6.
//  Copyright © 2017年 FlyCatkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FCTextToolViewDelegate <NSObject>

- (void)textToolViewClick:(NSString *)text font:(UIFont *)font color:(UIColor *)color;

@end
@interface FCTextToolView : UIView
@property (strong, nonatomic) UILabel *textLabel;
@property (copy, nonatomic) NSString *placeholder;
@property (weak, nonatomic) id <FCTextToolViewDelegate> delegate;

+ (void)prepareToSave:(FCTextToolView *)textToolView;

@end
