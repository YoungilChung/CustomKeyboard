//
//  UIColor+KeyboardColors.h
//  MMCustomKeyboard
//
//  Created by Tom Atterton on 13/05/16.
//  Copyright © 2016 mm0030240. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (KeyboardColors)

@property (nonatomic, strong) UIColor *mainThemeColor;
@property (nonatomic, strong) UIColor *subThemeColor;
@property (nonatomic, strong) UIColor *backgroundThemeColor;


+(UIColor *)mainKeyThemeColor;
+(UIColor *)subKeyThemeColor;
+(UIColor *)backgroundKeyThemeColor;

@end
