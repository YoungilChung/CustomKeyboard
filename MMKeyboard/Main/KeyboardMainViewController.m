//
// Created by Tom Atterton on 31/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "KeyboardMainViewController.h"
#import "MMAlphaKeyboardView.h"
#import "SearchBarView.h"
#import "MMKeyboardButton.h"
#import "MMKeyboardCollectionView.h"
#import "SearchGIFManager.h"
#import "CategoryHolder.h"
#import "SpellCheckerManager.h"
#import "AutoCorrectCollectionView.h"
#import "MMCustomTextField.h"
#import "MMEmojiCollectionView.h"
#import "ButtonShape.h"


typedef enum {

	kTagGIFKeyboard = 100,
	kTagABCKeyboard,

} buttonTags;

#define CASE(str)          if ([__s__ isEqualToString:(str)])
#define SWITCH(s)          for (NSString *__s__ = (s); ; )
#define DEFAULT


@interface KeyboardMainViewController () <UITextDocumentProxy, SpellCheckerDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate>


// Views
@property(nonatomic, strong) MMAlphaKeyboardView *keyboardView;
@property(nonatomic, strong) SearchBarView *searchHolder;
@property(nonatomic, strong) CategoryHolder *categoryHolderView;
@property(nonatomic, strong) UIView *gifKeyboardHolder;
@property(nonatomic, strong) MMKeyboardCollectionView *gifKeyboardView;
@property(nonatomic, strong) AutoCorrectCollectionView *autoCorrectCollectionView;
@property(nonatomic, strong) SpellCheckerManager *spellCheckerManager;
@property(nonatomic, strong) UIView *emojiKeyboardHolder;
@property(nonatomic, strong) MMEmojiCollectionView *emojiCollectionView;
@property(nonatomic, strong) ButtonShape *buttonShape;
@property(nonatomic, strong) UIView *selectionHolder;

// Variables
@property(nonatomic, strong) UILabel *messageText;
@property(nonatomic, strong) NSDictionary *userInfo;
@property(nonatomic, strong) NSString *gifURL;
@property(nonatomic, strong) NSString *currentString;
@property(nonatomic, strong) NSString *primaryString;
@property(nonatomic, assign) BOOL selectionShowing;
@property(nonatomic, strong) NSMutableArray *lastKey;


// Constraints
@property(nonatomic, strong) NSLayoutConstraint *keyboardLeftConstraint;
@property(nonatomic, strong) NSLayoutConstraint *gifKeyboardLeftConstraint;
@property(nonatomic, strong) NSLayoutConstraint *categoryLeftConstraint;

@end

@implementation KeyboardMainViewController


- (void)viewDidLoad {
	[super viewDidLoad];

	self.selectionShowing = NO;


	self.spellCheckerManager = [SpellCheckerManager new];
	self.spellCheckerManager.delegate = self;
	[self.spellCheckerManager loadForSpellCorrection];
	[self.view setBackgroundColor:[UIColor grayColor]];


	self.emojiKeyboardHolder = [UIView new];
	self.emojiKeyboardHolder.translatesAutoresizingMaskIntoConstraints = NO;
	self.emojiKeyboardHolder.clipsToBounds = YES;
	[self.view addSubview:self.emojiKeyboardHolder];

	self.emojiCollectionView = [[MMEmojiCollectionView alloc] init];
	self.emojiCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
	self.emojiCollectionView.clipsToBounds = YES;
	self.emojiCollectionView.keyboardDelegate = self;
	[self.emojiKeyboardHolder addSubview:self.emojiCollectionView];


	self.autoCorrectCollectionView = [[AutoCorrectCollectionView alloc] init];
	self.autoCorrectCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
	self.autoCorrectCollectionView.delegate = self;
	[self.view addSubview:self.autoCorrectCollectionView];

	self.keyboardView = [[MMAlphaKeyboardView alloc] init];
	[[MMAlphaKeyboardView alloc] inputAssistantItem];
	self.keyboardView.translatesAutoresizingMaskIntoConstraints = NO;
	self.keyboardView.keyboardDelegate = self;
	[self.keyboardView.nextKeyboardButton addTarget:self action:@selector(emojiKeyboard:) forControlEvents:UIControlEventTouchUpInside];
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

	NSDictionary *views = @{@"searchBar" : self.searchHolder, @"keyboardView" : self.keyboardView, @"gifKeyboard" : self.gifKeyboardView, @"emojiKeyboard" : self.emojiCollectionView};
	NSDictionary *metrics = @{};

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchHolder attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.autoCorrectCollectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.autoCorrectCollectionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.autoCorrectCollectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.autoCorrectCollectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.keyboardView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[searchBar]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
//	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchHolder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.categoryHolderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];


	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gifKeyboardHolder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];

	[self.gifKeyboardHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[gifKeyboard]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self.gifKeyboardHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[gifKeyboard]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.emojiKeyboardHolder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
	[self.emojiKeyboardHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[emojiKeyboard]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self.emojiKeyboardHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[emojiKeyboard]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];


	self.searchHolder.gifButton.tag = kTagGIFKeyboard;

	UILongPressGestureRecognizer *ges = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
	ges.minimumPressDuration = 0.2;
	ges.numberOfTouchesRequired = 1;
	ges.delegate = self;
	[self.keyboardView.nextKeyboardButton addGestureRecognizer:ges];

	self.lastKey = @[].mutableCopy;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeSubview:) name:@"closeSubview" object:nil];


	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchHolder attribute:NSLayoutAttributeTop
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view attribute:NSLayoutAttributeTop
														 multiplier:1.0 constant:2]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchHolder attribute:NSLayoutAttributeBottom
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.keyboardView attribute:NSLayoutAttributeTop
														 multiplier:1.0 constant:-5]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.autoCorrectCollectionView attribute:NSLayoutAttributeTop
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view attribute:NSLayoutAttributeTop
														 multiplier:1.0 constant:2]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.autoCorrectCollectionView attribute:NSLayoutAttributeBottom
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.keyboardView attribute:NSLayoutAttributeTop
														 multiplier:1.0 constant:-5]];

	self.autoCorrectCollectionView.alpha = 0.0f;

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


	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchHolder attribute:NSLayoutAttributeBottom
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.emojiKeyboardHolder attribute:NSLayoutAttributeTop
														 multiplier:1.0 constant:-5]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.emojiKeyboardHolder attribute:NSLayoutAttributeBottom
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view attribute:NSLayoutAttributeBottom
														 multiplier:1.0 constant:0]];

	CGRect Rect = [[UIScreen mainScreen] bounds];
	NSLayoutConstraint *_heightConstraint;
	_heightConstraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:(CGFloat) (Rect.size.height / 2.0)];
	[self.view addConstraint:_heightConstraint];

	self.keyboardLeftConstraint = [NSLayoutConstraint constraintWithItem:self.keyboardView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
	self.gifKeyboardLeftConstraint = [NSLayoutConstraint constraintWithItem:self.gifKeyboardHolder attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:self.view.frame.size.width];
	self.categoryLeftConstraint = [NSLayoutConstraint constraintWithItem:self.categoryHolderView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:self.view.frame.size.width];

	self.emojiKeyboardHolder.alpha = 0;

	[self.view addConstraint:self.gifKeyboardLeftConstraint];
	[self.view addConstraint:self.keyboardLeftConstraint];
	[self.view addConstraint:self.categoryLeftConstraint];

	self.automaticallyAdjustsScrollViewInsets = NO;
}


- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];

	switch (self.searchHolder.gifButton.tag) {

		case kTagABCKeyboard: {
			if (self.selectionShowing) {
				self.selectionShowing = NO;
				[self.selectionHolder removeFromSuperview];
			}

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

		case kTagGIFKeyboard: {

			self.emojiCollectionView.emojiCollectionViewSize = CGSizeMake((CGFloat) (self.emojiCollectionView.layer.frame.size.width), (CGFloat) self.emojiCollectionView.mainCollectionView.frame.size.height);
			[self.emojiCollectionView.mainCollectionView.collectionViewLayout invalidateLayout];

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


#pragma mark touch gestures

- (void)longPress:(UILongPressGestureRecognizer *)gesture {
	if (!self.selectionShowing) {


		self.selectionHolder = [UIView new];
		self.selectionHolder.translatesAutoresizingMaskIntoConstraints = NO;
		[self.selectionHolder setBackgroundColor:[UIColor clearColor]];
		[self.view addSubview:self.selectionHolder];


		self.buttonShape = [ButtonShape new];
		self.buttonShape.buttonView = self.keyboardView.nextKeyboardButton.frame;
		self.buttonShape.translatesAutoresizingMaskIntoConstraints = NO;
		self.buttonShape.layer.cornerRadius = 4;
		[self.view addSubview:self.buttonShape];


		MMKeyboardSelection *tableView = [[MMKeyboardSelection alloc] init];
		tableView.translatesAutoresizingMaskIntoConstraints = NO;
		tableView.layer.cornerRadius = 4;
		tableView.keyboardDelegate = self;
		[tableView sizeToFit];
		[self.selectionHolder addSubview:tableView];

		NSDictionary *metrics = @{};
		NSDictionary *views = @{@"selectionHolder" : self.selectionHolder, @"table" : tableView};

		[self.selectionHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[table(==80)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[self.selectionHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
				@"H:|-0-[table]-0-|"                                                 options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];


		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.selectionHolder attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:
				self.keyboardView.nextKeyboardButton          attribute:NSLayoutAttributeTop multiplier:1.0 constant:-10]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.selectionHolder attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.selectionHolder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:(CGFloat) (self.view.frame.size.width / 1.5)]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.selectionHolder attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.keyboardView.nextKeyboardButton attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];

		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonShape attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.keyboardView.nextKeyboardButton attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonShape attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.keyboardView.nextKeyboardButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonShape attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.selectionHolder attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-2.2]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonShape attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.keyboardView.nextKeyboardButton attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];

		self.selectionShowing = YES;
		self.buttonShape.buttonView = self.selectionHolder.frame;
	}

}


#pragma mark Actions


- (void)animateKeyboard:(buttonTags)tag {


	switch (tag) {
		case kTagGIFKeyboard: {


			if ([self.searchHolder.searchBar.text isEqualToString:@""]) {
				if (self.gifKeyboardView.type == MMSearchTypeGiphy) {

					self.gifKeyboardView.type = MMSearchTypeAll;
					[self.gifKeyboardView loadGIFS];

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


#pragma mark GifKeyboard Actions

- (void)allButtonTapped:(UIButton *)sender {
	self.gifKeyboardView.type = MMSearchTypeAll;
	[self.gifKeyboardView loadGIFS];

}

- (void)normalButtonTapped:(UIButton *)sender {
	self.gifKeyboardView.type = MMSearchTypeNormal;
	[self.gifKeyboardView loadGIFS];

}

- (void)awesomeButtonTapped:(UIButton *)sender {

	self.gifKeyboardView.type = MMSearchTypeAwesome;
	[self.gifKeyboardView loadGIFS];
}

- (void)deleteButtonTapped:(UIButton *)sender {
	[self.textDocumentProxy deleteBackward];

}


#pragma mark KeyboardDelegate

- (void)keyWasTapped:(NSString *)key {

	if (self.selectionShowing) {
		self.selectionShowing = NO;
		[self.selectionHolder removeFromSuperview];

	}


	if (self.searchHolder.searchBar.isTextFieldSelected) {

		[self searchBarText:self.searchHolder.searchBar.text tappedKey:key];
	}

	else {
		SWITCH(key) {

			CASE(@"⌫") {

				NSArray *tokens = [self.textDocumentProxy.documentContextBeforeInput componentsSeparatedByString:@" "];

				if ([tokens.lastObject length] <= 0) {

					[self.textDocumentProxy deleteBackward];
				}

				else {

					[self.textDocumentProxy deleteBackward];

					if (self.currentString.length > 0) {

						self.currentString = self.currentString.length <= 0 ? @"" : [self.currentString substringToIndex:[self.currentString length] - 1];
					}
					else {
						self.currentString = tokens.lastObject;
						self.currentString = self.currentString.length <= 0 ? @"" : [self.currentString substringToIndex:[self.currentString length] - 1];
						NSLog(@"token %@", self.currentString);

					}

					[self.spellCheckerManager fetchWords:self.currentString];
				}

				break;
			}

			CASE(@"\n")
			{
				[self.textDocumentProxy insertText:key];
				self.currentString = @"";
				[self.spellCheckerManager fetchWords:self.currentString];


				break;
			}

			CASE(@" ") {

				[self replaceWord:self.primaryString];
				break;
			}

			DEFAULT
			{

				[self.textDocumentProxy insertText:key];

				if (key.length == 1) {
					if (self.currentString.length <= 8) {

						self.currentString = [NSString stringWithFormat:@"%@%@", self.currentString ? self.currentString : @"", key];
						[self.spellCheckerManager fetchWords:self.currentString];

					}


				}
				break;
			}

		}
	}

}


- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
	NSDictionary *attributes = @{NSFontAttributeName : font};
	return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

- (void)searchBarText:(NSString *)searchString tappedKey:(NSString *)key {

	SWITCH(key) {

		CASE(@"⌫") {

			if (searchString.length > 0) {
				if (self.lastKey.count > 0) {

					self.searchHolder.leftCaretConstraint.constant -= [self widthOfString:[self.lastKey lastObject] withFont:[UIFont fontWithName:@"Helvetica" size:16]];
					self.searchHolder.searchBar.text = [searchString substringToIndex:[searchString length] - 1];
					[self.lastKey removeLastObject];
				}
			}

			break;
		}

		CASE(@"\n") {

			if (![searchString isEqualToString:@""]) {

				[self.gifKeyboardView.searchManager fetchGIFSForSearchQuery:searchString];
				[self animateKeyboard:kTagGIFKeyboard];
			}

			break;
		}
		CASE(@"Search")
		{
			if (![searchString isEqualToString:@""]) {

				[self.gifKeyboardView.searchManager fetchGIFSForSearchQuery:searchString];
				[self animateKeyboard:kTagGIFKeyboard];
			}
break;
		}

		DEFAULT
		{
			self.searchHolder.leftCaretConstraint.constant += [self widthOfString:key withFont:[UIFont fontWithName:@"Helvetica" size:16]];
			[self.lastKey addObject:key];
			self.searchHolder.searchBar.text = [NSString stringWithFormat:@"%@%@", searchString, key];

			break;
		}

	}

}

- (void)searchBarTapped {

	self.searchHolder.leftCaretConstraint.constant = 24;
	[self.keyboardView.returnButton setTitle:@"Search" forState:UIControlStateNormal];
	[self animateKeyboard:kTagABCKeyboard];
	self.searchHolder.gifButton.alpha = 1;
	self.emojiKeyboardHolder.alpha = 0;
	[self.view sendSubviewToBack:self.emojiKeyboardHolder];

	if (self.selectionShowing) {
		self.selectionShowing = NO;
		[self.selectionHolder removeFromSuperview];
	}


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

- (void)keyboardButtonPressed {

	self.searchHolder.gifButton.alpha = 1;
	self.emojiKeyboardHolder.alpha = 0;
	[self.view sendSubviewToBack:self.emojiKeyboardHolder];
}


- (void)changeKeyboard:(keyboardTags)tag {

	switch (tag) {

		case kTagSwitchKeyboard: {

			[self advanceToNextInputMode];

			break;
		}
		case kTagEmojiKeyboard: {

			self.selectionShowing = NO;
			self.searchHolder.gifButton.alpha = 0;
			self.emojiKeyboardHolder.alpha = 1;
			[self.selectionHolder removeFromSuperview];
			[self.view bringSubviewToFront:self.emojiKeyboardHolder];

			break;
		}
	}
}


- (void)emojiKeyboard:(UIButton *)sender {

	if (!self.selectionShowing) {

		self.searchHolder.gifButton.alpha = 0;
		self.emojiKeyboardHolder.alpha = 1;
		[self.view bringSubviewToFront:self.emojiKeyboardHolder];

	}
	else {
		[self.selectionHolder removeFromSuperview];
		self.selectionShowing = NO;
	}


}


#pragma mark SpellChecker Delegate

- (void)primarySpell:(NSString *)primaryString {
	dispatch_async(dispatch_get_main_queue(), ^{
		self.primaryString = primaryString;
		[self.autoCorrectCollectionView updateText:primaryString forSection:ksectionHeaderPrimary];
	});

}

- (void)secondarySpell:(NSString *)secondaryString {
	dispatch_async(dispatch_get_main_queue(), ^{

		[self.autoCorrectCollectionView updateText:secondaryString forSection:ksectionHeaderSecondary];
	});

}

- (void)tertiarySpell:(NSString *)tertiaryString {
	dispatch_async(dispatch_get_main_queue(), ^{

		[self.autoCorrectCollectionView updateText:tertiaryString forSection:ksectionHeaderTertiary];
	});

}


- (void)tappedWord:(NSString *)tappedWord {

	[self replaceWord:tappedWord];
}

- (void)hideView:(BOOL)shouldHide {

	if (!shouldHide) {
		dispatch_async(dispatch_get_main_queue(), ^{

			[UIView animateWithDuration:0.3 animations:^{

				self.searchHolder.alpha = 0.0f;
				self.autoCorrectCollectionView.alpha = 1.0f;

			}];
		});
	}
	else {

		dispatch_async(dispatch_get_main_queue(), ^{
			[UIView animateWithDuration:0.3 animations:^{

				self.autoCorrectCollectionView.alpha = 0.0f;
				self.searchHolder.alpha = 1.0f;
			}];

		});
	}

}


#pragma mark TextControl


- (void)replaceWord:(NSString *)replacedWord {
	NSArray *tokens = [self.textDocumentProxy.documentContextBeforeInput componentsSeparatedByString:@" "];

	NSLog(@"%@", replacedWord);
	replacedWord = [NSString stringWithFormat:@"%@ ", [replacedWord stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
	if (replacedWord.length > 1) {
		if ([tokens.lastObject length] > 0) {
			for (int i = 0; i < [[tokens lastObject] length]; i++) {
				[self.textDocumentProxy deleteBackward];
			}
//			[self.textDocumentProxy insertText:[NSString stringWithFormat:@"%@ ", [replacedWord stringByReplacingOccurrencesOfString:@"\"" withString:@""]]];
			[self.textDocumentProxy insertText:replacedWord];
			self.primaryString = @"";
			self.currentString = @"";
			[self.spellCheckerManager fetchWords:self.currentString];
		}
		else {
			[self.textDocumentProxy insertText:@" "];

		}
	}
	else {
		[self.textDocumentProxy insertText:@" "];

	}


}

#pragma  mark  ViewControl

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
		[self.gifKeyboardView loadGIFS];

	}

	if ([self.userInfo[@"iconPressed"] isEqualToString:@"gif saved"]) {

		[self loadMessage:self.userInfo[@"iconPressed"]];

		self.gifKeyboardView.type = MMSearchTypeAll;
		[self.gifKeyboardView loadGIFS];

	}
	else if (!([self.userInfo[@"iconPressed"] isEqualToString:@"closed"])) {

		[self loadMessage:self.userInfo[@"iconPressed"]];
		self.textDocumentProxy.hasText ? NSLog(@"Has text") : [self.textDocumentProxy insertText:self.gifURL];
	}

}


- (void)changeKeyboardButtonPressed:(MMKeyboardButton *)sender {

	[self animateKeyboard:(buttonTags) sender.tag];

}

#pragma mark TextDocumentProxy

- (NSString *)documentContextBeforeInput {

	return nil;
}

- (void)textDidChange:(id <UITextInput>)textInput {

	self.searchHolder.searchBar.isTextFieldSelected = NO;
	[self.keyboardView.returnButton setTitle:@"⏎" forState:UIControlStateNormal];
	self.lastKey = @[].mutableCopy;
	self.searchHolder.shouldContinueBlinking = NO;
}


@end