//
//  NSUserDefaults+Keyboard.m
//  MMCustomKeyboard
//
//  Created by Tom Atterton on 10/05/16.
//  Copyright © 2016 mm0030240. All rights reserved.
//

#import "NSUserDefaults+Keyboard.h"


static NSString *const SET_LANGUAGE = @"bdDSFdf$#%FD";

@implementation NSUserDefaults (Keyboard)

- (instancetype)init {

	self = [super init];
	if (self) {

		self = [self initWithSuiteName:@"group.TomMonk.MMCustomKeyboard"];
	}

	return self;
}

- (changeLanguage )language {

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


@end
