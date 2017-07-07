//
//  FCButton.h
//  FCFontKeyboard
//
//  Created by zz on 2017/7/6.
//  Copyright © 2017年 FlyCatkin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FCButtonStyle) {
    FCButtonStyleVertcial,
    FCButtonStyleLeft,
    FCButtonStyleNormal,
};
@interface FCButton : UIButton
@property (assign, nonatomic) FCButtonStyle buttonStyle;

@end
