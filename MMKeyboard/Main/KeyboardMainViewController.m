//
// Created by Tom Atterton on 31/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "KeyboardMainViewController.h"
#import "MMAlphaKeyboardView.h"
#import "SearchBarView.h"
#import "MMkeyboardButton.h"
#import "MMKeyboardCollectionView.h"
#import "MMCustomTextField.h"
#import "SearchGIFManager.h"
#import "CategoryHolder.h"
#import "SpellCheckerManager.h"
#import "AutoCorrectCollectionView.h"


typedef enum {
	kTagGIFKeyboard = 100,
	kTagABCKeyboard,

} buttonTags;


@interface KeyboardMainViewController () <UITextDocumentProxy>


// Views
@property(nonatomic, strong) MMAlphaKeyboardView *keyboardView;
@property(nonatomic, strong) SearchBarView *searchHolder;
@property(nonatomic, strong) CategoryHolder *categoryHolderView;
@property(nonatomic, strong) UIView *gifKeyboardHolder;
@property(nonatomic, strong) MMKeyboardCollectionView *gifKeyboardView;
@property(nonatomic, strong) AutoCorrectCollectionView *autoCorrectCollectionView;
@property(nonatomic, strong) SpellCheckerManager *spellCheckerManager;

// Variables
@property(nonatomic, strong) UILabel *messageText;
@property(nonatomic, strong) NSDictionary *userInfo;
@property(nonatomic, strong) NSString *gifURL;
@property(nonatomic, strong) NSString *currentString;


// Constraints
@property(nonatomic, strong) NSLayoutConstraint *keyboardLeftConstraint;
@property(nonatomic, strong) NSLayoutConstraint *gifKeyboardLeftConstraint;
@property(nonatomic, strong) NSLayoutConstraint *categoryLeftConstraint;

@end

@implementation KeyboardMainViewController


- (void)viewDidLoad {
	[super viewDidLoad];



	self.spellCheckerManager = [SpellCheckerManager new];
	self.spellCheckerManager.delegate = self;
	[self.spellCheckerManager loadForSpellCorrection];


	self.autoCorrectCollectionView = [[AutoCorrectCollectionView alloc] initWithSpellManager:self.spellCheckerManager];
	self.autoCorrectCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.autoCorrectCollectionView];

	self.keyboardView = [[MMAlphaKeyboardView alloc] init];
	[[MMAlphaKeyboardView alloc] inputAssistantItem];
	self.keyboardView.translatesAutoresizingMaskIntoConstraints = NO;
	self.keyboardView.keyboardDelegate = self;
	[self.keyboardView.nextKeyboardButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.keyboardView];

	self.searchHolder = [[SearchBarView alloc] init];
	self.searchHolder.translatesAutoresizingMaskIntoConstraints = NO;
	self.searchHolder.clipsToBounds = YES;
	self.searchHolder.keyboardDelegate = self;
	[self.searchHolder.gifButton addTarget:self action:@selector(changeKeyboardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.searchHolder];

	self.categoryHolderView = [CategoryHolder new];
	self.categoryHolderView.translatesAutoresizingMaskIntoConstraints = NO;
	self.categoryHolderView.clipsToBounds = YES;
	[self.categoryHolderView.allButton addTarget:self action:@selector(allButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self.categoryHolderView.normalButton addTarget:self action:@selector(normalButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self.categoryHolderView.awesomeButton addTarget:self action:@selector(awesomeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self.categoryHolderView.deleteButton addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.categoryHolderView];

	self.gifKeyboardHolder = [UIView new];
	self.gifKeyboardHolder.translatesAutoresizingMaskIntoConstraints = NO;
	self.gifKeyboardHolder.clipsToBounds = YES;
	[self.view addSubview:self.gifKeyboardHolder];


	self.gifKeyboardView = [[MMKeyboardCollectionView alloc] init];
	self.gifKeyboardView.translatesAutoresizingMaskIntoConstraints = NO;
	self.gifKeyboardView.clipsToBounds = YES;
	self.gifKeyboardView.keyboardDelegate = self;
	[self.gifKeyboardHolder addSubview:self.gifKeyboardView];

	NSDictionary *views = @{@"searchBar" : self.searchHolder, @"keyboardView" : self.keyboardView, @"gifKeyboard" : self.gifKeyboardView};
	NSDictionary *metrics = @{};

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchHolder attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.autoCorrectCollectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.autoCorrectCollectionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.autoCorrectCollectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.autoCorrectCollectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.keyboardView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchHolder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.categoryHolderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];


	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gifKeyboardHolder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
	[self.gifKeyboardHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[gifKeyboard]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self.gifKeyboardHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[gifKeyboard]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];


	self.searchHolder.gifButton.tag = kTagGIFKeyboard;

//	[self requestSupplementaryLexiconWithCompletion:^(UILexicon *receivedLexicon) {
//		self.lexicon = receivedLexicon;
//	}];


}

- (void)changeKeyboardButtonPressed:(MMkeyboardButton *)sender {

	[self animateKeyboard:(buttonTags) sender.tag];

}

- (void)deleteButtonTapped:(UIButton *)sender {
	[self.textDocumentProxy deleteBackward];

}

- (void)awesomeButtonTapped:(UIButton *)sender {

	self.gifKeyboardView.type = MMSearchTypeAwesome;
	[self.gifKeyboardView loadGifs];


}

- (void)normalButtonTapped:(UIButton *)sender {
	self.gifKeyboardView.type = MMSearchTypeNormal;
	[self.gifKeyboardView loadGifs];

}

- (void)allButtonTapped:(UIButton *)sender {
	self.gifKeyboardView.type = MMSearchTypeAll;
	[self.gifKeyboardView loadGifs];

}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeSubview:) name:@"closeSubview" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];


	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchHolder attribute:NSLayoutAttributeTop
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view attribute:NSLayoutAttributeTop
														 multiplier:1.0 constant:2]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchHolder attribute:NSLayoutAttributeBottom
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.keyboardView attribute:NSLayoutAttributeTop
														 multiplier:1.0 constant:-5]];
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.autoCorrectCollectionView attribute:NSLayoutAttributeTop
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view attribute:NSLayoutAttributeTop
														 multiplier:1.0 constant:2]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.autoCorrectCollectionView attribute:NSLayoutAttributeBottom
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.keyboardView attribute:NSLayoutAttributeTop
														 multiplier:1.0 constant:-5]];
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//	self.autoCorrectCollectionView.hidden = YES;
	self.searchHolder.hidden = YES;
	self.autoCorrectCollectionView.hidden = NO;
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchHolder attribute:NSLayoutAttributeBottom
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.gifKeyboardHolder attribute:NSLayoutAttributeTop
														 multiplier:1.0 constant:-5]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gifKeyboardHolder attribute:NSLayoutAttributeBottom
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.categoryHolderView attribute:NSLayoutAttributeTop
														 multiplier:1.0 constant:-5]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.categoryHolderView attribute:NSLayoutAttributeBottom
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view attribute:NSLayoutAttributeBottom
														 multiplier:1.0 constant:0]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.keyboardView attribute:NSLayoutAttributeBottom
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view attribute:NSLayoutAttributeBottom
														 multiplier:1.0 constant:0]];


//	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.categoryHolderView attribute:NSLayoutAttributeHeight
//														  relatedBy:NSLayoutRelationGreaterThanOrEqual
//															 toItem:nil attribute:NSLayoutAttributeNotAnAttribute
//														 multiplier:1.0 constant:10]];
	CGRect Rect = [[UIScreen mainScreen] bounds];

	NSLayoutConstraint *_heightConstraint;
//	_heightConstraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:(CGFloat) (Rect.size.height / 2.8)];
//	[self.view addConstraint:_heightConstraint];


	self.keyboardLeftConstraint = [NSLayoutConstraint constraintWithItem:self.keyboardView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
	self.gifKeyboardLeftConstraint = [NSLayoutConstraint constraintWithItem:self.gifKeyboardHolder attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:self.view.frame.size.width];
	self.categoryLeftConstraint = [NSLayoutConstraint constraintWithItem:self.categoryHolderView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:self.view.frame.size.width];

	[self.view addConstraint:self.gifKeyboardLeftConstraint];
	[self.view addConstraint:self.keyboardLeftConstraint];
	[self.view addConstraint:self.categoryLeftConstraint];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];

	switch (self.searchHolder.gifButton.tag) {

		case kTagABCKeyboard: {

			if (UIDeviceOrientationIsPortrait((UIDeviceOrientation) self.interfaceOrientation)) {
				//DO Portrait
				self.gifKeyboardView.keyboardCollectionViewSize = CGSizeMake((CGFloat) (self.gifKeyboardView.layer.frame.size.width / 2), (CGFloat) (self.gifKeyboardView.layer.frame.size.height / 2.015));
			}
			else {
				//DO Landscape
				self.gifKeyboardView.keyboardCollectionViewSize = CGSizeMake((CGFloat) (self.gifKeyboardView.layer.frame.size.width / 4.015), self.gifKeyboardView.layer.frame.size.height);
			}

			break;
		}
		default:
			break;
	}
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"closeSubview" object:nil];
	self.userInfo = @{};
}

#pragma mark Actions


- (void)animateKeyboard:(buttonTags)tag {


	switch (tag) {
		case kTagGIFKeyboard: {


			if ([self.searchHolder.searchBar.text isEqualToString:@""]) {
				if (self.gifKeyboardView.type == MMSearchTypeGiphy) {

					self.gifKeyboardView.type = MMSearchTypeAll;
					[self.gifKeyboardView loadGifs];

				}

			}

			self.keyboardLeftConstraint.constant = -self.view.frame.size.width;
			self.gifKeyboardLeftConstraint.constant = 0;
			self.categoryLeftConstraint.constant = 0;

			self.searchHolder.gifButton.tag = kTagABCKeyboard;
			[self.searchHolder.gifButton setTitle:@"ABC" forState:UIControlStateNormal];

			if (UIDeviceOrientationIsPortrait((UIDeviceOrientation) self.interfaceOrientation)) {
				//DO Portrait
				self.gifKeyboardView.keyboardCollectionViewSize = CGSizeMake((CGFloat) (self.gifKeyboardView.layer.frame.size.width / 2), (CGFloat) (self.gifKeyboardView.layer.frame.size.height / 2.015));
			}
			else {
				//DO Landscape
				self.gifKeyboardView.keyboardCollectionViewSize = CGSizeMake((CGFloat) (self.gifKeyboardView.layer.frame.size.width / 4.015), self.gifKeyboardView.layer.frame.size.height);
			}

			break;
		}
		case kTagABCKeyboard: {

			self.keyboardLeftConstraint.constant = 0;
			self.gifKeyboardLeftConstraint.constant = self.view.frame.size.width;
			self.categoryLeftConstraint.constant = self.view.frame.size.width;
			[self.gifKeyboardView.keyboardCollectionView setContentOffset:CGPointZero animated:YES];

			self.searchHolder.gifButton.tag = kTagGIFKeyboard;
			[self.searchHolder.gifButton setTitle:@"GIF" forState:UIControlStateNormal];

			break;
		}

		default: {

			break;
		}
	}

	[UIView animateWithDuration:0.3 animations:^{

		[self.view layoutIfNeeded];
		[self.view setNeedsDisplay];
		[self.gifKeyboardView.keyboardCollectionView.collectionViewLayout invalidateLayout];


	}                completion:(void (^)(BOOL)) ^{

	}];

}

#pragma mark KeyboardDelegate

- (void)keyWasTapped:(NSString *)key {

	NSString *searchString = self.searchHolder.searchBar.text;
	if (self.searchHolder.searchBar.isTextFieldSelected) {

		if ([key isEqualToString:@"⌫"]) {
			if (searchString.length > 0) {

				self.searchHolder.searchBar.text = [searchString substringToIndex:[searchString length] - 1];
			}
		}
		else if ([key isEqualToString:@"\n"]) {

			if ([searchString isEqualToString:@""]) {

			}
			else {
				[self.gifKeyboardView.searchManager fetchGIFSForSearchQuery:searchString];
				[self animateKeyboard:kTagGIFKeyboard];
			}
		}
		else {
			self.searchHolder.searchBar.text = [NSString stringWithFormat:@"%@%@", searchString, key];
		}
	}
	else {

		if ([key isEqualToString:@"⌫"]) {

			[self.textDocumentProxy deleteBackward];
		}

		else if ([key isEqualToString:@" "]) {

			[self.textDocumentProxy insertText:key];


			self.currentString = @"";
			[self.spellCheckerManager fetchWords:self.currentString];

		}
		else {

			[self.textDocumentProxy insertText:key];
			self.currentString = [NSString stringWithFormat:@"%@%@", self.currentString ? self.currentString : @"", key];

			[self.spellCheckerManager fetchWords:self.currentString];

//			[self checkText:self.currentString];
		}
	}

}

- (void)searchBarTapped {
	[self animateKeyboard:kTagABCKeyboard];
}

- (void)updateLayout {

	[self.view layoutIfNeeded];
	[self.view setNeedsDisplay];

}

- (void)cellWasTapped:(NSString *)gifURL WithMessageTitle:(NSString *)message {
	self.gifURL = gifURL;
	self.textDocumentProxy.hasText ?: [self.textDocumentProxy insertText:gifURL];
	if (message) {
		[self loadMessage:message];
	}
}
//
//- (void)primarySpell:(NSString *)primaryString {
//
//	NSLog(@"primary:%@", primaryString);
//	[self.autoCorrectCollectionView updateText:primaryString forSection:ksectionHeaderPrimary];
////	self.autoCorrectCollectionView.primaryString = primaryString;
//}
//
//- (void)secondarySpell:(NSString *)secondaryString {
//
//	NSLog(@"secondary:%@", secondaryString);
//	[self.autoCorrectCollectionView updateText:secondaryString forSection:ksectionHeaderSecondary];
//
////	self.autoCorrectCollectionView.secondaryString;
//}
//
//- (void)tertiarySpell:(NSString *)tertiaryString {
//
//	NSLog(@"tertiary:%@", tertiaryString);
//	[self.autoCorrectCollectionView updateText:tertiaryString forSection:ksectionHeaderTertiary];
//
////	self.autoCorrectCollectionView.tertiaryString;
//}

- (void)hideView:(BOOL)shouldHide {

	if (!shouldHide) {
		NSLog(@"show");
		self.searchHolder.hidden = YES;
		self.autoCorrectCollectionView.hidden = NO;
	}
	else {
		NSLog(@"hide");

		self.autoCorrectCollectionView.hidden = YES;
		self.searchHolder.hidden = NO;
	}

}


- (void)checkText:(NSString *)checkedText {

	UITextChecker *textChecker = [[UITextChecker alloc] init];
	NSLog(@"currentString:%@", self.currentString);
	NSArray *completions = [textChecker completionsForPartialWordRange:NSMakeRange(0, self.currentString.length) inString:self.currentString language:@"en"];

	NSLog(@"completions:%@ %@ %@", completions[0], completions[1], completions[2]);


}

#pragma  mark  Helpers

- (void)loadMessage:(NSString *)textMessage {
	UIView *view = [UIView new];
	view.backgroundColor = [UIColor blackColor];
	view.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:view];

	self.messageText = [UILabel new];
	[self.messageText setText:textMessage];
	[self.messageText setTextColor:[UIColor whiteColor]];
	self.messageText.translatesAutoresizingMaskIntoConstraints = NO;
	[view addSubview:self.messageText];


	NSDictionary *views = @{@"message" : self.messageText, @"view" : view};
	NSDictionary *metrics = @{@"padding" : @(10)};

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[view addConstraint:[NSLayoutConstraint constraintWithItem:self.messageText attribute:NSLayoutAttributeCenterY
													 relatedBy:NSLayoutRelationEqual
														toItem:view attribute:NSLayoutAttributeCenterY
													multiplier:1.0 constant:0]];
	[view addConstraint:[NSLayoutConstraint constraintWithItem:self.messageText attribute:NSLayoutAttributeCenterX
													 relatedBy:NSLayoutRelationEqual
														toItem:view attribute:NSLayoutAttributeCenterX
													multiplier:1.0 constant:0]];

	[UIView animateWithDuration:0.02f delay:1.5f options:0 animations:^{
		view.alpha = 0.0;


	}                completion:^(BOOL finished) {
		[view removeFromSuperview];

	}];
}


- (void)closeSubview:(NSNotification *)notification {
	self.userInfo = @{};
	self.userInfo = notification.userInfo;

	if ([self.userInfo[@"iconPressed"] isEqualToString:@"closed"]) {
		// do nothing
	}

	if ([self.userInfo[@"iconPressed"] isEqualToString:@"deleted"]) {

		[self loadMessage:self.userInfo[@"iconPressed"]];
		self.gifKeyboardView.type = MMSearchTypeAll;
		[self.gifKeyboardView loadGifs];

	}

	if ([self.userInfo[@"iconPressed"] isEqualToString:@"gif saved"]) {

		[self loadMessage:self.userInfo[@"iconPressed"]];
		self.gifKeyboardView.type = MMSearchTypeAll;
		[self.gifKeyboardView loadGifs];

	}
	else if (!([self.userInfo[@"iconPressed"] isEqualToString:@"closed"])) {

		[self loadMessage:self.userInfo[@"iconPressed"]];
		self.textDocumentProxy.hasText ? NSLog(@"Has text") : [self.textDocumentProxy insertText:self.gifURL];
	}

}


- (void)textDidChange:(id <UITextInput>)textInput {

	NSLog(@"TextInputMode: %d", self.textDocumentProxy.keyboardType);
	self.searchHolder.searchBar.isTextFieldSelected = NO;
}


@end