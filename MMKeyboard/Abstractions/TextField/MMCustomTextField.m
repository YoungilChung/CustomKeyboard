//
// Created by Tom Atterton on 13/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMCustomTextField.h"


@implementation MMCustomTextField



+ (void)selectTextForInput:(UITextField *)input atRange:(NSRange)range {
	UITextPosition *start = [input positionFromPosition:[input beginningOfDocument]
												 offset:range.location];
	UITextPosition *end = [input positionFromPosition:start
											   offset:range.length];
	[input setSelectedTextRange:[input textRangeFromPosition:start toPosition:end]];
}


@end