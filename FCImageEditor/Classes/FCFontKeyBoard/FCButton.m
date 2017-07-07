//
//  FCButton.m
//  FCFontKeyboard
//
//  Created by zz on 2017/7/6.
//  Copyright © 2017年 FlyCatkin. All rights reserved.
//

#import "FCButton.h"

@implementation FCButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    switch (self.buttonType) {
        case FCButtonStyleVertcial:
        {
            self.titleLabel.font = [UIFont systemFontOfSize:10.f];
            self.titleLabel.backgroundColor = self.backgroundColor;
            self.imageView.backgroundColor = self.backgroundColor;
            
            CGSize titleSize = self.titleLabel.bounds.size;
            CGSize imageSize = self.imageView.bounds.size;
            CGFloat interval = 3;
            
            [self setImageEdgeInsets:UIEdgeInsetsMake(0,0, titleSize.height + interval, -titleSize.width)];
            [self setTitleEdgeInsets:UIEdgeInsetsMake(imageSize.height + interval, -imageSize.width, 0, 0)];
        
        }
            break;
        case FCButtonStyleLeft:
        {
            self.titleLabel.backgroundColor = self.backgroundColor;
            self.imageView.backgroundColor = self.backgroundColor;
            CGSize titleSize = self.titleLabel.bounds.size;
            CGSize imageSize = self.imageView.bounds.size;
            CGFloat interval = 1.0;
            
            self.imageEdgeInsets = UIEdgeInsetsMake(0,titleSize.width + interval, 0, -(titleSize.width + interval));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageSize.width + interval), 0, imageSize.width + interval);
            
        }
            break;
        default:
            break;
    }
}

@end
