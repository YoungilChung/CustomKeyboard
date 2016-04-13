//
// Created by Tom Atterton on 23/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMAlphaKeyboardView.h"
#import "MMKeyboardButton.h"
#import "UIImage+emoji.h"
#import "KeyboardDelegate.h"
#import "MMKeyboardKeysModel.h"
#import "PopupButtonView.h"

#define HMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define CASE(str)                       if ([__s__ isEqualToString:(str)])
#define SWITCH(s)                       for (NSString *__s__ = (s); ; )
#define DEFAULT


typedef enum {
	kTagGIFKeyboard = 100,
	kTagABCKeyboard,
} buttonTags;

@interface MMAlphaKeyboardView () <UIGestureRecognizerDelegate, UITextFieldDelegate>


// Views
@property(nonatomic, strong) UIView *rowView1;
@property(nonatomic, strong) UIView *rowView2;
@property(nonatomic, strong) UIView *rowView3;
@property(nonatomic, strong) UIView *rowView4;
@property(nonatomic, strong) PopupButtonView *buttonView;

@property(nonatomic, strong) MMKeyboardButton *abcButton;
@property(nonatomic, strong) MMKeyboardButton *spaceButton;
@property(nonatomic, strong) MMKeyboardButton *returnButton;
@property(nonatomic, strong) MMKeyboardButton *periodButton;
@property(nonatomic, strong) MMKeyboardButton *panningButton;
@property(nonatomic, strong) MMKeyboardButton *gifButton;

// Variables
@property(nonatomic, strong) NSArray *currentTiles1;
@property(nonatomic, strong) NSArray *currentTiles2;
@property(nonatomic, strong) NSArray *currentTiles3;

@property(nonatomic, strong) NSMutableArray<MMKeyboardButton *> *buttons;
@property(nonatomic, strong) NSMutableArray<MMKeyboardButton *> *alphaButtons;

@property(nonatomic, assign) BOOL isCapitalised;
@property(nonatomic, assign) BOOL isSpecialCharacter;
@property(nonatomic, assign) BOOL isNumericCharacter;

@property(nonatomic, strong) MMKeyboardKeysModel *keyboardKeysModel;

@property(nonatomic, assign) popUpStyle popUpStyle;

// Gestures
@property(nonatomic, strong) UILongPressGestureRecognizer *optionsViewRecognizer;
@property(nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end


@implementation MMAlphaKeyboardView

- (instancetype)init {
	self = [super init];
	if (self) {

		self.keyboardKeysModel = [[MMKeyboardKeysModel alloc] init];

		[self setup];
	}

	return self;
}


- (void)setup {

	self.isCapitalised = NO;
	self.isSpecialCharacter = NO;
	self.isNumericCharacter = NO;


	self.alphaButtons = @[].mutableCopy;

	self.currentTiles1 = self.keyboardKeysModel.alphaTiles1.mutableCopy;
	self.currentTiles2 = self.keyboardKeysModel.alphaTiles2.mutableCopy;
	self.currentTiles3 = self.keyboardKeysModel.alphaTiles3.mutableCopy;


	self.translatesAutoresizingMaskIntoConstraints = NO;
	self.clipsToBounds = YES;
	[self setBackgroundColor:[UIColor grayColor]];
	self.rowView1 = [self createRowOfButtonWithTitle:self.currentTiles1];
	self.rowView2 = [self createRowOfButtonWithTitle:self.currentTiles2];
	self.rowView3 = [self createRowOfButtonWithTitle:self.currentTiles3];
	self.rowView4 = [self createFinalRow];

	self.rowView1.translatesAutoresizingMaskIntoConstraints = NO;
	self.rowView2.translatesAutoresizingMaskIntoConstraints = NO;
	self.rowView3.translatesAutoresizingMaskIntoConstraints = NO;
	self.rowView4.translatesAutoresizingMaskIntoConstraints = NO;

	[self addSubview:self.rowView1];
	[self addSubview:self.rowView2];
	[self addSubview:self.rowView3];
	[self addSubview:self.rowView4];

	[self addConstraintsToInputViews:self WithRowViews:@[self.rowView1, self.rowView2, self.rowView3, self.rowView4]];


	[self setupInputOptionsConfiguration];
	self.gifButton.tag = kTagGIFKeyboard;

}


- (void)didTapButton:(MMKeyboardButton *)sender {

	MMKeyboardButton *button = sender;
	NSString *title = [button titleForState:UIControlStateNormal];

	SWITCH(title) {
		CASE (@"⌫") {

			[self.keyboardDelegate keyWasTapped:title];
			break;
		}
		CASE (@"⏎") {

			[self.keyboardDelegate keyWasTapped:@"\n"];

			break;
		}
		CASE (@"space") {

			[self.keyboardDelegate keyWasTapped:@" "];

			break;
		}
		CASE (@"123") {
			[sender setTitle:@"ABC" forState:UIControlStateNormal];
			self.isNumericCharacter = [self changeButtons:self.isNumericCharacter typeOfTile:@"numeric"];
			break;
		}
		CASE (@"ABC") {
			[sender setTitle:@"123" forState:UIControlStateNormal];
			self.isNumericCharacter = [self changeButtons:self.isNumericCharacter typeOfTile:@"numeric"];

			break;
		}
		CASE (@"#+=") {
			[sender setTitle:@"?!@" forState:UIControlStateNormal];
			self.isSpecialCharacter = [self changeButtons:self.isSpecialCharacter typeOfTile:@"special"];
			break;
		}
		CASE (@"?!@") {

			[sender setTitle:@"#+=" forState:UIControlStateNormal];
			self.isSpecialCharacter = [self changeButtons:self.isSpecialCharacter typeOfTile:@"special"];
			break;
		}
		CASE (@"⇧") {

			[self capataliseButtons];
			break;
		}

		CASE (@"⇪") {

			[self capataliseButtons];

			break;
		}
		DEFAULT {

			[self.keyboardDelegate keyWasTapped:title];

			break;
		}


	}


}

- (UIView *)createRowOfButtonWithTitle:(NSArray *)titles {

	self.buttons = @[].mutableCopy;
	UIView *view = [UIView new];
	view.backgroundColor = [UIColor clearColor];
	[titles enumerateObjectsUsingBlock:^(NSString *titleString, NSUInteger idx, BOOL *stop) {
		if (titleString) {

			MMKeyboardButton *button = [self createButtonWithTitle:titleString];
			[self.buttons addObject:button];
			[self.alphaButtons addObject:button];

			if (self.buttons.count > 0) {

				[view addSubview:button];
			}

		}
	}];

	[self addIndividualButtonConstraints:self.buttons WithMainView:view];

	return view;
}

- (MMKeyboardButton *)createButtonWithTitle:(NSString *)title {

	MMKeyboardButton *button = [MMKeyboardButton buttonWithType:UIButtonTypeCustom];
	button.translatesAutoresizingMaskIntoConstraints = NO;
	[button setTitle:title forState:UIControlStateNormal];
	button.titleLabel.textColor = [UIColor whiteColor];
//	[button setBackgroundImage:[self createImageWithColor:HMColor(208, 208, 208)] forState:UIControlStateHighlighted];


	[button addTarget:self action:@selector(handleTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	[button addTarget:self action:@selector(handleTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
	[button addTarget:self action:@selector(handleTouchDown:) forControlEvents:UIControlEventTouchDown];
	return button;

}

//- (UIImage *)createImageWithColor:(UIColor *)color {
//	CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//	UIGraphicsBeginImageContext(rect.size);
//	CGContextRef context = UIGraphicsGetCurrentContext();
//	CGContextSetFillColorWithColor(context, [color CGColor]);
//	CGContextFillRect(context, rect);
//	UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
//	UIGraphicsEndImageContext();
//
//	return theImage;
//}

#pragma mark layout methods


- (void)addIndividualButtonConstraints:(NSArray *)buttons WithMainView:(UIView *)mainView {

	[buttons enumerateObjectsUsingBlock:^(MMKeyboardButton *button, NSUInteger idx, BOOL *stop) {

		NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop
																		 relatedBy:NSLayoutRelationEqual
																			toItem:mainView attribute:NSLayoutAttributeTop
																		multiplier:1.0 constant:5];

		NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom
																			relatedBy:NSLayoutRelationEqual
																			   toItem:mainView attribute:NSLayoutAttributeBottom
																		   multiplier:1.0 constant:-5];


		NSLayoutConstraint *rightConstraint;
		NSLayoutConstraint *leftConstraint;


		if ([button.titleLabel.text isEqualToString:@"l"]) {
			rightConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight
														   relatedBy:NSLayoutRelationEqual
															  toItem:mainView attribute:NSLayoutAttributeRight
														  multiplier:1.0 constant:-18];
			[mainView addConstraint:rightConstraint];
		}


		else if (idx == buttons.count - 1) {
			rightConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight
														   relatedBy:NSLayoutRelationEqual
															  toItem:mainView attribute:NSLayoutAttributeRight
														  multiplier:1.0 constant:-2];

			[mainView addConstraint:rightConstraint];


		}

		if ([button.titleLabel.text isEqualToString:@"a"]) {
			leftConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft
														  relatedBy:NSLayoutRelationEqual
															 toItem:mainView attribute:NSLayoutAttributeLeft
														 multiplier:1.0 constant:18];

		}
		else if (idx == 0) {
			leftConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft
														  relatedBy:NSLayoutRelationEqual
															 toItem:mainView attribute:NSLayoutAttributeLeft
														 multiplier:1.0 constant:2];

		}

		else {
			MMKeyboardButton *prevtButton = buttons[idx - 1];
			leftConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft
														  relatedBy:NSLayoutRelationEqual
															 toItem:prevtButton attribute:NSLayoutAttributeRight
														 multiplier:1.0 constant:5];
			NSLayoutConstraint *widthConstraint;

			MMKeyboardButton *firstButton = buttons[0];
			widthConstraint = [NSLayoutConstraint constraintWithItem:firstButton attribute:NSLayoutAttributeWidth
														   relatedBy:NSLayoutRelationEqual toItem:button
														   attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];

//			widthConstraint.priority = 800;
			[mainView addConstraint:widthConstraint];
		}

		[mainView addConstraints:@[topConstraint, bottomConstraint, leftConstraint]];

	}];

}


- (void)addConstraintsToInputViews:(UIView *)inputView WithRowViews:(NSArray *)rowViews {


	[rowViews enumerateObjectsUsingBlock:^(UIView *rowView, NSUInteger idx, BOOL *stop) {


		NSLayoutConstraint *rightSideConstraint;

		NSLayoutConstraint *leftSideConstraint;


		rightSideConstraint = [NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeRight
														   relatedBy:NSLayoutRelationEqual
															  toItem:inputView attribute:NSLayoutAttributeRight
														  multiplier:1.0 constant:-1];

		leftSideConstraint = [NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeLeft
														  relatedBy:NSLayoutRelationEqual
															 toItem:inputView attribute:NSLayoutAttributeLeft
														 multiplier:1.0 constant:1];


		[inputView addConstraints:@[leftSideConstraint, rightSideConstraint]];

		NSLayoutConstraint *topConstraint;

		if (idx == 0) {

			topConstraint = [NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeTop
														 relatedBy:NSLayoutRelationEqual
															toItem:inputView attribute:NSLayoutAttributeTop
														multiplier:1.0 constant:2];

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
															   toItem:inputView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-2];

			[inputView addConstraint:bottomConstraint];
		}

	}];

}

- (UIView *)createFinalRow {

	UIView *holder = [UIView new];
	holder.translatesAutoresizingMaskIntoConstraints = NO;


	self.nextKeyboardButton = [MMKeyboardButton buttonWithType:UIButtonTypeCustom];
	self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
	[self.nextKeyboardButton setImage:[UIImage imageWithEmoji:@"🌐" withSize:30] forState:UIControlStateNormal];
	[self.nextKeyboardButton setTintColor:[UIColor whiteColor]];
	[holder addSubview:self.nextKeyboardButton];


	self.abcButton = [MMKeyboardButton buttonWithType:UIButtonTypeCustom];
	self.abcButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.abcButton.clipsToBounds = YES;
	[self.abcButton setTitle:@"123" forState:UIControlStateNormal];
	[self.abcButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.abcButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
	[holder addSubview:self.abcButton];

	self.periodButton = [MMKeyboardButton buttonWithType:UIButtonTypeCustom];
	self.periodButton.translatesAutoresizingMaskIntoConstraints = NO;
	[self.periodButton setTitle:@"." forState:UIControlStateNormal];
	[self.periodButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.periodButton addTarget:self action:@selector(handleTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	[self.periodButton addTarget:self action:@selector(handleTouchDown:) forControlEvents:UIControlEventTouchDown];
	[holder addSubview:self.periodButton];
	[self.alphaButtons addObject:self.periodButton];


	self.spaceButton = [MMKeyboardButton buttonWithType:UIButtonTypeCustom];
	self.spaceButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.spaceButton.clipsToBounds = YES;
	[self.spaceButton setTitle:@"space" forState:UIControlStateNormal];
	[self.spaceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.spaceButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
	[holder addSubview:self.spaceButton];

	self.returnButton = [MMKeyboardButton buttonWithType:UIButtonTypeCustom];
	self.returnButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.returnButton.clipsToBounds = YES;
	[self.returnButton setTitle:@"⏎" forState:UIControlStateNormal];
	[self.returnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.returnButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
	[holder addSubview:self.returnButton];


	NSDictionary *views = @{@"abcButton" : self.abcButton, @"changeButton" : self.nextKeyboardButton, @"spaceButton" : self.spaceButton, @"returnButton" : self.returnButton, @"periodButton": self.periodButton};
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[abcButton]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[spaceButton]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[changeButton]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[returnButton]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[periodButton]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[abcButton(==changeButton)]-5-[changeButton(==45)]-5-[spaceButton]-5-[periodButton(==35)]-5-[returnButton(70)]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

	return holder;

}


#pragma mark Helper methods

- (MMKeyboardButton *)returnButtonLocation:(CGPoint)point {

	__block MMKeyboardButton *currentButton;

	[self.alphaButtons enumerateObjectsUsingBlock:^(MMKeyboardButton *button, NSUInteger idx, BOOL *stop) {

//		if ([button.titleLabel.text isEqualToString:@"⇧"] || [button.titleLabel.text isEqualToString:@"⇪"] || [button.titleLabel.text isEqualToString:@"⌫"] || [button.titleLabel.text isEqualToString:@"#+="] || [button.titleLabel.text isEqualToString:@"?!@"]) {
//
//		}
//		else {
		CGRect buttonRect = CGRectMake(button.frame.origin.x, [button superview].frame.origin.y, button.frame.size.width, button.frame.size.height);
		if (CGRectContainsPoint(buttonRect, point)) {
			currentButton = button;
		}
//		}
	}
	];

	if (currentButton) {
		return currentButton;
	}

	else {

		return nil;
	}
}

- (BOOL)changeButtons:(BOOL)changeBool typeOfTile:(NSString *)type {

	if (!changeBool) {
		self.currentTiles1 = ([type isEqualToString:@"numeric"]) ? self.keyboardKeysModel.numericTiles1 : self.keyboardKeysModel.specialTiles1;
		self.currentTiles2 = ([type isEqualToString:@"numeric"]) ? self.keyboardKeysModel.numericTiles2 : self.keyboardKeysModel.specialTiles2;
		self.currentTiles3 = ([type isEqualToString:@"numeric"]) ? self.keyboardKeysModel.numericTiles3 : self.keyboardKeysModel.specialTiles3;
	}
	else {
		self.currentTiles1 = ([type isEqualToString:@"numeric"]) ? self.keyboardKeysModel.alphaTiles1 : self.keyboardKeysModel.numericTiles1;
		self.currentTiles2 = ([type isEqualToString:@"numeric"]) ? self.keyboardKeysModel.alphaTiles2 : self.keyboardKeysModel.numericTiles2;
		self.currentTiles3 = ([type isEqualToString:@"numeric"]) ? self.keyboardKeysModel.alphaTiles3 : self.keyboardKeysModel.numericTiles3;
	}

	NSMutableArray *testHolder = @[].mutableCopy;
	[testHolder addObjectsFromArray:self.currentTiles1];
	[testHolder addObjectsFromArray:self.currentTiles2];
	[testHolder addObjectsFromArray:self.currentTiles3];


	for (uint n = 0; n < [self.alphaButtons count]; ++n) {

		[self.alphaButtons[n] setTitle:testHolder[n] forState:UIControlStateNormal];

	}

	[self.keyboardDelegate updateLayout];
	changeBool = !changeBool;
	return changeBool;
}


- (void)capataliseButtons {

	[self.alphaButtons enumerateObjectsUsingBlock:^(MMKeyboardButton *obj, NSUInteger idx, BOOL *stop) {
		NSString *title = [obj titleForState:UIControlStateNormal];
		if ([title isEqualToString:@"BP"] || [title isEqualToString:@"CP"] || [title isEqualToString:@"CHG"] || [title isEqualToString:@"SPACE"] || [title isEqualToString:@"RETURN"] || [title isEqualToString:@"GIF"]) {

		}

		else {
			if (!self.isCapitalised) {
				if ([title isEqualToString:@"⇧"]) {
					[obj setTitle:@"⇪" forState:UIControlStateNormal];

				}
				else {

					[obj setTitle:title.uppercaseString forState:UIControlStateNormal];

				}
			}
			else {
				if ([title isEqualToString:@"⇪"]) {
					[obj setTitle:@"⇧" forState:UIControlStateNormal];

				}
				else {

					[obj setTitle:title.lowercaseString forState:UIControlStateNormal];
				}

			}
		}
	}];

	[self.keyboardDelegate updateLayout];
	self.isCapitalised = !self.isCapitalised;
}


#pragma mark - Touch Actions

- (void)setupInputOptionsConfiguration {
	[self tearDownInputOptionsConfiguration];

	UILongPressGestureRecognizer *longPressGestureRecognizer =
			[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
	longPressGestureRecognizer.minimumPressDuration = 0.3;
	longPressGestureRecognizer.delegate = self;

	[self addGestureRecognizer:longPressGestureRecognizer];
	self.optionsViewRecognizer = longPressGestureRecognizer;


	UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePanning:)];
	panGestureRecognizer.delegate = self;

	[self addGestureRecognizer:panGestureRecognizer];
	self.panGestureRecognizer = panGestureRecognizer;
}

- (void)tearDownInputOptionsConfiguration {

	[self removeGestureRecognizer:self.optionsViewRecognizer];
	[self removeGestureRecognizer:self.panGestureRecognizer];
}


- (void)_handlePanning:(UIPanGestureRecognizer *)recognizer {
	if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {

		if (self.buttonView.selectedCharacter) {
			[self.keyboardDelegate keyWasTapped:self.buttonView.selectedCharacter];

		}
		else {
			if (self.panningButton) {

				[self didTapButton:self.panningButton];
			}

		}

		self.popUpStyle = kpopUpStyleSingle;
		[self hideInputView];
	}
	else {

		switch (self.popUpStyle) {

			case kpopUpStyleSingle: {

				CGPoint location = [recognizer locationInView:self];
				self.panningButton = [self returnButtonLocation:location];
				if (self.panningButton) {

					[self showInputView:self.panningButton];
				}
				else {

					[self hideInputView];
				}

				break;
			}
			case kpopUpStyleMultiple: {

				CGPoint location = [recognizer locationInView:self];
				[self.buttonView updatePosition:location];

				break;
			}
		}

	}
}


#pragma mark touch gestures

- (void)longPress:(UILongPressGestureRecognizer *)gesture {
	CGPoint location = [gesture locationInView:self];
	self.panningButton = [self returnButtonLocation:location];

	NSArray *multipleButtons = [self.keyboardKeysModel specialCharactersWithLetter:self.panningButton.titleLabel.text];

	if (multipleButtons.count >= 1) {

		if (gesture.state == UIGestureRecognizerStateBegan) {


			[self hideInputView];
			self.popUpStyle = kpopUpStyleMultiple;
			[self addPopupToButton:self.panningButton WithPopStyle:kpopUpStyleMultiple];

		}
	}
	if (gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateEnded) {

		if (self.panGestureRecognizer.state != UIGestureRecognizerStateRecognized) {
			self.popUpStyle = kpopUpStyleSingle;
			if (self.panningButton) {

				[self handleTouchUpInside:self.panningButton];
			}
		}
	}

}

#pragma mark keyboard popup

- (void)addPopupToButton:(MMKeyboardButton *)sender WithPopStyle:(popUpStyle)popUpStyle {


	self.buttonView = [[PopupButtonView alloc] initWithButton:sender WithPopupStyle:popUpStyle];
	self.buttonView.translatesAutoresizingMaskIntoConstraints = NO;
	self.buttonView.layer.cornerRadius = 4;
	[self.buttonView setBackgroundColor:[UIColor clearColor]];
	[self.superview addSubview:self.buttonView];


	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:2.0 constant:(CGFloat) (sender.frame.size.height)]];
	NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.buttonView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:sender attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
	bottomConstraint.priority = 800;
	[self.superview addConstraint:bottomConstraint];

	if (sender.frame.origin.x > 125) {

		[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonView attribute:NSLayoutAttributeRight
																   relatedBy:NSLayoutRelationEqual
																	  toItem:sender attribute:NSLayoutAttributeRight
																  multiplier:1.0 constant:0]];

		[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonView attribute:NSLayoutAttributeLeft
																   relatedBy:NSLayoutRelationGreaterThanOrEqual
																	  toItem:self attribute:NSLayoutAttributeLeft
																  multiplier:1.0 constant:0]];

	}
	else {

		[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:sender attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
		[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
	}

	NSLayoutConstraint *centerConstraint = [NSLayoutConstraint constraintWithItem:self.buttonView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:sender attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
	[centerConstraint setPriority:800];

	[self.superview addConstraint:centerConstraint];
}


#pragma mark Popup Methods

- (void)showInputView:(MMKeyboardButton *)sender {
	[self hideInputView];
	if ([sender.titleLabel.text isEqualToString:@"⇧"] || [sender.titleLabel.text isEqualToString:@"⇪"] || [sender.titleLabel.text isEqualToString:@"⌫"] || [sender.titleLabel.text isEqualToString:@"#+="] || [sender.titleLabel.text isEqualToString:@"?!@"]) {

	}
	else {
		self.popUpStyle = kpopUpStyleSingle;
		[self addPopupToButton:sender WithPopStyle:kpopUpStyleSingle];
	}
}

- (void)hideInputView {

	[self.buttonView removeFromSuperview];
	self.buttonView = nil;

	[self.keyboardDelegate updateLayout];
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)                         gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:
		(UIGestureRecognizer *)otherGestureRecognizer {
	return (gestureRecognizer == _panGestureRecognizer || gestureRecognizer == _optionsViewRecognizer) &&
			(otherGestureRecognizer == _panGestureRecognizer || otherGestureRecognizer == _optionsViewRecognizer);
}

#pragma mark - Touch Actions

- (void)handleTouchDown:(MMKeyboardButton *)sender {
	[[UIDevice currentDevice] playInputClick];

	[self showInputView:sender];
}

- (void)handleTouchUpInside:(MMKeyboardButton *)sender {

	[self didTapButton:sender];
	[self hideInputView];
}

- (void)handleTouchUpOutside:(MMKeyboardButton *)sender {

//	[self showInputView:sender];
//	[self didTapButton:sender];
//	[self hideInputView];
}

#pragma mark - Touch Handling

- (void)touchesEnded:(NSSet *)touches
		   withEvent:
				   (UIEvent *)event {
	[super touchesEnded:touches withEvent:event];

	[self hideInputView];
}

- (void)touchesCancelled:(NSSet *)touches
			   withEvent:
					   (UIEvent *)event {
	[super touchesCancelled:touches withEvent:event];

	[self hideInputView];
}

@end
