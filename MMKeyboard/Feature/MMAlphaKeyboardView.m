//
// Created by Tom Atterton on 23/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMAlphaKeyboardView.h"
#import "MMKeyboardButton.h"
#import "UIImage+emoji.h"
#import "MMKeyboardSelection.h"

typedef enum {
	Delete,
	Return,
	Space,
	CHG,

} ButtonString;

@interface MMAlphaKeyboardView () <UITextDocumentProxy, UIGestureRecognizerDelegate, UITextFieldDelegate>


// Views
@property(nonatomic, strong) UIView *rowView1;
@property(nonatomic, strong) UIView *rowView2;
@property(nonatomic, strong) UIView *rowView3;
@property(nonatomic, strong) UIView *rowView4;
@property(nonatomic, strong) UIView *searchHolder;
@property(nonatomic, strong) UIView *buttonView;
@property(nonatomic, strong) MMKeyboardSelection *selectionView;

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
@property(nonatomic, strong) UITextField *searchBar;

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

	self.alphaButtons = @[].mutableCopy;

	self.currentTiles1 = self.alphaTiles1.mutableCopy;
	self.currentTiles2 = self.alphaTiles2.mutableCopy;
	self.currentTiles3 = self.alphaTiles3.mutableCopy;


	self.rowView1 = [self createRowOfButtonWithTitle:self.currentTiles1];
	self.rowView2 = [self createRowOfButtonWithTitle:self.currentTiles2];
	self.rowView3 = [self createRowOfButtonWithTitle:self.currentTiles3];
	self.rowView4 = [self createFinalRow];

	[self.view addSubview:self.rowView1];
	[self.view addSubview:self.rowView2];
	[self.view addSubview:self.rowView3];
	[self.view addSubview:self.rowView4];

	self.rowView1.translatesAutoresizingMaskIntoConstraints = NO;
	self.rowView2.translatesAutoresizingMaskIntoConstraints = NO;
	self.rowView3.translatesAutoresizingMaskIntoConstraints = NO;
	self.rowView4.translatesAutoresizingMaskIntoConstraints = NO;

	self.searchHolder = [UIView new];
	self.searchHolder.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.searchHolder];


	UILabel *magnifyingGlass = [[UILabel alloc] init];
	[magnifyingGlass setText:[[NSString alloc] initWithUTF8String:"\xF0\x9F\x94\x8D"]];
	[magnifyingGlass sizeToFit];


	self.searchBar = [[UITextField alloc] init];
	self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
	self.searchBar.backgroundColor = [UIColor whiteColor];
	[self.searchBar setPlaceholder:@"Search for a GIF"];
	self.searchBar.delegate = self;
	self.searchBar.layer.cornerRadius = 4;
	[self.searchBar setLeftView:magnifyingGlass];
	[self.searchBar setLeftViewMode:UITextFieldViewModeAlways];
	self.searchBar.clipsToBounds = YES;
	[self.searchHolder addSubview:self.searchBar];


	self.gifButton = [MMkeyboardButton buttonWithType:UIButtonTypeCustom];
	self.gifButton.translatesAutoresizingMaskIntoConstraints = NO;
	[self.gifButton setTitle:@"GIF" forState:UIControlStateNormal];
	[self.gifButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.searchHolder addSubview:self.gifButton];

	self.view.userInteractionEnabled = YES;

	[self addConstraintsToInputViews:self.view WithRowViews:@[self.rowView1, self.rowView2, self.rowView3, self.rowView4]];
	[self setupInputOptionsConfiguration];

}

- (void)textFieldDidEndEditing:(UITextField *)textField {

}

- (UIView *)createFinalRow {

	UIView *holder = [UIView new];
//	UIView *holder = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,30)];
	holder.translatesAutoresizingMaskIntoConstraints = NO;
//	UIView *holder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];

	NSMutableArray *testHolder = @[].mutableCopy;

	MMkeyboardButton *nextKeyboardButton = [MMkeyboardButton buttonWithType:UIButtonTypeCustom];
	nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
//	nextKeyboardButton.clipsToBounds = YES;
	[nextKeyboardButton setImage:[UIImage imageWithEmoji:@"🌐" withSize:30] forState:UIControlStateNormal];
//	[nextKeyboardButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
	[nextKeyboardButton addTarget:self action:@selector(gifKeyboardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[nextKeyboardButton setTintColor:[UIColor whiteColor]];
	[holder addSubview:nextKeyboardButton];
//	[nextKeyboardButton setTitle:@"gif" forState:UIControlStateNormal];
//	[nextKeyboardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//	[nextKeyboardButton setImage:[UIImage imageNamed:@"NextKeyboardIcon"] forState:UIControlStateNormal];
//	[nextKeyboardButton setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];

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

//	NSDictionary *views = @{@"abcButton" : self.abcButton, @"changeButton" : nextKeyboardButton, @"spaceButton" : self.spaceButton, @"returnButton" : self.returnButton};
//	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[abcButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
//	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[spaceButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
//	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[changeButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
//	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[returnButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
////	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[changeButton(==returnButton)]-1-[abcButton(==returnButton)]-1-[spaceButton(==returnButton)]-1-[returnButton(==changeButton)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
//	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[changeButton(==abcButton)]-1-[abcButton(==60)]-1-[spaceButton]-1-[returnButton(70)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

	NSDictionary *views = @{@"abcButton" : self.abcButton, @"changeButton" : nextKeyboardButton, @"spaceButton" : self.spaceButton, @"returnButton" : self.returnButton};
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[abcButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[spaceButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[changeButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[returnButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-1-[changeButton(==abcButton)]-1-[abcButton(==50)]-1-[spaceButton]-1-[returnButton(70)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];


//	[testHolder addObject:nextKeyboardButton];
//	[testHolder addObject:self.abcButton];
//	[testHolder addObject:self.spaceButton];
//	[testHolder addObject:self.returnButton];
//
//	[self addIndividualButtonConstraints:testHolder WithMainView:holder];

	return holder;


}

- (void)showKeyboardSelection:(MMkeyboardButton *)sender {








}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];

	NSArray *keyboards = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleKeyboards"];

	self.selectionView = [[MMKeyboardSelection alloc] initWithData:keyboards];



	NSLog(@"keyboards: %@", keyboards[0]);

// check for your keyboard
	NSUInteger index = [keyboards indexOfObject:@"com.example.productname.keyboard-extension"];

	if (index != NSNotFound) {
		NSLog(@"found keyboard");
	}

}

- (void)gifKeyboardButtonPressed:(MMkeyboardButton *)sender {


	NSLog(@"comes here");
	self.selectionView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.selectionView];


	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.selectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.selectionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.selectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.selectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:sender attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.selectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];


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

	[button addTarget:self action:@selector(handleTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	[button addTarget:self action:@selector(handleTouchDown:) forControlEvents:UIControlEventTouchDown];
	return button;

}

- (void)didTapButton:(MMkeyboardButton *)sender {

	MMkeyboardButton *button = sender;
	NSString *title = [button titleForState:UIControlStateNormal];

	if ([title isEqualToString:@"⌫"]) {
		[self.textDocumentProxy deleteBackward];
	}
	else if ([title isEqualToString:@"⏎"]) {
		[self.textDocumentProxy insertText:@"\n"];
	}
	else if ([title isEqualToString:@"space"]) {
		[self.textDocumentProxy insertText:@" "];
	}
	else if ([title isEqualToString:@"CHG"]) {
		[self advanceToNextInputMode];
	}
	else if ([title isEqualToString:@"123"]) {
		[sender setTitle:@"ABC" forState:UIControlStateNormal];
		[self numericButtons];
	}
	else if ([title isEqualToString:@"ABC"]) {
		[sender setTitle:@"123" forState:UIControlStateNormal];
		[self numericButtons];
	}
	else if ([title isEqualToString:@"#+="]) {
		[sender setTitle:@"?!@" forState:UIControlStateNormal];
		[self specialButtons];
	}

	else if ([title isEqualToString:@"?!@"]) {
		[sender setTitle:@"#+=" forState:UIControlStateNormal];
		[self specialButtons];
	}
	else if ([title isEqualToString:@"⇧"]) {
		[self capataliseButtons];
	}
	else if ([title isEqualToString:@"⇪"]) {
		[self capataliseButtons];
	}
	else {
		[self.textDocumentProxy insertText:title];
	}
}


- (void)numericButtons {

	if (!self.isNumericCharacter) {
		self.currentTiles1 = self.numericTiles1;
		self.currentTiles2 = self.numericTiles2;
		self.currentTiles3 = self.numericTiles3;
	}
	else {
		self.currentTiles1 = self.alphaTiles1;
		self.currentTiles2 = self.alphaTiles2;
		self.currentTiles3 = self.alphaTiles3;
	}

	NSMutableArray *testHolder = @[].mutableCopy;
	[testHolder addObjectsFromArray:self.currentTiles1];
	[testHolder addObjectsFromArray:self.currentTiles2];
	[testHolder addObjectsFromArray:self.currentTiles3];


	for (uint n = 0; n < [self.alphaButtons count]; ++n) {

		[self.alphaButtons[n] setTitle:testHolder[n] forState:UIControlStateNormal];

	}

	[self.view layoutIfNeeded];
	self.isNumericCharacter = !self.isNumericCharacter;
}

- (void)specialButtons {

	if (!self.isSpecialCharacter) {
		self.currentTiles1 = self.specialTiles1;
		self.currentTiles2 = self.specialTiles2;
		self.currentTiles3 = self.specialTiles3;
	}
	else {
		self.currentTiles1 = self.numericTiles1;
		self.currentTiles2 = self.numericTiles2;
		self.currentTiles3 = self.numericTiles3;
	}

	NSMutableArray *testHolder = @[].mutableCopy;
	[testHolder addObjectsFromArray:self.currentTiles1];
	[testHolder addObjectsFromArray:self.currentTiles2];
	[testHolder addObjectsFromArray:self.currentTiles3];


	for (uint n = 0; n < [self.alphaButtons count]; ++n) {

		[self.alphaButtons[n] setTitle:testHolder[n] forState:UIControlStateNormal];

	}

	[self.view layoutIfNeeded];
	self.isSpecialCharacter = !self.isSpecialCharacter;
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
	[self.view layoutIfNeeded];
	self.isCapitalised = !self.isCapitalised;
}

#pragma mark Actions

- (void)textDidChange:(id <UITextInput>)textInput {

	NSLog(@"TextInputMode: %d", self.textDocumentProxy.keyboardType);

}

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

	NSDictionary *views = @{@"holder" : self.searchHolder, @"searchbar" : self.searchBar, @"gifButton" : self.gifButton};

	[inputView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[holder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

	[self.searchHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[searchbar]-10-[gifButton]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self.searchHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[searchbar(==30)]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self.searchHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[gifButton(==30)]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];


	[inputView addConstraint:[NSLayoutConstraint constraintWithItem:self.searchHolder attribute:NSLayoutAttributeTop
														  relatedBy:NSLayoutRelationEqual
															 toItem:inputView attribute:NSLayoutAttributeTop
														 multiplier:1.0 constant:0]];

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
															toItem:self.searchHolder attribute:NSLayoutAttributeBottom
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


- (MMkeyboardButton *)returnButtonLocation:(CGPoint)point {

	__block MMkeyboardButton *currentButton;

	[self.alphaButtons enumerateObjectsUsingBlock:^(MMkeyboardButton *button, NSUInteger idx, BOOL *stop) {

		if ([button.titleLabel.text isEqualToString:@"⇧"] || [button.titleLabel.text isEqualToString:@"⇪"] || [button.titleLabel.text isEqualToString:@"⌫"] || [button.titleLabel.text isEqualToString:@"#+="] || [button.titleLabel.text isEqualToString:@"?!@"]) {

		}
		else {

			CGRect buttonRect = CGRectMake(button.frame.origin.x, [button superview].frame.origin.y, button.frame.size.width, button.frame.size.height);
			if (CGRectContainsPoint(buttonRect, point)) {
				currentButton = button;
			}

		}
	}
	];

	if (currentButton) {
		return currentButton;
	}
	else {

		return nil;
	}
}


#pragma mark - Touch Actions

- (void)setupInputOptionsConfiguration {
	[self tearDownInputOptionsConfiguration];

	UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePanning:)];
	panGestureRecognizer.delegate = self;

	[self.view addGestureRecognizer:panGestureRecognizer];
	self.panGestureRecognizer = panGestureRecognizer;
}

- (void)tearDownInputOptionsConfiguration {
	[self.view removeGestureRecognizer:self.optionsViewRecognizer];
	[self.view removeGestureRecognizer:self.panGestureRecognizer];
}


- (void)_handlePanning:(UIPanGestureRecognizer *)recognizer {
	if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {

		if (self.panningButton) {

			[self didTapButton:self.panningButton];
		}
		[self hideInputView];
	}
	else {
		CGPoint location = [recognizer locationInView:self.view];
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
//	self.buttonView.layer.zPosition = 1;
	[self.view addSubview:self.buttonView];

	UITextView *text = [[UITextView alloc] init];
	text.translatesAutoresizingMaskIntoConstraints = NO;
	[text setText:sender.titleLabel.text];
	text.layer.cornerRadius = 4;
//	text.scrollIndicatorInsets.top == 0;
	text.textContainerInset = UIEdgeInsetsZero;
	text.textContainer.lineFragmentPadding = 0;
	text.textAlignment = NSTextAlignmentCenter;
	[text setFont:[UIFont boldSystemFontOfSize:30]];
	text.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
	[self.buttonView addSubview:text];


	NSDictionary *metrics = @{};
	NSDictionary *views = @{@"buttonView" : self.buttonView, @"text" : text};


	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:2.0 constant:(CGFloat) (sender.frame.size.height * 2.4)]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:2.0 constant:(CGFloat) (sender.frame.size.width * 1.3)]];
	NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.buttonView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:sender attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
	bottomConstraint.priority = 800;
	[self.view addConstraint:bottomConstraint];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:sender attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
	[self.buttonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[text]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.buttonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[text]-(0)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

}

#pragma mark UI

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
	[self.view setNeedsDisplay];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return (gestureRecognizer == _panGestureRecognizer || gestureRecognizer == _optionsViewRecognizer) &&
			(otherGestureRecognizer == _panGestureRecognizer || otherGestureRecognizer == _optionsViewRecognizer);
}

#pragma mark - Touch Actions

- (void)handleTouchDown:(MMkeyboardButton *)sender {
	[[UIDevice currentDevice] playInputClick];

	[self showInputView:sender];
}

- (void)handleTouchUpInside:(MMkeyboardButton *)sender {

	[self didTapButton:sender];
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


#pragma mark Textdoucmentproxy

- (NSString *)documentContextBeforeInput {
	return nil;
}

- (NSString *)documentContextAfterInput {
	return nil;
}

- (void)adjustTextPositionByCharacterOffset:(NSInteger)offset {

}

- (BOOL)hasText {
	return NO;
}

- (void)insertText:(NSString *)text {

}

- (void)deleteBackward {

}


@end
