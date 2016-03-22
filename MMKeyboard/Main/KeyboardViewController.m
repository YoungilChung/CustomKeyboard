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
#import <MessageUI/MessageUI.h>
#import <MobileCoreServices/UTCoreTypes.h>


@interface KeyboardViewController () <UIViewControllerPreviewingDelegate, MFMessageComposeViewControllerDelegate, UITextDocumentProxy>

// Views
@property(nonatomic, strong) UIButton *nextKeyboardButton;
@property(nonatomic, strong) KeyboardButtonView *buttonView;
@property(nonatomic, strong) UILabel *messageText;
@property(nonatomic, strong) MMKeyboardCollectionView *keyboardCollectionView;

// Variables
@property(nonatomic, strong) NSDictionary *userInfo;
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


//	MMKeyboardCollectionView *keyboardCollectionView = [[MMKeyboardCollectionView alloc] initWithFrame:self.view.frame];
	self.keyboardCollectionView = [[MMKeyboardCollectionView alloc] initWithPresentingViewController:self];
	self.keyboardCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.keyboardCollectionView];

	self.menuHolder = [UIView new];
	self.menuHolder.translatesAutoresizingMaskIntoConstraints = NO;
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
	[self.nextKeyboardButton setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisVertical];
	[self.nextKeyboardButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
	[self.menuHolder addSubview:self.nextKeyboardButton];

	self.allGifsButton = [UIButton buttonWithType:UIButtonTypeSystem];
	self.allGifsButton.translatesAutoresizingMaskIntoConstraints = NO;
	[self.allGifsButton setTitle:NSLocalizedString(@"Category.All", nil) forState:UIControlStateNormal];
	[self.allGifsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.allGifsButton addTarget:self action:@selector(allGifsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.menuHolder addSubview:self.allGifsButton];

	self.normalButton = [UIButton buttonWithType:UIButtonTypeSystem];
	self.normalButton.translatesAutoresizingMaskIntoConstraints = NO;
	[self.normalButton setTitle:NSLocalizedString(@"Category.Normal", nil) forState:UIControlStateNormal];
	[self.normalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.normalButton addTarget:self action:@selector(normalButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.menuHolder addSubview:self.normalButton];

	self.awesomeButton = [UIButton buttonWithType:UIButtonTypeSystem];
	self.awesomeButton.translatesAutoresizingMaskIntoConstraints = NO;
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
	backspaceButton.translatesAutoresizingMaskIntoConstraints = NO;
	[backspaceButton setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisVertical];
	[backspaceButton addTarget:self action:@selector(didTapToDelete:) forControlEvents:UIControlEventTouchUpInside];
	[self.menuHolder addSubview:backspaceButton];

	NSDictionary *views = @{@"collection" : self.keyboardCollectionView, @"nxtKeyboardBtn" : self.nextKeyboardButton, @"keyboardImage" : keyboardImage,
			@"allBtn" : self.allGifsButton, @"shareBtnOne" : self.normalButton, @"shareBtnTwo" : self.awesomeButton, @"backspaceImage" : backspaceImage, @"backspaceButton" : backspaceButton,
			@"menuHolder" : self.menuHolder};
	NSDictionary *metrics = @{@"padding" : @(10)};

	[self.menuHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[shareBtnOne]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self.menuHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[shareBtnTwo]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self.menuHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[keyboardImage]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self.menuHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[allBtn]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self.menuHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[backspaceImage]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self.menuHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[keyboardImage(==backspaceImage)]-0-[allBtn(==shareBtnOne)]-0-[shareBtnOne(==allBtn)]-0-[shareBtnTwo(==allBtn)]-0-[backspaceImage(==50)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collection]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[menuHolder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collection]-0-[menuHolder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];


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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.keyboardCollectionView willRotateKeyboard:toInterfaceOrientation];
	[self.keyboardCollectionView setAlpha:0.0f];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[UIView animateWithDuration:0.125f animations:^{
		[self.keyboardCollectionView setAlpha:1.0f];
	}];
}

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
