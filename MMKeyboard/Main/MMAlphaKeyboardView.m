//
// Created by Tom Atterton on 23/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMAlphaKeyboardView.h"
#import "MMKeyboardButton.h"
#import "UIImage+emoji.h"
#import "KeyboardDelegate.h"
#import "MMkeyboardButton.h"

#define HMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]


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
@property(nonatomic, strong) UIView *buttonView;

@property(nonatomic, strong) MMkeyboardButton *abcButton;
@property(nonatomic, strong) MMkeyboardButton *spaceButton;
@property(nonatomic, strong) MMkeyboardButton *returnButton;
@property(nonatomic, strong) MMkeyboardButton *panningButton;
@property(nonatomic, strong) MMkeyboardButton *gifButton;

// Variables
@property(nonatomic, strong) NSArray *alphaTiles1;
@property(nonatomic, strong) NSArray *alphaTiles2;
@property(nonatomic, strong) NSArray *alphaTiles3;

@property(nonatomic, strong) NSArray *specialTiles1;
@property(nonatomic, strong) NSArray *specialTiles2;
@property(nonatomic, strong) NSArray *specialTiles3;

@property(nonatomic, strong) NSArray *numericTiles1;
@property(nonatomic, strong) NSArray *numericTiles2;
@property(nonatomic, strong) NSArray *numericTiles3;

@property(nonatomic, strong) NSArray *currentTiles1;
@property(nonatomic, strong) NSArray *currentTiles2;
@property(nonatomic, strong) NSArray *currentTiles3;

@property(nonatomic, strong) NSMutableArray<MMkeyboardButton *> *buttons;
@property(nonatomic, strong) NSMutableArray<MMkeyboardButton *> *alphaButtons;

@property(nonatomic, assign) BOOL isCapitalised;
@property(nonatomic, assign) BOOL isSpecialCharacter;
@property(nonatomic, assign) BOOL isNumericCharacter;
@property(nonatomic, assign) NSUInteger paddingKeyboard;
@property(nonatomic, assign) NSUInteger paddingKeyboardRows;

// Gestures
@property(nonatomic, strong) UILongPressGestureRecognizer *optionsViewRecognizer;
@property(nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end


@implementation MMAlphaKeyboardView

- (instancetype)init {
	self = [super init];
	if (self) {

		self.alphaTiles1 = @[@"q", @"w", @"e", @"r", @"t", @"y", @"u", @"i", @"o", @"p"];
		self.alphaTiles2 = @[@"a", @"s", @"d", @"f", @"g", @"h", @"j", @"k", @"l"];
		self.alphaTiles3 = @[@"⇧", @"z", @"x", @"c", @"v", @"b", @"n", @"m", @"⌫"];

		self.numericTiles1 = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0"];
		self.numericTiles2 = @[@"-", @"/", @":", @";", @"(", @")", @"€", @"&", @"@"];
		self.numericTiles3 = @[@"#+=", @".", @",", @"?", @"!", @"™", @"'", @"\"", @"⌫"];

		self.specialTiles1 = @[@"[", @"]", @"{", @"}", @"#", @"%", @"^", @"*", @"+", @"="];
		self.specialTiles2 = @[@"_", @"\"", @"|", @"~", @"<", @">", @"£", @"$", @"¥"];
		self.specialTiles3 = @[@"?!@", @".", @",", @"?", @"!", @"®", @"'", @"•", @"⌫"];

		[self setup];
	}

	return self;
}


- (void)setup {

	self.isCapitalised = NO;
	self.isSpecialCharacter = NO;
	self.isNumericCharacter = NO;

	self.paddingKeyboard = 2;
	self.paddingKeyboardRows = 3;


	self.alphaButtons = @[].mutableCopy;

	self.currentTiles1 = self.alphaTiles1.mutableCopy;
	self.currentTiles2 = self.alphaTiles2.mutableCopy;
	self.currentTiles3 = self.alphaTiles3.mutableCopy;


	self.translatesAutoresizingMaskIntoConstraints = NO;
	self.clipsToBounds = YES;

	self.rowView1 = [self createRowOfButtonWithTitle:self.currentTiles1];
	self.rowView2 = [self createRowOfButtonWithTitle:self.currentTiles2];
	self.rowView3 = [self createRowOfButtonWithTitle:self.currentTiles3];
	self.rowView4 = [self createFinalRow];

	self.rowView1.translatesAutoresizingMaskIntoConstraints = NO;
	self.rowView2.translatesAutoresizingMaskIntoConstraints = NO;
	self.rowView3.translatesAutoresizingMaskIntoConstraints = NO;
	self.rowView4.translatesAutoresizingMaskIntoConstraints = NO;

//	[self.rowView1 setBackgroundColor:[UIColor redColor]];
//	[self.rowView2 setBackgroundColor:[UIColor redColor]];
//	[self.rowView3 setBackgroundColor:[UIColor redColor]];


	[self addSubview:self.rowView1];
	[self addSubview:self.rowView2];
	[self addSubview:self.rowView3];
	[self addSubview:self.rowView4];

	[self addConstraintsToInputViews:self WithRowViews:@[self.rowView1, self.rowView2, self.rowView3, self.rowView4]];


	[self setupInputOptionsConfiguration];
	[self initialiseButtons];
	self.gifButton.tag = kTagGIFKeyboard;

}


- (void)initialiseButtons {
	[self.alphaButtons enumerateObjectsUsingBlock:^(MMkeyboardButton *obj, NSUInteger idx, BOOL *stop) {


//		[obj setContentEdgeInsets:UIEdgeInsetsMake(obj.frame.origin.)];


	}];


}


- (void)didTapButton:(MMkeyboardButton *)sender {

	MMkeyboardButton *button = sender;
	NSString *title = [button titleForState:UIControlStateNormal];

	if ([title isEqualToString:@"⌫"]) {
		[self.keyboardDelegate keyWasTapped:title];
	}
	else if ([title isEqualToString:@"⏎"]) {
		[self.keyboardDelegate keyWasTapped:@"\n"];
	}
	else if ([title isEqualToString:@"space"]) {
		[self.keyboardDelegate keyWasTapped:@" "];
	}
	else if ([title isEqualToString:@"123"]) {
		[sender setTitle:@"ABC" forState:UIControlStateNormal];
		self.isNumericCharacter = [self changeButtons:self.isNumericCharacter typeOfTile:@"numeric"];
	}
	else if ([title isEqualToString:@"ABC"]) {
		[sender setTitle:@"123" forState:UIControlStateNormal];
		self.isNumericCharacter = [self changeButtons:self.isNumericCharacter typeOfTile:@"numeric"];
	}
	else if ([title isEqualToString:@"#+="]) {
		[sender setTitle:@"?!@" forState:UIControlStateNormal];
		self.isSpecialCharacter = [self changeButtons:self.isSpecialCharacter typeOfTile:@"special"];
	}
	else if ([title isEqualToString:@"?!@"]) {
		[sender setTitle:@"#+=" forState:UIControlStateNormal];
		self.isSpecialCharacter = [self changeButtons:self.isSpecialCharacter typeOfTile:@"special"];
	}
	else if ([title isEqualToString:@"⇧"]) {
		[self capataliseButtons];
	}
	else if ([title isEqualToString:@"⇪"]) {
		[self capataliseButtons];
	}

	else {
		[self.keyboardDelegate keyWasTapped:title];
	}
}

- (UIView *)createRowOfButtonWithTitle:(NSArray *)titles {

	self.buttons = @[].mutableCopy;
	UIView *view = [UIView new];
	[titles enumerateObjectsUsingBlock:^(NSString *titleString, NSUInteger idx, BOOL *stop) {
		if (titleString) {

			MMkeyboardButton *button = [self createButtonWithTitle:titleString];
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

- (MMkeyboardButton *)createButtonWithTitle:(NSString *)title {

	MMkeyboardButton *button = [MMkeyboardButton buttonWithType:UIButtonTypeCustom];
	button.translatesAutoresizingMaskIntoConstraints = NO;
	[button setTitle:title forState:UIControlStateNormal];
	button.titleLabel.textColor = [UIColor whiteColor];
	[button setBackgroundImage:[self createImageWithColor:HMColor(208, 208, 208)] forState:UIControlStateHighlighted];

//	[button setContentMode:UIViewContentModeCenter];
//	button.contentEdgeInsets = UIEdgeInsetsMake(-15, -15, -15, -15);

	[button addTarget:self action:@selector(handleTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	[button addTarget:self action:@selector(handleTouchDown:) forControlEvents:UIControlEventTouchDown];
	return button;

}

- (UIImage *)createImageWithColor:(UIColor *)color {
	CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, rect);
	UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return theImage;
}

#pragma mark layout methods


- (void)addIndividualButtonConstraints:(NSArray *)buttons WithMainView:(UIView *)mainView {

	[buttons enumerateObjectsUsingBlock:^(MMkeyboardButton *button, NSUInteger idx, BOOL *stop) {

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
		}


		else if (idx == buttons.count - 1) {
			rightConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight
														   relatedBy:NSLayoutRelationEqual
															  toItem:mainView attribute:NSLayoutAttributeRight
														  multiplier:1.0 constant:-5];

		}

		else {
			MMkeyboardButton *nextButton = buttons[idx + 1];
			rightConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight
														   relatedBy:NSLayoutRelationEqual
															  toItem:nextButton attribute:NSLayoutAttributeLeft
														  multiplier:1.0 constant:-5];


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
														 multiplier:1.0 constant:5];

		}

		else {
			MMkeyboardButton *prevtButton = buttons[idx - 1];
			leftConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft
														  relatedBy:NSLayoutRelationEqual
															 toItem:prevtButton attribute:NSLayoutAttributeRight
														 multiplier:1.0 constant:5];
			NSLayoutConstraint *widthConstraint;

			MMkeyboardButton *firstButton = buttons[0];
			widthConstraint = [NSLayoutConstraint constraintWithItem:firstButton attribute:NSLayoutAttributeWidth
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


		NSLayoutConstraint *rightSideConstraint;

		NSLayoutConstraint *leftSideConstraint;

//		if (idx == 1) {

//			rightSideConstraint = [NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeRightMargin
//															   relatedBy:NSLayoutRelationEqual
//																  toItem:inputView attribute:NSLayoutAttributeRightMargin
//															  multiplier:1.0 constant:-12];
//
//			leftSideConstraint = [NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeLeftMargin
//															  relatedBy:NSLayoutRelationEqual
//																 toItem:inputView attribute:NSLayoutAttributeLeftMargin
//															 multiplier:1.0 constant:12];

//		}

//		else {

		rightSideConstraint = [NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeRight
														   relatedBy:NSLayoutRelationEqual
															  toItem:inputView attribute:NSLayoutAttributeRight
														  multiplier:1.0 constant:-1];

		leftSideConstraint = [NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeLeft
														  relatedBy:NSLayoutRelationEqual
															 toItem:inputView attribute:NSLayoutAttributeLeft
														 multiplier:1.0 constant:1];

//		}


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

- (UIView *)createFinalRow {

	UIView *holder = [UIView new];
	holder.translatesAutoresizingMaskIntoConstraints = NO;


	self.nextKeyboardButton = [MMkeyboardButton buttonWithType:UIButtonTypeCustom];
	self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
	[self.nextKeyboardButton setImage:[UIImage imageWithEmoji:@"🌐" withSize:30] forState:UIControlStateNormal];
	[self.nextKeyboardButton setTintColor:[UIColor whiteColor]];
	[holder addSubview:self.nextKeyboardButton];


	self.abcButton = [MMkeyboardButton buttonWithType:UIButtonTypeCustom];
	self.abcButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.abcButton.clipsToBounds = YES;
	[self.abcButton setTitle:@"123" forState:UIControlStateNormal];
	[self.abcButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.abcButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
	[holder addSubview:self.abcButton];

	self.spaceButton = [MMkeyboardButton buttonWithType:UIButtonTypeCustom];
	self.spaceButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.spaceButton.clipsToBounds = YES;
	[self.spaceButton setTitle:@"space" forState:UIControlStateNormal];
	[self.spaceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.spaceButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
	[holder addSubview:self.spaceButton];

	self.returnButton = [MMkeyboardButton buttonWithType:UIButtonTypeCustom];
	self.returnButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.returnButton.clipsToBounds = YES;
	[self.returnButton setTitle:@"⏎" forState:UIControlStateNormal];
	[self.returnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.returnButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
	[holder addSubview:self.returnButton];


	NSDictionary *views = @{@"abcButton" : self.abcButton, @"changeButton" : self.nextKeyboardButton, @"spaceButton" : self.spaceButton, @"returnButton" : self.returnButton};
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[abcButton]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[spaceButton]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[changeButton]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[returnButton]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[abcButton(==changeButton)]-5-[changeButton(==50)]-5-[spaceButton]-5-[returnButton(70)]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

	return holder;

}


#pragma mark Helper methods

- (MMkeyboardButton *)returnButtonLocation:(CGPoint)point {

	__block MMkeyboardButton *currentButton;

	[self.alphaButtons enumerateObjectsUsingBlock:^(MMkeyboardButton *button, NSUInteger idx, BOOL *stop) {

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
		self.currentTiles1 = ([type isEqualToString:@"numeric"]) ? self.numericTiles1 : self.specialTiles1;
		self.currentTiles2 = ([type isEqualToString:@"numeric"]) ? self.numericTiles2 : self.specialTiles2;
		self.currentTiles3 = ([type isEqualToString:@"numeric"]) ? self.numericTiles3 : self.specialTiles3;
	}
	else {
		self.currentTiles1 = ([type isEqualToString:@"numeric"]) ? self.alphaTiles1 : self.numericTiles1;
		self.currentTiles2 = ([type isEqualToString:@"numeric"]) ? self.alphaTiles2 : self.numericTiles2;
		self.currentTiles3 = ([type isEqualToString:@"numeric"]) ? self.alphaTiles3 : self.numericTiles3;
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

	[self.alphaButtons enumerateObjectsUsingBlock:^(MMkeyboardButton *obj, NSUInteger idx, BOOL *stop) {
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

		if (self.panningButton) {

			[self didTapButton:self.panningButton];

		}
		[self hideInputView];
	}
	else {
		CGPoint location = [recognizer locationInView:self];
		self.panningButton = [self returnButtonLocation:location];
		if (self.panningButton) {

			[self showInputView:self.panningButton];
		}
		else {

			[self hideInputView];
		}
	}
}


#pragma mark keyboard popup

- (void)addPopupToButton:(MMkeyboardButton *)sender {

	self.buttonView = [UIView new];
	self.buttonView.translatesAutoresizingMaskIntoConstraints = NO;
	self.buttonView.layer.cornerRadius = 4;
	[self.superview addSubview:self.buttonView];

	UITextView *text = [[UITextView alloc] init];
	text.translatesAutoresizingMaskIntoConstraints = NO;
	[text setText:sender.titleLabel.text];
	text.layer.cornerRadius = 4;
	text.textContainerInset = UIEdgeInsetsZero;
	text.textContainer.lineFragmentPadding = 0;
	text.textAlignment = NSTextAlignmentCenter;
	[text setFont:[UIFont boldSystemFontOfSize:30]];
	text.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
	[self.buttonView addSubview:text];


	NSDictionary *metrics = @{};
	NSDictionary *views = @{@"buttonView" : self.buttonView, @"text" : text};


	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:2.0 constant:(CGFloat) (sender.frame.size.height * 2.1)]];
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:2.0 constant:(CGFloat) (sender.frame.size.width * 1.3)]];

	NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.buttonView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:sender attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
	bottomConstraint.priority = 800;
	[self.superview addConstraint:bottomConstraint];

//	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:sender attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];

	[self.buttonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[text]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.buttonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[text]-(0)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

}

#pragma mark Popup Methods

- (void)showInputView:(MMkeyboardButton *)sender {
	[self hideInputView];
	if ([sender.titleLabel.text isEqualToString:@"⇧"] || [sender.titleLabel.text isEqualToString:@"⇪"] || [sender.titleLabel.text isEqualToString:@"⌫"] || [sender.titleLabel.text isEqualToString:@"#+="] || [sender.titleLabel.text isEqualToString:@"?!@"]) {

	}
	else {
		[self addPopupToButton:sender];
	}
}

- (void)hideInputView {

	[self.buttonView removeFromSuperview];
	self.buttonView = nil;
	[self.keyboardDelegate updateLayout];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return (gestureRecognizer == _panGestureRecognizer) && (otherGestureRecognizer == _panGestureRecognizer);
}

#pragma mark - Touch Actions

- (void)handleTouchDown:(MMkeyboardButton *)sender {
	[[UIDevice currentDevice] playInputClick];

	[self showInputView:sender];
}

- (void)handleTouchUpInside:(MMkeyboardButton *)sender {

	[self didTapButton:sender]; //TODO
	[self hideInputView];
}

#pragma mark - Touch Handling

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];

	[self hideInputView];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:touches withEvent:event];

	[self hideInputView];
}

@end
