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
@property(nonatomic, strong) UIButton *gifButton;
@property(nonatomic, strong) UIButton *changeButton;
@property(nonatomic, strong) UIButton *spaceButton;
@property(nonatomic, strong) UIButton *returnButton;

// Variables
@property(nonatomic, strong) NSArray *buttonTiles1;
@property(nonatomic, strong) NSArray *buttonTiles2;
@property(nonatomic, strong) NSArray *buttonTiles3;
@property(nonatomic, strong) NSArray *buttonTiles4;
@property(nonatomic, strong) NSMutableArray<MMkeyboardButton *> *buttons;
@property(nonatomic, strong) NSMutableArray<MMkeyboardButton *> *alphaButtons;
@property(nonatomic, assign) BOOL isCapitalised;
//@property(nonatomic, assign) CGRect keyboardFrame;
@property(nonatomic, strong) UITextField *searchBar;
@end


@implementation MMAlphaKeyboardView

- (instancetype)init {
	self = [super init];
	if (self) {

		self.buttonTiles1 = @[@"q", @"w", @"e", @"r", @"t", @"y", @"u", @"i", @"o", @"p"];
		self.buttonTiles2 = @[@"a", @"s", @"d", @"f", @"g", @"h", @"j", @"k", @"l"];
		self.buttonTiles3 = @[@"CP", @"z", @"x", @"c", @"v", @"b", @"n", @"m", @"BP"];
		self.buttonTiles4 = @[@"GIF", @"CHG", @"SPACE", @"RETURN"];
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



//	self.rowView4 = [UIView new];



	[self.view addSubview:self.rowView1];
	[self.view addSubview:self.rowView2];
	[self.view addSubview:self.rowView3];
	[self.view addSubview:self.rowView4];

	self.rowView1.translatesAutoresizingMaskIntoConstraints = NO;
	self.rowView2.translatesAutoresizingMaskIntoConstraints = NO;
	self.rowView3.translatesAutoresizingMaskIntoConstraints = NO;
	self.rowView4.translatesAutoresizingMaskIntoConstraints = NO;

	self.keyboardImageView = [UIImageView new];
	self.keyboardImageView.translatesAutoresizingMaskIntoConstraints = NO;
	self.keyboardImage = [UIImage imageNamed:@"NextKeyboardIcon"];
	self.keyboardImageView.image = [self.keyboardImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[self.keyboardImageView setTintColor:[UIColor whiteColor]];
	[self.keyboardImageView setContentMode:UIViewContentModeScaleAspectFill];


	self.searchHolder = [UIView new];
	self.searchHolder.translatesAutoresizingMaskIntoConstraints = NO;
	self.searchHolder.backgroundColor = [UIColor blackColor];
	[self.view addSubview:self.searchHolder];

	self.searchBar = [[UITextField alloc] init];
	self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
	self.searchBar.backgroundColor = [UIColor whiteColor];
	[self.searchBar setPlaceholder:@"   Search for a GIF"];
	self.searchBar.delegate = self;
	self.searchBar.layer.cornerRadius = 10;
	self.searchBar.clipsToBounds = YES;
	[self.searchHolder addSubview:self.searchBar];


//	[self.view addSubview:keyboardImage];


	self.view.userInteractionEnabled = YES;
	[self addConstraintsToInputViews:self.view WithRowViews:@[self.rowView1, self.rowView2, self.rowView3, self.rowView4]];

}

- (void)textFieldDidEndEditing:(UITextField *)textField {

}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];

//	[self.buttons[1] setImage:self.keyboardImage forState:UIControlStateNormal];
//	[self.buttons[1] setFrame:CGRectMake(0, 0, 6, 20)];
//	self.buttons[1].imageView.contentMode = UIViewContentModeScaleAspectFill;
//	[self.buttons[1].imageView setTintColor:[UIColor whiteColor]];
//	self.buttons[1].clipsToBounds = YES;


}

- (UIView *)createFinalRow
{
	UIView *holder = [UIView new];
	holder.backgroundColor = [UIColor whiteColor];
	holder.translatesAutoresizingMaskIntoConstraints = NO;

	UIImageView *keyboardImage = [UIImageView new];
	keyboardImage.translatesAutoresizingMaskIntoConstraints = NO;
	UIImage *image = [UIImage imageNamed:@"NextKeyboardIcon"];
	keyboardImage.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[keyboardImage setTintColor:[UIColor whiteColor]];
	keyboardImage.backgroundColor = [UIColor blackColor];
	[keyboardImage setContentMode:UIViewContentModeScaleAspectFit];
//	[keyboardImage setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisVertical];
//	[keyboardImage setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisHorizontal];
	[holder addSubview:keyboardImage];

	self.changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.changeButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.changeButton.backgroundColor = [UIColor blackColor];
	self.changeButton.clipsToBounds = YES;
//	[self.changeButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
	[holder addSubview:self.changeButton];

	self.gifButton = [UIButton buttonWithType:UIButtonTypeSystem];
	self.gifButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.gifButton.clipsToBounds = YES;
	self.gifButton.backgroundColor = [UIColor blackColor];
	[self.gifButton setTitle:@"GIF" forState:UIControlStateNormal];
	[self.gifButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//	[self.gifButton addTarget:self action:@selector(allGifsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[holder addSubview:self.gifButton];

	self.spaceButton = [UIButton buttonWithType:UIButtonTypeSystem];
	self.spaceButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.spaceButton.clipsToBounds = YES;
	self.spaceButton.backgroundColor = [UIColor blackColor];
	[self.spaceButton setContentEdgeInsets:UIEdgeInsetsMake(1,1,1,1)];
	[self.spaceButton setTitle:@"space" forState:UIControlStateNormal];
	[self.spaceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[holder addSubview:self.spaceButton];

	UIImageView *backspaceImage = [UIImageView new];
	UIImage *backImage = [UIImage imageNamed:@"backspaceIcon.png"];
	backspaceImage.image = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[backspaceImage setTintColor:[UIColor whiteColor]];
	backspaceImage.backgroundColor = [UIColor blackColor];
	backspaceImage.translatesAutoresizingMaskIntoConstraints = NO;
	[backspaceImage setContentMode:UIViewContentModeScaleAspectFit];
//	[backspaceImage setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisVertical];
//	[backspaceImage setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisHorizontal];
	backspaceImage.clipsToBounds = YES;
	[holder addSubview:backspaceImage];

	UIButton *backspaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
	backspaceButton.clipsToBounds = YES;
	backspaceButton.translatesAutoresizingMaskIntoConstraints = NO;
	[backspaceButton setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisVertical];
	[holder addSubview:backspaceButton];

	NSDictionary *views = @{@"gifButton": self.gifButton, @"changeButton": keyboardImage, @"spaceButton": self.spaceButton, @"backspaceImage": backspaceImage};
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[gifButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[spaceButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[changeButton]-1-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[backspaceImage]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-1-[changeButton(==backspaceImage)]-1-[gifButton(==backspaceImage)]-1-[spaceButton]-1-[backspaceImage(==50)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	return holder;



}
- (UIView *)createRowOfButtonWithTitle:(NSArray *)titles {

	self.buttons = @[].mutableCopy;
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
	for (NSString *string in titles) {
		MMkeyboardButton *button = [self createButtonWithTitle:string];
		[self.alphaButtons addObject:button];
		[self.buttons addObject:button];
		[view addSubview:button];
	}
	[self addIndividualButtonConstraints:self.buttons WithMainView:view];
	return view;
}

- (MMkeyboardButton *)createButtonWithTitle:(NSString *)title {

	MMkeyboardButton *button = [MMkeyboardButton buttonWithType:UIButtonTypeCustom];
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
	NSLog(@"%@", title);

	if ([title isEqualToString:@"BP"]) {
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
	else if ([title isEqualToString:@"CP"]) {
		[self capataliseButtons];
	}
	else {
		[self.textDocumentProxy insertText:title];
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
				[obj setTitle:title.uppercaseString forState:UIControlStateNormal];
			}
			else {
				[obj setTitle:title.lowercaseString forState:UIControlStateNormal];

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
			if ([button.titleLabel.text isEqualToString:@"SPACE"]) {
				MMkeyboardButton *firstButton = buttons[0];
				widthConstraint = [NSLayoutConstraint constraintWithItem:firstButton attribute:NSLayoutAttributeWidth
															   relatedBy:NSLayoutRelationEqual toItem:button
															   attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-140];
			}
//				else if ([button.titleLabel.text isEqualToString:@"SPACE"], [button.titleLabel.text isEqualToString:@"RETURN"])
//			{
//				MMkeyboardButton *firstButton = buttons[2];
//				widthConstraint = [NSLayoutConstraint constraintWithItem:firstButton attribute:NSLayoutAttributeWidth
//															   relatedBy:NSLayoutRelationEqual toItem:button
//															   attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-20];
//			}
			else {


				MMkeyboardButton *firstButton = buttons[0];
				widthConstraint = [NSLayoutConstraint constraintWithItem:firstButton attribute:NSLayoutAttributeWidth
															   relatedBy:NSLayoutRelationEqual toItem:button
															   attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
			}

			widthConstraint.priority = 800;
			[mainView addConstraint:widthConstraint];
		}

		[mainView addConstraints:@[topConstraint, bottomConstraint, rightConstraint, leftConstraint]];
	}];

}


- (void)addConstraintsToInputViews:(UIView *)inputView WithRowViews:(NSArray *)rowViews {

	NSDictionary *views = @{@"holder" : self.searchHolder, @"searchbar" : self.searchBar};

	[inputView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[holder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self.searchHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[searchbar]-60-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
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
														multiplier:1.0 constant:0];

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
