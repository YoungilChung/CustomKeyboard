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


typedef enum {
	kTagGIFKeyboard = 100,
	kTagABCKeyboard,

} buttonTags;


@interface KeyboardMainViewController () <UITextDocumentProxy>


// Views
@property(nonatomic, strong) MMAlphaKeyboardView *keyboardView;
@property(nonatomic, strong) SearchBarView *searchHolder;
@property(nonatomic, strong) UIView *gifKeyboardHolder;
@property(nonatomic, strong) MMKeyboardCollectionView *gifKeyboardView;

// Variables
@property(nonatomic, strong) UILabel *messageText;
@property(nonatomic, strong) NSDictionary *userInfo;
@property(nonatomic, strong) NSString *gifURL;

// Constraints
@property(nonatomic, strong) NSLayoutConstraint *keyboardLeftConstraint;
@property(nonatomic, strong) NSLayoutConstraint *gifKeyboardLeftConstrain;

@end

@implementation KeyboardMainViewController


- (void)viewDidLoad {
	[super viewDidLoad];

	self.keyboardView = [[MMAlphaKeyboardView alloc] init];
	[[MMAlphaKeyboardView alloc] inputAssistantItem];
	self.keyboardView.translatesAutoresizingMaskIntoConstraints = NO;
	self.keyboardView.keyboardDelegate = self;
	[self.keyboardView.nextKeyboardButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.keyboardView];

	self.searchHolder = [[SearchBarView alloc] init];
	self.searchHolder.translatesAutoresizingMaskIntoConstraints = NO;
//	[self.searchHolder setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
	self.searchHolder.clipsToBounds = YES;
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizeTapGesture:)];
	[self.searchHolder.searchBar addGestureRecognizer:tapGesture];
	[self.searchHolder.gifButton addTarget:self action:@selector(gifKeyboardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

	[self.view addSubview:self.searchHolder];

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

//	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[searchBar]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
//	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchHolder attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.keyboardView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchHolder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];


	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gifKeyboardHolder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
	[self.gifKeyboardHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[gifKeyboard]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self.gifKeyboardHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[gifKeyboard]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];


	self.searchHolder.gifButton.tag = kTagGIFKeyboard;

}

- (void)didRecognizeTapGesture:(UITapGestureRecognizer *)gesture {

}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeSubview:) name:@"closeSubview" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];


	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gifKeyboardHolder attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchHolder attribute:NSLayoutAttributeBottom multiplier:1.0 constant:2]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.keyboardView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchHolder attribute:NSLayoutAttributeBottom multiplier:1.0 constant:2]];;

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchHolder attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:2]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchHolder attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.self.keyboardView attribute:NSLayoutAttributeTop multiplier:1.0 constant:10]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchHolder attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.self.gifKeyboardHolder attribute:NSLayoutAttributeTop multiplier:1.0 constant:-40]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchHolder attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];

	CGRect Rect = [[UIScreen mainScreen] bounds];

	NSLayoutConstraint *_heightConstraint;
	_heightConstraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:(CGFloat) (Rect.size.height / 1.8)];
	[self.view addConstraint:_heightConstraint];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gifKeyboardHolder attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.keyboardView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
	self.keyboardLeftConstraint = [NSLayoutConstraint constraintWithItem:self.keyboardView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
	self.gifKeyboardLeftConstrain = [NSLayoutConstraint constraintWithItem:self.gifKeyboardHolder attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:self.view.frame.size.width];
	[self.view addConstraint:self.gifKeyboardLeftConstrain];
	[self.view addConstraint:self.keyboardLeftConstraint];
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

- (void)gifKeyboardButtonPressed:(buttonTags)tag {

	switch (self.searchHolder.gifButton.tag) {
		case kTagGIFKeyboard: {


			if ([self.searchHolder.searchBar.text isEqualToString:@""]) {
				if (self.gifKeyboardView.type == MMSearchTypeGiphy) {

					self.gifKeyboardView.type = MMSearchTypeAll;
					[self.gifKeyboardView loadGifs];

				}

			}

			self.keyboardLeftConstraint.constant = -self.view.frame.size.width;
			self.gifKeyboardLeftConstrain.constant = 0;

			self.searchHolder.gifButton.tag = kTagABCKeyboard;
			[self.searchHolder.gifButton setTitle:@"ABC" forState:UIControlStateNormal];
			[self.searchHolder animateButtonsOut:NO];
//			NSLog(@"GIF");

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
			self.gifKeyboardLeftConstrain.constant = self.view.frame.size.width;
			[self.gifKeyboardView.keyboardCollectionView setContentOffset:CGPointZero animated:YES];
			[self.searchHolder animateButtonsOut:YES];

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
				[self gifKeyboardButtonPressed:kTagABCKeyboard];
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
		else {

			[self.textDocumentProxy insertText:key];
		}
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