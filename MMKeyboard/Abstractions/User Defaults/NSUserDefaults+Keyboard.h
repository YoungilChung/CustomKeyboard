//
//  NSUserDefaults+Keyboard.h
//  MMCustomKeyboard
//
//  Created by Tom Atterton on 10/05/16.
//  Copyright © 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMKeyboardSelection.h"

@interface NSUserDefaults (Keyboard)

@property (nonatomic, assign) changeLanguage language;
@property (nonatomic, assign) BOOL isAutoCorrect;
@property (nonatomic, assign) BOOL isQuickPeriod;
@property (nonatomic, assign) BOOL isAutoCapitalize;
@property (nonatomic, assign) BOOL isDoubleSpacePunctuation;
@property (nonatomic, assign) BOOL isKeyClickSounds;
@property (nonatomic, assign) UIColor * isTheme;
@property (nonatomic, assign) NSString * isKeyboardFont;

@end
