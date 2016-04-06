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

//@property (nonatomic, strong)NSString *filePath;
//@property(nonatomic, retain) NSLock *countedSetLock;
@property(nonatomic, strong) UITextChecker *textChecker;

@end

@implementation SpellCheckerManager


//- (id)initWithWordsFilePath:(NSString *)path {
//	if (!path) {
//		[NSException raise:NSInvalidArgumentException format:@"path is nil"];
//	}
//
//	self = [super init];
//	if (self) {
//		self.countedSet = [NSCountedSet set];
////		self.countedSetLock = [[NSLock alloc] init];
//		self.filePath = path;
//	}
//	return self;
//}

#pragma mark - Public Methods


- (void)loadForSpellCorrection {
	[SpellCheckerBridge loadForSpellCorrection];
	self.textChecker = [UITextChecker new];

}

- (void)updateControllersWithRealWord:(NSString *)text {
	NSString *word = text;
	NSArray *guesses = [self.textChecker guessesForWord:text.letterCharacterString];

	if (guesses.count > 0) {
		// punctuation hopefully
		NSString *secondaryWord = guesses[0];
		BOOL shouldUseGuess = NO;
		for (int charIndex = 0; charIndex < secondaryWord.length; ++charIndex) {
			if ([secondaryWord characterAtIndex:(NSUInteger) charIndex] == '\'') {
				shouldUseGuess = YES;
				break;
			}
		}

		if (!shouldUseGuess && ![text isEqualToString:word]) {
			secondaryWord = text.quotedString;
		}
//		[self.secondaryController updateText:[text stringByReplacingLetterCharactersWithString:secondaryWord]];
//		NSLog(@"secondWord:%@", secondaryWord);
		[self.delegate secondarySpell:secondaryWord];
		NSString *tertiaryWord = guesses.count > 1 ? _properCasing(guesses[1], text.isUppercase) : nil;
		tertiaryWord = [text stringByReplacingLetterCharactersWithString:tertiaryWord];
//		NSLog(@"tertiaryWord%@", tertiaryWord);
		[self.delegate tertiarySpell:tertiaryWord];
//		[self.tertiaryController updateText:tertiaryWord];
	}

//	[self.primaryController updateText:word.quotedString];
	[self.delegate primarySpell:word.quotedString];
//	NSLog(@"primaryController: %@", word.quotedString);
//	self.primaryControllerCanTrigger = YES;
}

- (void)updateControllersWithMisspelledWord:(NSString *)text corrections:(NSArray *)corrections {
//	[self.secondaryController updateText:text.quotedString];
//	NSLog(@"SecondaryControllerAuto%@", text.quotedString);
	[self.delegate secondarySpell:text.quotedString];
	SpellCheckerCommunicator *firstResult = corrections[0];
	NSString *word = _properCasing(firstResult.word, text.isUppercase);
	NSString *primaryWord = [text stringByReplacingLetterCharactersWithString:word];

//	[self.primaryController updateText:primaryWord];
//	self.primaryControllerCanTrigger = YES;
//	NSLog(@"PrimaryWordAuto:%@", primaryWord);
	[self.delegate primarySpell:primaryWord];

	if (corrections.count > 1) {
		for (int correctionIndex = 1; correctionIndex < corrections.count; ++correctionIndex) {
			SpellCheckerCommunicator *result = corrections[(NSUInteger) correctionIndex];
			NSString *resultWord = _properCasing(result.word, text.isUppercase);
			if (![resultWord isEqualToString:word] && resultWord.length > 0) {
				NSString *tertiaryWord = [text stringByReplacingLetterCharactersWithString:resultWord];

//				NSLog(@"tertiaryWordAuto%@", tertiaryWord);

				[self.delegate tertiarySpell:tertiaryWord];

//				[self.tertiaryController updateText:tertiaryWord];
				break;
			}
		}
	}
}


- (void)updateControllersWithInvalidWord:(NSString *)word {
//	[self.primaryController updateText:word.quotedString];
//	[self.secondaryController updateText:@""];
//	[self.tertiaryController updateText:@""];
//	NSLog(@"invalidWord%@", word.quotedString);
	[self.delegate primarySpell:word.quotedString];
	[self.delegate tertiarySpell:@""];
	[self.delegate secondarySpell:@""];
//	[self.delegate hideView:YES];


}

- (void)fetchWords:(NSString *)queryString {

	if (queryString) {

//		[self.delegate hideView:NO];

		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

			if (queryString.isValidForCorrecting) {
				NSArray *corrections = [SpellCheckerBridge correctionsForText:queryString.letterCharacterString];

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

//		[self.delegate hideView:YES];
	}



//
//	UITextChecker *checker = [[UITextChecker alloc] init];
//	NSString *prefix = [queryString substringToIndex:queryString.length - 1];
//	// Won't get suggestions for correct words, so we are scrambling the words
////	NSString *scrambledWord = [NSString stringWithFormat:@"%@%@",queryString, [self getRandomCharAsNSString]];
////	NSRange checkRange = NSMakeRange(0, scrambledWord.length);
////	NSRange misspelledRange = [checker rangeOfMisspelledWordInString:scrambledWord range:checkRange startingAt:checkRange.location wrap:YES  language:@"en_US"];
//
//	NSArray *arrGuessed = [checker guessesForWordRange:NSMakeRange(0, queryString.length) inString:queryString language:@"en_US"];
//	// NSLog(@"Arr ===== %@",arrGuessed);
//	// Filter the result based on the word
//	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@", queryString];
//	NSArray *arrayfiltered = [arrGuessed filteredArrayUsingPredicate:predicate];
//	if (arrayfiltered.count == 0) {
//		// Filter the result based on the prefix
//		NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@", prefix];
//		arrayfiltered = [arrGuessed filteredArrayUsingPredicate:newPredicate];
//	}
//	return (arrayfiltered);
//
//
//
//
//
//
//
////	for (UILexiconEntry *lexiconEntry in self.lexicon.entries) {
////			NSLog(@"lexicon %@", lexiconEntry.userInput);
////		if ([lexiconEntry.userInput isEqualToString:queryString]) {
////
////		}
////	}
//
//
//	UITextChecker *textChecker = [[UITextChecker alloc] init];
////	NSArray *completions = [textChecker completionsForPartialWordRange:NSMakeRange(0, queryString.length) inString:queryString language:@"en"];
//	NSArray *suggestions = [textChecker guessesForWordRange:NSMakeRange(0, [queryString length]) inString:queryString language:@"en"];

//	NSLog(@"Suggestions%@", suggestions);


//	if (suggestions.count > 2) {
//
//
//		return @[suggestions[0], suggestions[1], suggestions[2]];
//
//	}


}


@end