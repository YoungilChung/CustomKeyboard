//
//  UIImage+emoji.h
//  MMCustomKeyboard
//
//  Created by Tom Atterton on 18/03/16.
//  Copyright © 2016 mm0030240. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFAULTTEXTSIZE 12.0f

@interface UIImage (emoji)

+ (UIImage *)imageWithEmoji:(NSString *)emoji;

+ (UIImage *)imageWithEmoji:(NSString *)emoji
                   withSize:(CGFloat)size;

@end
