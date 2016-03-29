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

@interface MMAlphaKeyboardView () <UITextDocumentProxy, UIGestureRecognizerDelegate, UITextFieldDelegate>


// Views
@property(nonatomic, strong) UIView *rowView1;
@property(nonatomic, strong) UIView *rowView2;
@property(nonatomic, strong) UIView *rowView3;
@property(nonatomic, strong) UIView *rowView4;
@property(nonatomic, strong) UIView *searchHolder;
@property(nonatomic, strong) UIView *buttonView;

@property(nonatomic, strong) MMkeyboardButton *gifButton;
@property(nonatomic, strong) MMkeyboardButton *changeButton;
@property(nonatomic, strong) MMkeyboardButton *spaceButton;
@property(nonatomic, strong) MMkeyboardButton *returnButton;

// Variables
@property(nonatomic, strong) NSArray *buttonTiles1;
@property(nonatomic, strong) NSArray *buttonTiles2;
@property(nonatomic, strong) NSArray *buttonTiles3;
@property(nonatomic, strong) NSArray *buttonTiles4;

@property(nonatomic, strong) NSMutableArray<MMkeyboardButton *> *buttons;
@property(nonatomic, strong) NSMutableArray<MMkeyboardButton *> *alphaButtons;

@property(nonatomic, assign) BOOL isCapitalised;
@property(nonatomic, strong) UITextField *searchBar;

@property(nonatomic, strong) UILongPressGestureRecognizer *optionsViewRecognizer;
@property(nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end


@implementation MMAlphaKeyboardView

- (instancetype)init {
	self = [super init];
	if (self) {

		self.buttonTiles1 = @[@"q", @"w", @"e", @"r", @"t", @"y", @"u", @"i", @"o", @"p"];
		self.buttonTiles2 = @[@"a", @"s", @"d", @"f", @"g", @"h", @"j", @"k", @"l"];
		self.buttonTiles3 = @[@"⇧", @"z", @"x", @"c", @"v", @"b", @"n", @"m", @"⌫"];
		[self setup];
	}

	return self;
}


- (void)setup {

	self.isCapitalised = NO;
	self.alphaButtons = @[].mutableCopy;

	self.rowView1 = [self createRowOfButtonWithTitle:self.buttonTiles1];
	self.rowView2 = [self createRowOfButtonWithTitle:self.buttonTiles2];
	self.rowView3 = [self createRowOfButtonWithTitle:self.buttonTiles3];
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
//	self.searchHolder.backgroundColor = [UIColor darkGrayColor];
	[self.view addSubview:self.searchHolder];

	self.searchBar = [[UITextField alloc] init];
	self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
	self.searchBar.backgroundColor = [UIColor whiteColor];
	[self.searchBar setPlaceholder:@"   Search for a GIF"];
	self.searchBar.delegate = self;
	self.searchBar.layer.cornerRadius = 10;
	self.searchBar.clipsToBounds = YES;
	[self.searchHolder addSubview:self.searchBar];


	self.view.userInteractionEnabled = YES;

	[self addConstraintsToInputViews:self.view WithRowViews:@[self.rowView1, self.rowView2, self.rowView3, self.rowView4]];
	[self setupInputOptionsConfiguration];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

}

- (UIView *)createFinalRow {

	UIView *holder = [UIView new];
//	holder.backgroundColor = [UIColor whiteColor];
	holder.translatesAutoresizingMaskIntoConstraints = NO;


	MMkeyboardButton *nextKeyboardButton = [MMkeyboardButton buttonWithType:UIButtonTypeSystem];
	nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
	[nextKeyboardButton setImage:[UIImage imageNamed:@"NextKeyboardIcon"] forState:UIControlStateNormal];
	[nextKeyboardButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
	[nextKeyboardButton setImageEdgeInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
	[nextKeyboardButton setTintColor:[UIColor whiteColor]];
	[holder addSubview:nextKeyboardButton];

	self.changeButton = [MMkeyboardButton buttonWithType:UIButtonTypeCustom];
	self.changeButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.changeButton.clipsToBounds = YES;
//	[self.changeButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
	[holder addSubview:self.changeButton];

	self.gifButton = [MMkeyboardButton buttonWithType:UIButtonTypeCustom];
	self.gifButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.gifButton.clipsToBounds = YES;
	[self.gifButton setTitle:@"GIF" forState:UIControlStateNormal];
	[self.gifButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//	[self.gifButton addTarget:self action:@selector(allGifsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[holder addSubview:self.gifButton];

	self.spaceButton = [MMkeyboardButton buttonWithType:UIButtonTypeCustom];
	self.spaceButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.spaceButton.clipsToBounds = YES;
	[self.spaceButton setContentEdgeInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
	[self.spaceButton setTitle:@"space" forState:UIControlStateNormal];
	[self.spaceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[holder addSubview:self.spaceButton];

	self.returnButton = [MMkeyboardButton buttonWithType:UIButtonTypeCustom];
	self.returnButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.returnButton.clipsToBounds = YES;
	[self.returnButton setTitle:@"⏎" forState:UIControlStateNormal];
	[self.returnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[holder addSubview:self.returnButton];


	NSDictionary *views = @{@"gifButton" : self.gifButton, @"changeButton" : nextKeyboardButton, @"spaceButton" : self.spaceButton, @"returnButton" : self.returnButton};
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[gifButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[spaceButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[changeButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[returnButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-1-[changeButton(==gifButton)]-1-[gifButton(==50)]-1-[spaceButton]-1-[returnButton(70)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	return holder;


}


- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];

	for (MMkeyboardButton *button in self.rowView1.subviews)
	{
		[self.alphaButtons addObject:button];
        NSLog(@"%@", button.titleLabel.text);
	}
	for (MMkeyboardButton *button in self.rowView2.subviews)
	{
		[self.alphaButtons addObject:button];
        NSLog(@"%@", button.titleLabel.text);
	}
	for (MMkeyboardButton *button in self.rowView3.subviews)
	{
		[self.alphaButtons addObject:button];
        NSLog(@"%@", button.titleLabel.text);
	}
//	for (MMkeyboardButton *button in self.rowView2.subviews)
//	{
//		[self.alphaButtons addObject:button];
//	}
//	for (MMkeyboardButton *button in self.rowView3.subviews)
//	{
//		[self.alphaButtons addObject:button];
//	}

}


- (UIView *)createRowOfButtonWithTitle:(NSArray *)titles {

	self.buttons = @[].mutableCopy;
	UIView *view = [UIView new];

	[titles enumerateObjectsUsingBlock:^(NSString *titleString, NSUInteger idx, BOOL *stop) {
		if (titleString) {

			MMkeyboardButton *button = [self createButtonWithTitle:titleString];
			[self.buttons addObject:button];
			[view addSubview:button];

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
//	[button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
	[button addTarget:self action:@selector(handleTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
	[button addTarget:self action:@selector(handleTouchDown:) forControlEvents:UIControlEventTouchDown];

	return button;

}


- (void)didTapButton:(MMkeyboardButton *)sender {

	MMkeyboardButton *button = sender;
	NSString *title = [button titleForState:UIControlStateNormal];
	NSLog(@"%@", title);

	if ([title isEqualToString:@"⌫"]) {
		[self.textDocumentProxy deleteBackward];
	}
	else if ([title isEqualToString:@"RETURN"]) {
		[self.textDocumentProxy insertText:@"\n"];
	}
	else if ([title isEqualToString:@"SPACE"]) {
		[self.textDocumentProxy insertText:@" "];
	}
	else if ([title isEqualToString:@"CHG"]) {
		[self advanceToNextInputMode];
	}
	else if ([title isEqualToString:@"GIF"]) {
		[self advanceToNextInputMode];
	}
	else if ([title isEqualToString:@"⇧"]) {
		[self capataliseButtons];
	}
	else if ([title isEqualToString:@"⇪"]) {
		[self capataliseButtons];
	}
	else {
		[self.textDocumentProxy insertText:title];
//		[self addPopupToButton:sender];
	}
}

- (void)capataliseButtons {

	[self.alphaButtons enumerateObjectsUsingBlock:^(MMkeyboardButton *obj, NSUInteger idx, BOOL *stop) {
		NSString *title = [obj titleForState:UIControlStateNormal];
		NSLog(@"%@", title);
		if ([title isEqualToString:@"BP"] || [title isEqualToString:@"CP"] || [title isEqualToString:@"CHG"] || [title isEqualToString:@"SPACE"] || [title isEqualToString:@"RETURN"] || [title isEqualToString:@"GIF"]) {

		}

		else {
			if (!self.isCapitalised) {
				if ([title isEqualToString:@"⇧"]) {
					NSLog(@"cap");
					[obj setTitle:@"⇪" forState:UIControlStateNormal];

				}
				else {

					[obj setTitle:title.uppercaseString forState:UIControlStateNormal];

				}
			}
			else {
				if ([title isEqualToString:@"⇪"]) {
					NSLog(@"not");
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

	NSDictionary *views = @{@"holder" : self.searchHolder, @"searchbar" : self.searchBar};

	[inputView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[holder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

	[self.searchHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[searchbar]-60-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self.searchHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[searchbar]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

	[inputView addConstraint:[NSLayoutConstraint constraintWithItem:self.searchHolder attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:inputView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
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



//		if ([obj isKindOfClass:[MMkeyboardButton class]])
//		{
//			NSLog(@"objeects%@", obj);
//
//		}
	}];

}

//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//	[super touchesMoved:touches withEvent:event];
//
//	[self hideInputView];
//
//}

#pragma mark - Touch Actions

- (void)setupInputOptionsConfiguration {
	[self tearDownInputOptionsConfiguration];

	UILongPressGestureRecognizer *longPressGestureRecognizer =
			[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showExpandedInputView:)];
	longPressGestureRecognizer.minimumPressDuration = 0.3;
	longPressGestureRecognizer.delegate = self;

	[self.view addGestureRecognizer:longPressGestureRecognizer];
	self.optionsViewRecognizer = longPressGestureRecognizer;


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

//		CGPoint location = [recognizer locationInView:self.view];
//		NSLog(@"location%@",location);
//		[self addPopupToButton:self.alphaButtons[location];

//		if (self.expandedButtonView.selectedInputIndex != NSNotFound) {
//			NSString *inputOption = self.inputOptions[self.expandedButtonView.selectedInputIndex];
//
//			[self insertText:inputOption];
//		}
//
//		[self hideExpandedInputView];
	}
	else {
		CGPoint location = [recognizer locationInView:self.view];
		MMkeyboardButton *button = [self returnButtonLoation:location];
		if (button) {

			[self showInputView:button];
		}
		else {

			[self hideInputView];
		}
//		[self updateSelectedInputIndexForPoint:location];
//	};
	}
}

- (MMkeyboardButton *)returnButtonLoation:(CGPoint)point {

	__block MMkeyboardButton *button;
	NSLog(@"entered here");

	[self.alphaButtons enumerateObjectsUsingBlock:^(MMkeyboardButton * obj, NSUInteger idx, BOOL *stop) {
        
    
//			NSLog(@"came here %f and %f", obj.frame.origin.x,obj.frame.origin.y);
//
		if (CGRectContainsPoint(obj.frame, point))
		{
			button = obj;
		}

	}];
	if (button) {
		return button;
	}
	else {

		return nil;
	}

}

#pragma mark keyboard popup

- (void)addPopupToButton:(UIButton *)sender {

	self.buttonView = [UIView new];
	self.buttonView.translatesAutoresizingMaskIntoConstraints = NO;
	[sender addSubview:self.buttonView];

	UILabel *text = [[UILabel alloc] init];
	text.translatesAutoresizingMaskIntoConstraints = NO;
	[text setText:sender.titleLabel.text];
	text.textAlignment = NSTextAlignmentCenter;
	[text setFont:[UIFont boldSystemFontOfSize:16]];
	text.backgroundColor = [UIColor whiteColor];
	[self.buttonView addSubview:text];


	NSDictionary *metrics = @{};
	NSDictionary *views = @{@"buttonView" : self.buttonView, @"text" : text};


	[sender addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[buttonView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[sender addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[buttonView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	[self.buttonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[text]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.buttonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[text]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

}


#pragma mark UI

- (void)showInputView:(UIButton *)sender {
	[self hideInputView];
	[self addPopupToButton:sender];
//	UIView *view = [self addPopupToButton:sender];
//	view.translatesAutoresizingMaskIntoConstraints = NO;
//	[sender addSubview:view];
//
//	[sender addConstraint:[NSLayoutConstraint constraintWithItem:sender attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];

}

- (void)showExpandedInputView:(UILongPressGestureRecognizer *)recognizer {
	if (recognizer.state == UIGestureRecognizerStateBegan) {
		if (self.buttonView == nil) {
//			[self addPopupToButton:self];

//			CYRKeyboardButtonView *expandedButtonView = [[CYRKeyboardButtonView alloc] initWithKeyboardButton:self type:CYRKeyboardButtonViewTypeExpanded];
//
//			[self.window addSubview:expandedButtonView];
//			self.expandedButtonView = expandedButtonView;
//
//			[[NSNotificationCenter defaultCenter] postNotificationName:CYRKeyboardButtonDidShowExpandedInputNotification object:self];

			[self hideInputView];
		}
	} else if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded) {
		if (self.panGestureRecognizer.state != UIGestureRecognizerStateRecognized) {
			[self handleTouchUpInside];
		}
	}
}


- (void)hideInputView {
	[self.buttonView removeFromSuperview];
	self.buttonView = nil;

	[self.view setNeedsDisplay];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	// Only allow simulateous recognition with our internal recognizers
	return (gestureRecognizer == _panGestureRecognizer || gestureRecognizer == _optionsViewRecognizer) &&
			(otherGestureRecognizer == _panGestureRecognizer || otherGestureRecognizer == _optionsViewRecognizer);
}

#pragma mark - Touch Actions

- (void)handleTouchDown:(UIButton *)sender {
	[[UIDevice currentDevice] playInputClick];
	NSLog(@"touching %f %f", sender.frame.origin.x, sender.frame.origin.y);
	[self showInputView:sender];
}

- (void)handleTouchUpInside {
//	[self insertText:self.input];

	[self hideInputView];
//	[self hideExpandedInputView];
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


#pragma mark textdoucmentproxy

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
