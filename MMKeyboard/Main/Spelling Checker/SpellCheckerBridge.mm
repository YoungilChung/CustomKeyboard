//
// Created by Tom Atterton on 06/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "SpellCheckerBridge.h"
#import "SpellChecker.h"
#import "SpellCheckerCommunicator.h"
#include <string>
#include <vector>


@interface SpellCheckerBridge () {

	SpellChecker _checker;
}

@property(nonatomic, assign) BOOL isLoaded;

@end

@implementation SpellCheckerBridge

+ (SpellCheckerBridge *)spellCorrector {
	static SpellCheckerBridge *spellCorrector = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		spellCorrector = [SpellCheckerBridge new];
	});
	return spellCorrector;
}

#pragma mark - Public Class Methods

+ (void)loadForSpellCorrection {
	SpellCheckerBridge *spellCorrector = [self spellCorrector];
	if (!spellCorrector.isLoaded) {
		[spellCorrector loadFileForCorrections];
		spellCorrector.isLoaded = YES;
	}
}

+ (NSArray *)correctionsForText:(NSString *)text {
	SpellCheckerBridge *spellCorrector = [self spellCorrector];
	NSArray *results = nil;
	if (spellCorrector.isLoaded) {
		results = [spellCorrector corrections:text];
	}
	return results;
}

#pragma mark - Private

- (void)loadFileForCorrections {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"wiki-100k" ofType:@"txt"];
	_checker.load(filePath.fileSystemRepresentation);
}

- (NSArray *)corrections:(NSString *)text {
	Dictionary candidates = _checker.corrections(text.lowercaseString.UTF8String);

	NSMutableArray *results = [NSMutableArray array];
	for (Dictionary::iterator it = candidates.begin(); it != candidates.end(); ++it) {
		NSString *word = [NSString stringWithUTF8String:it->first.c_str()];
		SpellCheckerCommunicator *result = [SpellCheckerCommunicator resultWithWord:word likelihood:(NSUInteger) it->second];

		[results addObject:result];
	}

	return [results sortedArrayUsingComparator:^NSComparisonResult(SpellCheckerCommunicator *obj1, SpellCheckerCommunicator *obj2) {

		if (obj1.likelihood == obj2.likelihood) {
			return NSOrderedSame;
		}
		return (obj1.likelihood > obj2.likelihood) ? NSOrderedAscending : NSOrderedDescending;
	}];
}

@end