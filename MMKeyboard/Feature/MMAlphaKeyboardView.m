//
// Created by Tom Atterton on 23/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMAlphaKeyboardView.h"
#import "MMKeyboardButton.h"

typedef enum {
	Delete,
	Return,
	Space,
	CHG,

} ButtonString;

@interface MMAlphaKeyboardView () <UITextDocumentProxy, UIGestureRecognizerDelegate>


// Views
@property(nonatomic, strong) UIView *rowView1;
@property(nonatomic, strong) UIView *rowView2;
@property(nonatomic, strong) UIView *rowView3;
@property(nonatomic, strong) UIView *rowView4;

// Variables
@property(nonatomic, strong) NSArray *buttonTiles1;
@property(nonatomic, strong) NSArray *buttonTiles2;
@property(nonatomic, strong) NSArray *buttonTiles3;
@property(nonatomic, strong) NSArray *buttonTiles4;
@property(nonatomic, strong) NSMutableArray<MMkeyboardButton *> *buttons;

@property(nonatomic, assign) CGRect keyboardFrame;
@end


@implementation MMAlphaKeyboardView

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super init];
	if (self) {

		self.keyboardFrame = frame;
		self.buttonTiles1 = @[@"Q", @"W", @"E", @"R", @"T", @"Y", @"U", @"I", @"O", @"P"];
		self.buttonTiles2 = @[@"A", @"S", @"D", @"F", @"G", @"H", @"J", @"K", @"L"];
		self.buttonTiles3 = @[@"CP", @"Z", @"X", @"C", @"V", @"B", @"N", @"M", @"BP"];
		self.buttonTiles4 = @[@"CHG", @"SPACE", @"RETURN"];
		[self setup];
	}

	return self;
}


- (void)setup {


	self.rowView1 = [self createRowOfButtonWithTitle:self.buttonTiles1];
	self.rowView2 = [self createRowOfButtonWithTitle:self.buttonTiles2];
	self.rowView3 = [self createRowOfButtonWithTitle:self.buttonTiles3];
	self.rowView4 = [self createRowOfButtonWithTitle:self.buttonTiles4];

	[self.view addSubview:self.rowView1];
	[self.view addSubview:self.rowView2];
	[self.view addSubview:self.rowView3];
	[self.view addSubview:self.rowView4];


	self.rowView1.translatesAutoresizingMaskIntoConstraints = NO;
	self.rowView2.translatesAutoresizingMaskIntoConstraints = NO;
	self.rowView3.translatesAutoresizingMaskIntoConstraints = NO;
	self.rowView4.translatesAutoresizingMaskIntoConstraints = NO;

//	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
//	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
	[tapGestureRecognizer setCancelsTouchesInView:NO];// This should do what you want [tapGesture setDelegate:self];
	tapGestureRecognizer.delegate = self;
//	tapGestureRecognizer.delaysTouchesBegan = YES;
	[self.view addGestureRecognizer:tapGestureRecognizer];
	NSLog(@"%d", self.view.userInteractionEnabled);
	self.view.userInteractionEnabled = YES;
	[self addConstraintsToInputViews:self.view WithRowViews:@[self.rowView1, self.rowView2, self.rowView3, self.rowView4]];

}

#pragma mark Touch Gestures

- (void)tapRecognized:(UITapGestureRecognizer *)sender {
NSLog(@"%@tapped here", sender);
}

- (UIView *)createRowOfButtonWithTitle:(NSArray *)titles {

	self.buttons = @[].mutableCopy;
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
	for (NSString *string in titles) {
		MMkeyboardButton *button = [self createButtonWithTitle:string];
		[self.buttons addObject:button];
		[view addSubview:button];
	}
	[self addIndividualButtonConstraints:self.buttons WithMainView:view];
	return view;
}

- (MMkeyboardButton *)createButtonWithTitle:(NSString *)title {

	MMkeyboardButton *button = [MMkeyboardButton buttonWithType:UIButtonTypeSystem];
	button.translatesAutoresizingMaskIntoConstraints = NO;
	[button setTitle:title forState:UIControlStateNormal];
	[button setFrame:CGRectMake(0, 0, 20, 20)];
	[button sizeToFit];
	button.titleLabel.textColor = [UIColor whiteColor];
	button.backgroundColor = [UIColor blackColor];
	[button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];

	return button;

}


- (void)didTapButton:(MMkeyboardButton *)sender {
//
	MMkeyboardButton *button = sender;
	NSString *title = [button titleForState:UIControlStateNormal];

	NSLog(@"bp%@", title);

//	if ([title isEqualToString:@"BP"]) {
//		[self.textDocumentProxy deleteBackward];
//		NSLog(@"bp%@", title);
//	}
//	else if ([title isEqualToString:@"RETURN"]) {
//		[self.textDocumentProxy insertText:@"\n"];
//		NSLog(@"return%@", title);
//	}
//	else if ([title isEqualToString:@"SPACE"]) {
//		[self.textDocumentProxy insertText:@" "];
//		NSLog(@"space%@", title);
//	}
//	else if ([title isEqualToString:@"CHG"]) {
//		[self advanceToNextInputMode];
//		NSLog(@"chg%@", title);
//	}
//	else {
//		[self.textDocumentProxy insertText:title];
//		NSLog(@"title%@", title);
//	}
}

#pragma mark Actions


#pragma mark layout methods

- (void)addIndividualButtonConstraints:(NSArray *)buttons WithMainView:(UIView *)mainView {

	[buttons enumerateObjectsUsingBlock:^(MMkeyboardButton *button, NSUInteger idx, BOOL *stop) {

		NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop
																		 relatedBy:NSLayoutRelationEqual
																			toItem:mainView attribute:NSLayoutAttributeTop
																		multiplier:1.0 constant:1];

		NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom
																			relatedBy:NSLayoutRelationEqual
																			   toItem:mainView attribute:NSLayoutAttributeBottom
																		   multiplier:1.0 constant:-1];

		NSLayoutConstraint *rightConstraint;

		if (idx == buttons.count - 1) {
			rightConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight
														   relatedBy:NSLayoutRelationEqual
															  toItem:mainView attribute:NSLayoutAttributeRight
														  multiplier:1.0 constant:-1];

		}

		else {
			MMkeyboardButton *nextButton = buttons[idx + 1];
			rightConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight
														   relatedBy:NSLayoutRelationEqual
															  toItem:nextButton attribute:NSLayoutAttributeLeft
														  multiplier:1.0 constant:-1];


		}

		NSLayoutConstraint *leftConstraint;

		if (idx == 0) {
			leftConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft
														  relatedBy:NSLayoutRelationEqual
															 toItem:mainView attribute:NSLayoutAttributeLeft
														 multiplier:1.0 constant:1];

		}

		else {
			MMkeyboardButton *prevtButton = buttons[idx - 1];
			leftConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft
														  relatedBy:NSLayoutRelationEqual
															 toItem:prevtButton attribute:NSLayoutAttributeRight
														 multiplier:1.0 constant:1];

			MMkeyboardButton *firstButton = buttons[0];
			NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:firstButton attribute:NSLayoutAttributeWidth
																			   relatedBy:NSLayoutRelationEqual toItem:button
																			   attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];

			widthConstraint.priority = 800;
			[mainView addConstraint:widthConstraint];
		}

		[mainView addConstraints:@[topConstraint, bottomConstraint, rightConstraint, leftConstraint]];
	}];

}


- (void)addConstraintsToInputViews:(UIView *)inputView WithRowViews:(NSArray *)rowViews {

	[rowViews enumerateObjectsUsingBlock:^(UIView *rowView, NSUInteger idx, BOOL *stop) {

		NSLayoutConstraint *rightSideConstraint = [NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeRight
																			   relatedBy:NSLayoutRelationEqual
																				  toItem:inputView attribute:NSLayoutAttributeRight
																			  multiplier:1.0 constant:-1];

		NSLayoutConstraint *leftSideConstraint = [NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeLeft
																			  relatedBy:NSLayoutRelationEqual
																				 toItem:inputView attribute:NSLayoutAttributeLeft
																			 multiplier:1.0 constant:1];

		[inputView addConstraints:@[leftSideConstraint, rightSideConstraint]];

		NSLayoutConstraint *topConstraint;

		if (idx == 0) {
			topConstraint = [NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeTop
														 relatedBy:NSLayoutRelationEqual
															toItem:inputView attribute:NSLayoutAttributeTop
														multiplier:1.0 constant:20];

		}
		else {
			UIView *prevRow = rowViews[idx - 1];
			topConstraint = [NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeTop
														 relatedBy:NSLayoutRelationEqual
															toItem:prevRow attribute:NSLayoutAttributeBottom
														multiplier:1.0 constant:0];

			UIView *firstRow = rowViews[0];
			NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:firstRow attribute:NSLayoutAttributeHeight
																				relatedBy:NSLayoutRelationEqual
																				   toItem:rowView attribute:NSLayoutAttributeHeight
																			   multiplier:1.0 constant:0];
			heightConstraint.priority = 800;
			[inputView addConstraint:heightConstraint];
		}
		[inputView addConstraint:topConstraint];

		NSLayoutConstraint *bottomConstraint;

		if (idx == rowViews.count - 1) {

			bottomConstraint = [NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeBottom
															relatedBy:NSLayoutRelationEqual
															   toItem:inputView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];

		}
		else {
			UIView *nextRow = rowViews[idx + 1];
			bottomConstraint = [NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeBottom
															relatedBy:NSLayoutRelationEqual
															   toItem:nextRow attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];

		}
		[inputView addConstraint:bottomConstraint];


	}];

}


@end
