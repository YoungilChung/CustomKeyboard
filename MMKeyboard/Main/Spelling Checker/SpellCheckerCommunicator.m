//
// Created by Tom Atterton on 05/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "SpellCheckerCommunicator.h"


@implementation SpellCheckerCommunicator

#pragma mark - Class Init

+ (instancetype)resultWithWord:(NSString *)word likelihood:(NSUInteger)likelihood {
	SpellCheckerCommunicator *result = [SpellCheckerCommunicator new];
	result.word = word;
	result.likelihood = likelihood;
	return result;
}
@end