//
// Created by Tom Atterton on 13/05/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef enum {
	kKeyboardThemeDark = 100,
	kKeyboardThemeSun,
	kKeyboardThemeOrange,
	kKeyboardThemeNature,
	kKeyboardThemeSteel,
	kKeyboardThemePurple,
	kKeyboardThemeSea,
} keyboardTheme;


@interface MMKeyboardThemeModel : NSObject

- (instancetype)initWithKeyboardTheme:(keyboardTheme)keyboardTheme;

@property(nonatomic, strong) UIColor *mainColor;
@property(nonatomic, strong) UIColor *subColor;
@property(nonatomic, strong) UIColor *keyboardBackgroundColor;
@property(nonatomic, strong) UIColor *keyboardFontColor;
@property(nonatomic, strong) UIColor *keyboardPopViewFontColor;

@end