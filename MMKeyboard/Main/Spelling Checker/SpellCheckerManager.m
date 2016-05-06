//
// Created by Tom Atterton on 05/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "SpellCheckerManager.h"
#import "SpellCheckerCommunicator.h"
#import "SpellCheckerBridge.h"
#import "NSString+Additions.h"
#import "UITextChecker+Additions.h"
#import "SpellCheckerDelegate.h"


static NSString *_properCasing(NSString *string, BOOL uppercase) {
	NSString *retVal = string;
	if (uppercase) {
		retVal = string.titleCase;
	}
	return retVal;
}

@interface SpellCheckerManager ()

@property(nonatomic, strong) UITextChecker *textChecker;
@property(nonatomic, strong) UILexicon *lexicon;
@property(nonatomic, strong) NSMutableArray *lexiconResults;

@end

@implementation SpellCheckerManager


- (void)loadForSpellCorrection {
	[SpellCheckerBridge loadForSpellCorrection];
	self.textChecker = [UITextChecker new];
	[self.lexicon.entries enumerateObjectsUsingBlock:^(UILexiconEntry *obj, NSUInteger idx, BOOL *stop) {

		[self.lexiconResults addObject:obj.userInput];
	}];


}

- (void)updateControllersWithRealWord:(NSString *)text {


	NSString *word = text;
	NSArray *guesses = [self.textChecker guessesForWord:text.letterCharacterString];

	if (guesses.count > 0) {

		NSString *secondaryWord = guesses[0];
		BOOL shouldUseGuess = NO;
		for (int charIndex = 0; charIndex < secondaryWord.length; ++charIndex) {
			if ([secondaryWord characterAtIndex:(NSUInteger) charIndex] == '\'') {
				shouldUseGuess = YES;
				break;
			}
		}

		if (!shouldUseGuess && ![text isEqualToString:word]) {
//			secondaryWord = text.quotedString;
		}

		[self.delegate secondarySpell:secondaryWord];
		NSString *tertiaryWord = guesses.count > 1 ? _properCasing(guesses[1], text.isUppercase) : nil;
		tertiaryWord = [text stringByReplacingLetterCharactersWithString:tertiaryWord];
        NSLog(@"0%@", guesses
              );
		[self.delegate tertiarySpell:tertiaryWord];


	[self.delegate primarySpell:word.quotedString];
	}
	else {

		NSLog(@"no more sorry");
		if (text.length > 6)
		{

			[self.delegate hideView:YES];
		}
	}

}

- (void)updateControllersWithMisspelledWord:(NSString *)text corrections:(NSArray *)corrections {
	NSLog(@"update here");

	[self.delegate secondarySpell:text.quotedString];
	SpellCheckerCommunicator *firstResult = corrections[0];

	NSString *word = _properCasing(firstResult.word, text.isUppercase);
	NSString *primaryWord = [text stringByReplacingLetterCharactersWithString:word];

	[self.delegate primarySpell:primaryWord];

	if (corrections.count > 1) {

		for (int correctionIndex = 1; correctionIndex < corrections.count; ++correctionIndex) {
			SpellCheckerCommunicator *result = corrections[(NSUInteger) correctionIndex];
			NSString *resultWord = _properCasing(result.word, text.isUppercase);

			if (![resultWord isEqualToString:word] && resultWord.length > 0) {
				NSString *tertiaryWord = [text stringByReplacingLetterCharactersWithString:resultWord];

				[self.delegate tertiarySpell:tertiaryWord];
				break;
			}
		}
	}
}


- (void)updateControllersWithInvalidWord:(NSString *)word {

	[self.delegate primarySpell:word.quotedString];
	[self.delegate tertiarySpell:@""];
	[self.delegate secondarySpell:@""];
	[self.delegate hideView:YES];


}

- (void)fetchWords:(NSString *)queryString {

	if (queryString) {

		[self.delegate hideView:NO];

		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

			if (queryString.isValidForCorrecting) {
				NSArray *corrections = [SpellCheckerBridge correctionsForText:queryString];

				if (corrections.count == 0) {
					[self updateControllersWithRealWord:queryString];
				}
				else {
					[self updateControllersWithMisspelledWord:queryString corrections:corrections];
				}
			}
			else {
				[self updateControllersWithInvalidWord:queryString];
			}

		});
	}
	else {

		[self.delegate hideView:YES];
	}

}


@end