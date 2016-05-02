// Created by Tom Atterton on 06/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "AutoCorrectCollectionView.h"
#import "SpellCheckerDelegate.h"
#import "SuggestionView.h"

@interface AutoCorrectCollectionView () <UIGestureRecognizerDelegate>
\
@property(nonatomic, strong) SuggestionView *secondaryHolder;
@property(nonatomic, strong) SuggestionView *tertiaryHolder;
@property(nonatomic, strong) SuggestionView *primaryHolder;
@end

@implementation AutoCorrectCollectionView


- (instancetype)init {
	self = [super init];

	if (self) {

		[self setup];
	}

	return self;
}


- (void)setup {


	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
	tapGestureRecognizer.delegate = self;
	tapGestureRecognizer.delaysTouchesBegan = YES;
	[self addGestureRecognizer:tapGestureRecognizer];

	[self setBackgroundColor:[UIColor grayColor]];

	self.primaryHolder = [SuggestionView new];
	self.primaryHolder.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.primaryHolder];

	self.secondaryHolder = [SuggestionView new];
	self.secondaryHolder.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.secondaryHolder];

	self.tertiaryHolder = [SuggestionView new];
	self.tertiaryHolder.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.tertiaryHolder];

	NSDictionary *views = @{@"primaryHolder" : self.primaryHolder, @"secondaryHolder" : self.secondaryHolder, @"tertiaryHolder" : self.tertiaryHolder};


	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[primaryHolder]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[secondaryHolder]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[tertiaryHolder]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[primaryHolder(tertiaryHolder)]-2-[secondaryHolder(primaryHolder)]-2-[tertiaryHolder(primaryHolder)]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

}


- (void)updateText:(NSString *)updatedText forSection:(sectionHeaders)section {

	switch (section) {
		case ksectionHeaderPrimary: {
			[self.primaryHolder updateLabel:updatedText];
			self.primaryString = updatedText;

			break;
		}
		case ksectionHeaderSecondary: {
			[self.secondaryHolder updateLabel:updatedText];
			self.secondaryString = updatedText;
			break;
		}
		case ksectionHeaderTertiary: {
			[self.tertiaryHolder updateLabel:updatedText];
			self.tertiaryString = updatedText;
			break;
		}
	}

}

#pragma mark Touch Gestures

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {

	UIView *view = sender.view;
	CGPoint loc = [sender locationInView:view];
	UIView *subview = [view hitTest:loc withEvent:nil];

	if (subview == self.primaryHolder) {
		if (self.primaryString) {
			if (self.primaryString.length > 0) {

				[self.delegate tappedWord:self.primaryString];
			}
		}

	}
	if (subview == self.secondaryHolder) {
		if (self.secondaryString) {
			if (self.secondaryString.length > 0) {

				[self.delegate tappedWord:self.secondaryString];
			}
		}
	}
	if (subview == self.tertiaryHolder) {
		if (self.tertiaryString) {
			if (self.tertiaryString.length > 0) {

				[self.delegate tappedWord:self.tertiaryString];
			}
		}
	}


}

@end