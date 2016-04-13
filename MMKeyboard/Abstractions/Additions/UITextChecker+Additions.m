//
//  UITextChecker+Additions.m
//  MMCustomKeyboard
//
//  Created by Tom Atterton on 06/04/16.
//  Copyright © 2016 mm0030240. All rights reserved.
//

#import "UITextChecker+Additions.h"

static NSString* _deviceLanguage()
{
	return [NSLocale preferredLanguages][0];
}

static NSRange _range(NSString* word)
{
	return NSMakeRange(0, word.length);
}

@implementation UITextChecker (Additions)

- (NSArray*)guessesForWord:(NSString *)word
{
	return [self guessesForWordRange:_range(word) inString:word language:_deviceLanguage()];
}

- (NSArray*)completionsForWord:(NSString*)word
{
	return [self completionsForPartialWordRange:_range(word) inString:word language:_deviceLanguage()];
}

@end
