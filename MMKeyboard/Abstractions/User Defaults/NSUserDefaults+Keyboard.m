//
//  NSUserDefaults+Keyboard.m
//  MMCustomKeyboard
//
//  Created by Tom Atterton on 10/05/16.
//  Copyright © 2016 mm0030240. All rights reserved.
//

#import "NSUserDefaults+Keyboard.h"


static NSString *const SET_LANGUAGE = @"bdDSFdf$#%FD";
static NSString *const AUTOCORRECT = @"dfgdfg#%FD";
static NSString *const QUICK_PERIOD = @"gfgfgrgr#%FD";
static NSString *const AUTO_CAPITALIZE = @"bfdhgfdh#%FD";
static NSString *const DOUBLE_SPACE = @"hgfdjjg#%FD";
static NSString *const KEY_CLICK_SOUNDS = @"hsafru5h#%FD";
static NSString *const THEME = @"hloyhhr#%FD";
static NSString *const KEYBOARD_FONT = @"hrtdufh#%FD";

@implementation NSUserDefaults (Keyboard)

- (instancetype)init {

	self = [super init];
	if (self) {

		self = [self initWithSuiteName:@"group.TomMonk.MMCustomKeyboard"];
	}

	return self;
}

#pragma mark Keyboard Change Language

- (changeLanguage)language {

	return (changeLanguage) [self integerForKey:SET_LANGUAGE];
}

- (void)setLanguage:(changeLanguage)language {

	if (language) {
		[self setInteger:language forKey:SET_LANGUAGE];
	}
	else {
		[self removeObjectForKey:SET_LANGUAGE];
	}

	[self synchronize];
}


# pragma mark Settings

- (BOOL)isAutoCorrect {

	return [self boolForKey:AUTOCORRECT];
}

- (void)setIsAutoCorrect:(BOOL)isAutoCorrect {

	if (isAutoCorrect) {
		[self setInteger:isAutoCorrect forKey:AUTOCORRECT];
	}
	else {
		[self removeObjectForKey:AUTOCORRECT];
	}

	[self synchronize];


}

- (BOOL)isQuickPeriod {
	return [self boolForKey:QUICK_PERIOD];
}

- (void)setIsQuickPeriod:(BOOL)isQuickPeriod {

	if (isQuickPeriod) {
		[self setInteger:isQuickPeriod forKey:QUICK_PERIOD];
	}
	else {
		[self removeObjectForKey:QUICK_PERIOD];
	}

	[self synchronize];


}

- (BOOL)isAutoCapitalize {
	return [self boolForKey:AUTO_CAPITALIZE];
}

- (void)setIsAutoCapitalize:(BOOL)isAutoCapitalize {

	if (isAutoCapitalize) {
		[self setInteger:isAutoCapitalize forKey:AUTO_CAPITALIZE];
	}
	else {
		[self removeObjectForKey:AUTO_CAPITALIZE];
	}

	[self synchronize];


}

- (BOOL)isDoubleSpacePunctuation {
	return [self boolForKey:DOUBLE_SPACE];
}

- (void)setIsDoubleSpacePunctuation:(BOOL)isDoubleSpacePunctuation {

	if (isDoubleSpacePunctuation) {
		[self setInteger:isDoubleSpacePunctuation forKey:DOUBLE_SPACE];
	}
	else {
		[self removeObjectForKey:DOUBLE_SPACE];
	}

	[self synchronize];

}

- (BOOL)isKeyClickSounds {
	return [self boolForKey:KEY_CLICK_SOUNDS];
}

- (void)setIsKeyClickSounds:(BOOL)isKeyClickSounds {
	if (isKeyClickSounds) {
		[self setInteger:isKeyClickSounds forKey:KEY_CLICK_SOUNDS];
	}
	else {
		[self removeObjectForKey:KEY_CLICK_SOUNDS];
	}

	[self synchronize];
}

- (UIColor *)isTheme {
	return [self objectForKey:THEME];
}

- (void)setIsTheme:(UIColor *)isTheme {
	if (isTheme) {
		[self setObject:isTheme forKey:THEME];
	}
	else {
		[self removeObjectForKey:THEME];
	}

	[self synchronize];
}

- (NSString *)isKeyboardFont {
	return [self stringForKey:KEYBOARD_FONT];
}

- (void)setIsKeyboardFont:(NSString *)isKeyboardFont {
	if (isKeyboardFont) {
		[self setValue:isKeyboardFont forKey:KEYBOARD_FONT];
	}
	else {
		[self removeObjectForKey:KEYBOARD_FONT];
	}

	[self synchronize];
}


@end
