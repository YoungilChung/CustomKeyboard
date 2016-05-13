//
// Created by Tom Atterton on 13/05/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMKeyboardThemeModel.h"


@implementation MMKeyboardThemeModel {

}
- (instancetype)initWithKeyboardTheme:(keyboardTheme)keyboardTheme {


	self = [super init];
	if (self) {
		switch (keyboardTheme) {
			case kKeyboardThemeDark: {

				self.mainColor = [UIColor blackColor];
				self.subColor = [UIColor blackColor];
				self.keyboardBackgroundColor = [UIColor blackColor];
				self.keyboardFontColor = [UIColor whiteColor];
				self.keyboardPopViewFontColor = [UIColor blackColor];

				break;
			}
			case kKeyboardThemeSun: {

				self.mainColor = [UIColor orangeColor];
				self.subColor = [UIColor orangeColor];
				self.keyboardBackgroundColor = [UIColor yellowColor];
				self.keyboardFontColor = [UIColor whiteColor];
				self.keyboardPopViewFontColor = [UIColor blackColor];

				break;
			}
			case kKeyboardThemeOrange: {

				self.mainColor = [UIColor orangeColor];
				self.subColor = [UIColor orangeColor];
				self.keyboardBackgroundColor = [UIColor orangeColor];
				self.keyboardFontColor = [UIColor whiteColor];
				self.keyboardPopViewFontColor = [UIColor blackColor];

				break;
			}
			case kKeyboardThemeNature: {

				self.mainColor = [UIColor greenColor];
				self.subColor = [UIColor greenColor];
				self.keyboardBackgroundColor = [UIColor brownColor];
				self.keyboardFontColor = [UIColor whiteColor];
				self.keyboardPopViewFontColor = [UIColor blackColor];

				break;
			}
			case kKeyboardThemeSteel: {

				self.mainColor = [UIColor grayColor];
				self.subColor = [UIColor lightGrayColor];
				self.keyboardBackgroundColor = [UIColor groupTableViewBackgroundColor];
				self.keyboardFontColor = [UIColor whiteColor];
				self.keyboardPopViewFontColor = [UIColor blackColor];

				break;
			}
			case kKeyboardThemePurple: {

				self.mainColor = [UIColor purpleColor];
				self.subColor = [UIColor purpleColor];
				self.keyboardBackgroundColor = [UIColor purpleColor];
				self.keyboardFontColor = [UIColor whiteColor];
				self.keyboardPopViewFontColor = [UIColor blackColor];
				break;
			}
			case kKeyboardThemeSea: {

				self.mainColor = [UIColor blueColor];
				self.subColor = [UIColor greenColor];
				self.keyboardBackgroundColor = [UIColor blueColor];
				self.keyboardFontColor = [UIColor whiteColor];
				self.keyboardPopViewFontColor = [UIColor blackColor];

				break;
			}
		}
	}
	return self;
}

@end