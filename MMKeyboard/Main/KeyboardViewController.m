//  KeyboardViewController.m
//  MMKeyboard
//
//  Created by mm0030240 on 06/10/15.
//  Copyright © 2015 mm0030240. All rights reserved.
//

#import "KeyboardViewController.h"
#import "GIFEntity.h"
#import "KeyboardButtonView.h"
#import "MMKeyboardCollectionView.h"
#import "UIImage+emoji.h"
#import "MMAlphaKeyboardView.h"
#import <MessageUI/MessageUI.h>
#import <MobileCoreServices/UTCoreTypes.h>

typedef enum {
	kTagGIFKeyboard = 100,
	kTagABCKeyboard,
} buttonTags;

@interface KeyboardViewController () <UIViewControllerPreviewingDelegate, UITextDocumentProxy>

// Views
@property(nonatomic, strong) UIButton *nextKeyboardButton;
@property(nonatomic, strong) KeyboardButtonView *buttonView;
@property(nonatomic, strong) UILabel *messageText;
@property(nonatomic, strong) MMKeyboardCollectionView *keyboardCollectionView;

// Variables
@property(nonatomic, strong) NSDictionary *userInfo;
@property(nonatomic, assign) BOOL isABCKeyboard;

// Constraints
@property(nonatomic, strong) NSLayoutConstraint *menuLeftConstraint;
@property(nonatomic, strong) NSLayoutConstraint *collectionLeftConstraint;

@end

@implementation KeyboardViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeSubview:) name:@"closeSubview" object:nil];


}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"closeSubview" object:nil];
	self.userInfo = @{};
	[self.keyboardCollectionView removeFromSuperview];
	[self.buttonView removeFromSuperview];


}


- (void)viewDidLoad {
	[super viewDidLoad];

	self.view.clipsToBounds = YES;
	self.view.backgroundColor = [UIColor blackColor];

	self.isABCKeyboard = NO;


	self.customKeyboardHolder = [UIView new];
	self.customKeyboardHolder.translatesAutoresizingMaskIntoConstraints = NO;
	self.customKeyboardHolder.clipsToBounds = YES;
	[self.view addSubview:self.customKeyboardHolder];


	self.customKeyboard = [[MMAlphaKeyboardView alloc] init];
	self.customKeyboard.translatesAutoresizingMaskIntoConstraints = NO;
	self.customKeyboard.clipsToBounds = YES;
	[self.customKeyboardHolder addSubview:self.customKeyboard];
	[self addChildViewController:self.customKeyboard];

//	customKeyboard.view.translatesAutoresizingMaskIntoConstraints  = NO;
//	customKeyboard.view.clipsToBounds = YES;

//	[self.view addSubview:customKeyboard.view];

//	MMKeyboardCollectionView *gifKeyboardView = [[MMKeyboardCollectionView alloc] initWithFrame:self.view.frame];

	self.searchHolder = [UIView new];
	self.searchHolder.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.searchHolder];

	UITextField *searchBar = [[UITextField alloc] init];
	searchBar.translatesAutoresizingMaskIntoConstraints = NO;
	searchBar.backgroundColor = [UIColor whiteColor];
	searchBar.layer.cornerRadius = 10;
	searchBar.clipsToBounds = YES;
	[self.searchHolder addSubview:searchBar];

	UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
	searchButton.translatesAutoresizingMaskIntoConstraints = NO;
	[searchButton setTitle:@"search" forState:UIControlStateNormal];
	[self.searchHolder addSubview:searchButton];

	self.abcButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.abcButton.translatesAutoresizingMaskIntoConstraints = NO;
	[self.abcButton setTitle:@"ABC" forState:UIControlStateNormal];
	[self.abcButton addTarget:self action:@selector(abcButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.searchHolder addSubview:self.abcButton];


	self.keyboardCollectionView = [[MMKeyboardCollectionView alloc] initWithPresentingViewController:self];
	self.keyboardCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
	self.keyboardCollectionView.clipsToBounds = YES;
	[self.view addSubview:self.keyboardCollectionView];


	self.menuHolder = [UIView new];
	self.menuHolder.translatesAutoresizingMaskIntoConstraints = NO;
	self.menuHolder.clipsToBounds = YES;
	[self.view addSubview:self.menuHolder];


	UIImageView *keyboardImage = [UIImageView new];
	keyboardImage.translatesAutoresizingMaskIntoConstraints = NO;
	UIImage *image = [UIImage imageNamed:@"NextKeyboardIcon"];
	keyboardImage.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[keyboardImage setTintColor:[UIColor whiteColor]];
	[keyboardImage setContentMode:UIViewContentModeScaleAspectFit];
	[keyboardImage setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisVertical];
	[keyboardImage setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisHorizontal];
	[self.menuHolder addSubview:keyboardImage];

	self.nextKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.nextKeyboardButton.clipsToBounds = YES;
	[self.nextKeyboardButton setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisVertical];
	[self.nextKeyboardButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
	[self.menuHolder addSubview:self.nextKeyboardButton];

	self.allGifsButton = [UIButton buttonWithType:UIButtonTypeSystem];
	self.allGifsButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.allGifsButton.clipsToBounds = YES;
	[self.allGifsButton setTitle:NSLocalizedString(@"Category.All", nil) forState:UIControlStateNormal];
	[self.allGifsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.allGifsButton addTarget:self action:@selector(allGifsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.menuHolder addSubview:self.allGifsButton];

	self.normalButton = [UIButton buttonWithType:UIButtonTypeSystem];
	self.normalButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.normalButton.clipsToBounds = YES;
	[self.normalButton setTitle:NSLocalizedString(@"Category.Normal", nil) forState:UIControlStateNormal];
	[self.normalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.normalButton addTarget:self action:@selector(normalButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.menuHolder addSubview:self.normalButton];

	self.awesomeButton = [UIButton buttonWithType:UIButtonTypeSystem];
	self.awesomeButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.awesomeButton.clipsToBounds = YES;
	[self.awesomeButton setTitle:NSLocalizedString(@"Category.Awesome", nil) forState:UIControlStateNormal];
	[self.awesomeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.awesomeButton addTarget:self action:@selector(awesomeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.menuHolder addSubview:self.awesomeButton];


	UIImageView *backspaceImage = [UIImageView new];
	UIImage *backImage = [UIImage imageNamed:@"backspaceIcon.png"];
	backspaceImage.image = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[backspaceImage setTintColor:[UIColor whiteColor]];
	backspaceImage.translatesAutoresizingMaskIntoConstraints = NO;
	[backspaceImage setContentMode:UIViewContentModeScaleAspectFit];
	[backspaceImage setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisVertical];
	[backspaceImage setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisHorizontal];
	backspaceImage.clipsToBounds = YES;
	[self.menuHolder addSubview:backspaceImage];

	UIButton *backspaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
	backspaceButton.clipsToBounds = YES;
	backspaceButton.translatesAutoresizingMaskIntoConstraints = NO;
	[backspaceButton setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisVertical];
	[backspaceButton addTarget:self action:@selector(didTapToDelete:) forControlEvents:UIControlEventTouchUpInside];
	[self.menuHolder addSubview:backspaceButton];

	NSDictionary *views = @{@"collection" : self.keyboardCollectionView, @"nxtKeyboardBtn" : self.nextKeyboardButton, @"keyboardImage" : keyboardImage,
			@"allBtn" : self.allGifsButton, @"shareBtnOne" : self.normalButton, @"shareBtnTwo" : self.awesomeButton, @"backspaceImage" : backspaceImage, @"backspaceButton" : backspaceButton,
			@"menuHolder" : self.menuHolder, @"searchHolder" : self.searchHolder, @"searchBar" : searchBar, @"searchButton" : searchButton, @"abcButton" : self.abcButton, @"holder" : self.customKeyboardHolder, @"customKeyboard" : self.customKeyboard};
	NSDictionary *metrics = @{@"padding" : @(10)};


	[self.searchHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[searchBar]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.searchHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[searchButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.searchHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[abcButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.searchHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[searchBar]-10-[searchButton]-5-[abcButton]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	[self.menuHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[shareBtnOne]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self.menuHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[shareBtnTwo]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self.menuHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[keyboardImage]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self.menuHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[allBtn]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self.menuHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[backspaceImage]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self.menuHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[keyboardImage(==backspaceImage)]-0-[allBtn(==shareBtnOne)]-0-[shareBtnOne(==allBtn)]-0-[shareBtnTwo(==allBtn)]-0-[backspaceImage(==50)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collection]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[menuHolder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[searchHolder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[searchHolder]-0-[collection]-0-[menuHolder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
//	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[holder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];


//	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[searchHolder]-0-[holder]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];


	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.customKeyboardHolder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
	[self.customKeyboardHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[customKeyboard]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.customKeyboardHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[customKeyboard]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	self.customeKeyboardLeftConstraint = [NSLayoutConstraint constraintWithItem:self.customKeyboardHolder attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-500];
	self.menuLeftConstraint = [NSLayoutConstraint constraintWithItem:self.menuHolder attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
	self.collectionLeftConstraint = [NSLayoutConstraint constraintWithItem:self.keyboardCollectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];

//	[self.view addConstraints:@[self.menuLeftConstraint, self.keyboardLeftConstraint, self.customeKeyboardLeftConstraint]];
	[self.view addConstraint:self.customeKeyboardLeftConstraint];
	[self.view addConstraint:self.menuLeftConstraint];
	[self.view addConstraint:self.collectionLeftConstraint];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nextKeyboardButton attribute:NSLayoutAttributeCenterY
														  relatedBy:NSLayoutRelationEqual
															 toItem:keyboardImage
														  attribute:NSLayoutAttributeCenterY
														 multiplier:1.0 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nextKeyboardButton attribute:NSLayoutAttributeCenterX
														  relatedBy:NSLayoutRelationEqual
															 toItem:keyboardImage
														  attribute:NSLayoutAttributeCenterX
														 multiplier:1.0 constant:0]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:backspaceButton attribute:NSLayoutAttributeCenterY
														  relatedBy:NSLayoutRelationEqual
															 toItem:backspaceImage
														  attribute:NSLayoutAttributeCenterY
														 multiplier:1.0 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:backspaceButton attribute:NSLayoutAttributeCenterX
														  relatedBy:NSLayoutRelationEqual
															 toItem:backspaceImage
														  attribute:NSLayoutAttributeCenterX
														 multiplier:1.0 constant:0]];

	self.abcButton.tag = kTagGIFKeyboard;

}

- (void)abcButtonPressed:(UIButton *)sender {




//	NSDictionary *metrics = @{};
//	NSDictionary *views = @{@"customKeyboard" : self.customKeyboard.view, @"searchHolder" : self.searchHolder, @"menuHolder" : self.menuHolder,
//			@"holder": self.gifKeyboardHolder
//	};



//	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchHolder attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];

	switch (self.abcButton.tag) {
		case kTagGIFKeyboard: {
			self.menuLeftConstraint.constant = self.view.frame.size.width;
			self.collectionLeftConstraint.constant = self.view.frame.size.width;
			self.customeKeyboardLeftConstraint.constant = 0;

			self.abcButton.tag = kTagABCKeyboard;
			[self.abcButton setTitle:@"GIF" forState:UIControlStateNormal];


			break;
		}
		case kTagABCKeyboard: {
			self.menuLeftConstraint.constant = 0;
			self.collectionLeftConstraint.constant = 0;
			self.customeKeyboardLeftConstraint.constant = -self.view.frame.size.width;
			self.abcButton.tag = kTagGIFKeyboard;
			[self.abcButton setTitle:@"ABC" forState:UIControlStateNormal];

			break;
		}

		default: {

			break;
		}
	}


	[UIView animateWithDuration:1 animations:^{

		[self.view layoutIfNeeded];

	}                completion:(void (^)(BOOL)) ^{
//		[self.gifKeyboardView removeFromSuperview];

	}];

}

- (void)awesomeButtonPressed:(UIButton *)sender {
	[self.keyboardCollectionView onAwesomeButtonTapped:sender];
}

- (void)normalButtonPressed:(UIButton *)sender {
	[self.keyboardCollectionView onNormalButtonTapped:sender];
}

- (void)allGifsButtonPressed:(UIButton *)sender {

	[self.keyboardCollectionView onAllGifsButtonTapped:sender];
}

- (void)didTapToDelete:(UIButton *)sender {
	for (int i = self.textDocumentProxy.documentContextBeforeInput.length; i > 0; i--) {
		[self.textDocumentProxy deleteBackward];
	}
}


- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.customKeyboardHolder attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.height - self.searchHolder.frame.size.height]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchHolder attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.customKeyboardHolder attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
	if (UIDeviceOrientationIsPortrait((UIDeviceOrientation) self.interfaceOrientation)) {
		//DO Portrait
		self.keyboardCollectionView.keyboardCollectionViewSize = CGSizeMake((CGFloat) (self.keyboardCollectionView.layer.frame.size.width / 2), (CGFloat) (self.keyboardCollectionView.layer.frame.size.height / 2.015));
	}
	else {
		//DO Landscape
		self.keyboardCollectionView.keyboardCollectionViewSize = CGSizeMake((CGFloat) (self.keyboardCollectionView.layer.frame.size.width / 4.015), self.keyboardCollectionView.layer.frame.size.height);
	}
	[self.keyboardCollectionView.keyboardCollectionView.collectionViewLayout invalidateLayout];
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated
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
	NSLog(@"%@", self.gifURL);

	if ([self.userInfo[@"iconPressed"] isEqualToString:@"closed"]) {
		// do nothing
		NSLog(@"Closed");
	}

	if ([self.userInfo[@"iconPressed"] isEqualToString:@"deleted"]) {

		[self loadMessage:self.userInfo[@"iconPressed"]];
		[self.keyboardCollectionView loadGifs];

	}
	else if (!([self.userInfo[@"iconPressed"] isEqualToString:@"closed"])) {

		[self loadMessage:self.userInfo[@"iconPressed"]];
		self.textDocumentProxy.hasText ? NSLog(@"Has text") : [self.textDocumentProxy insertText:self.gifURL];
	}

	[self.menuHolder setHidden:NO];
	[self.buttonView removeFromSuperview];
}

#pragma mark rotation TODO

//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
////	[self.gifKeyboardView willRotateKeyboard:toInterfaceOrientation];
////	[self.gifKeyboardView setAlpha:0.0f];
//	NSLog(@"came here");
//	if (UIDeviceOrientationIsPortrait((UIDeviceOrientation) self.interfaceOrientation)) {
//		//DO Portrait
//		NSLog(@"came here portrait");
//		self.gifKeyboardView.keyboardCollectionViewSize = CGSizeMake((CGFloat) (self.gifKeyboardView.layer.frame.size.width / 2.015), (CGFloat) (self.gifKeyboardView.layer.frame.size.height / 2.015));
//	}
//	else {
//		//DO Landscape
//		NSLog(@"came here laandsaccapape");
//		self.gifKeyboardView.keyboardCollectionViewSize = CGSizeMake((CGFloat) (self.gifKeyboardView.layer.frame.size.width / 4.015), self.gifKeyboardView.layer.frame.size.height);
//	}
//}

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//	[UIView animateWithDuration:0.125f animations:^{
//
//		[self.gifKeyboardView setAlpha:1.0f];
//		[self.gifKeyboardView.gifKeyboardView.collectionViewLayout invalidateLayout];
//	}];
//}




- (void)tappedGIF {

	if ([self.textDocumentProxy hasText]) {


		for (int i = self.textDocumentProxy.documentContextBeforeInput.length; i > 0; i--) {
			[self.textDocumentProxy deleteBackward];
		}
		[self loadMessage:@"URL Copied!"];
		[self.textDocumentProxy insertText:self.keyboardCollectionView.gifURL];
	}
	else {

		[self.textDocumentProxy insertText:self.keyboardCollectionView.gifURL];
		[self loadMessage:@"URL Copied!"];

	}
}


@end
