//
//  UIImage+emoji.m
//  MMCustomKeyboard
//
//  Created by Tom Atterton on 18/03/16.
//  Copyright © 2016 mm0030240. All rights reserved.
//

#import "UIImage+emoji.h"


#import "UIImage+emoji.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (emoji)

+ (UIImage *)imageWithEmoji:(NSString *)emoji
                   withSize:(CGFloat)size
{
    // Create a label
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"Apple Color Emoji" size:size];
    label.text = emoji;
    label.opaque = NO;
    label.backgroundColor = [UIColor clearColor];
    CGSize labelSize = CGSizeMake(size, size);
    label.frame = CGRectMake(0, 0, labelSize.width, labelSize.height);
    
    return [UIImage imageFromView:label];
}

+ (UIImage *)imageWithEmoji:(NSString *)emoji
{
    return [UIImage imageWithEmoji:emoji
                          withSize:DEFAULTTEXTSIZE];
}


+ (UIImage *)imageFromView:(UIView *)view
{
    UIGraphicsPushContext(UIGraphicsGetCurrentContext());
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsPopContext();
    
    return img;
}
@end
