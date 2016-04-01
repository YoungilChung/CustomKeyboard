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


@interface KeyboardMainViewController () <KeyboardDelegate, UITextDocumentProxy>


// Views
@property(nonatomic, strong) MMAlphaKeyboardView *keyboardView;
@property(nonatomic, strong) SearchBarView *searchHolder;
@property(nonatomic, strong) UIView *gifKeyboardHolder;
@property(nonatomic, strong) MMKeyboardCollectionView *gifKeyboardView;

// Variables

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
	[self.view addSubview:self.keyboardView];

	self.searchHolder = [SearchBarView new];
	self.searchHolder.translatesAutoresizingMaskIntoConstraints = NO;
	self.searchHolder.clipsToBounds = YES;
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizeTapGesture:)];
	[self.searchHolder.searchBar addGestureRecognizer:tapGesture];
	[self.view addSubview:self.searchHolder];
	[self.searchHolder.gifButton addTarget:self action:@selector(gifKeyboardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

	self.gifKeyboardHolder = [UIView new];
	self.gifKeyboardHolder.translatesAutoresizingMaskIntoConstraints = NO;
	self.gifKeyboardHolder.clipsToBounds = YES;
	[self.view addSubview:self.gifKeyboardHolder];

	self.gifKeyboardView = [[MMKeyboardCollectionView alloc] initWithPresentingViewController:nil];
	self.gifKeyboardView.translatesAutoresizingMaskIntoConstraints = NO;
	self.gifKeyboardView.clipsToBounds = YES;
	[self.gifKeyboardHolder addSubview:self.gifKeyboardView];

	NSDictionary *views = @{@"searchBar" : self.searchHolder, @"keyboardView" : self.keyboardView, @"gifKeyboard" : self.gifKeyboardView};
	NSDictionary *metrics = @{};

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[searchBar(==30)]-0-[keyboardView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
//	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[keyboardView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[searchBar]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.keyboardView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];


	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gifKeyboardHolder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
	[self.gifKeyboardHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[gifKeyboard]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self.gifKeyboardHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[gifKeyboard]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];


	self.searchHolder.gifButton.tag = kTagGIFKeyboard;

}


- (void)didRecognizeTapGesture:(UITapGestureRecognizer *)gesture {


}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];


	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gifKeyboardHolder attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchHolder attribute:NSLayoutAttributeBottom multiplier:1.0 constant:2]];
//	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gifKeyboardHolder attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.height - self.searchHolder.frame.size.height]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gifKeyboardHolder attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
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
	}
}


#pragma mark Actions

- (void)gifKeyboardButtonPressed:(MMkeyboardButton *)sender {

	switch (self.searchHolder.gifButton.tag) {
		case kTagGIFKeyboard: {

			self.keyboardLeftConstraint.constant = -self.view.frame.size.width;
			self.gifKeyboardLeftConstrain.constant = 0;

			self.searchHolder.gifButton.tag = kTagABCKeyboard;
			[self.searchHolder.gifButton setTitle:@"ABC" forState:UIControlStateNormal];
			NSLog(@"GIF");

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

			self.searchHolder.gifButton.tag = kTagGIFKeyboard;
			[self.searchHolder.gifButton setTitle:@"GIF" forState:UIControlStateNormal];
			NSLog(@"ABC");


			break;
		}

		default: {

			break;
		}
	}

	[UIView animateWithDuration:1 animations:^{

		[self.view layoutIfNeeded];
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

			[self.gifKeyboardView.searchManager fetchGIFSForSearchQuery:searchString];

		}

		else {
			NSLog(@"here");

			self.searchHolder.searchBar.text = [NSString stringWithFormat:@"%@%@", searchString, key];
		}

	}
	else {


		if ([key isEqualToString:@"⌫"]) {

			[self.textDocumentProxy deleteBackward];
		}

		else {
			NSLog(@"herekey");
			NSLog(@"%@", key);
			[self.textDocumentProxy insertText:key];
		}


	}

}

- (void)updateLayout {

	[self.view layoutIfNeeded];
	[self.view setNeedsDisplay];

}


#pragma mark TextDocumentProxy

- (void)textDidChange:(id <UITextInput>)textInput {

	NSLog(@"TextInputMode: %d", self.textDocumentProxy.keyboardType);
	self.searchHolder.searchBar.isTextFieldSelected = NO;
}

@end