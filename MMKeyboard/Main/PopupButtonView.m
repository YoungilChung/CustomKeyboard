//
// Created by Tom Atterton on 07/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "PopupButtonView.h"
#import "MMkeyboardButton.h"
#import "keyboardKeysModel.h"
#import "PopupView.h"

@interface PopupButtonView ()

// Views
@property(nonatomic, strong) MMkeyboardButton *button;
// Variables
@property(nonatomic, assign) popUpStyle popUpStyle;
@property(nonatomic, strong) keyboardKeysModel *keyboardKeysModel;
@property(nonatomic, strong) UIView *rowView;

@property(nonatomic, strong) PopupView *popupView;
@end

@implementation PopupButtonView

- (instancetype)initWithButton:(MMkeyboardButton *)button WithPopupStyle:(popUpStyle)popUpStyle1 {

	self = [super init];

	if (self) {

		self.button = button;
		self.popUpStyle = popUpStyle1;
		self.keyboardKeysModel = [keyboardKeysModel new];
		self.backgroundColor = [UIColor groupTableViewBackgroundColor];
		self.translatesAutoresizingMaskIntoConstraints = NO;
		[self setup];

	}

	return self;
}

- (void)setup {


	switch (self.popUpStyle) {

		case kpopUpStyleSingle: {

			[self singlePopup];
			break;
		}

		case kpopUpStyleMultiple: {

			[self multiplePopup];

			break;
		}
	}


}

- (void)multiplePopup {


	NSArray *multipleButtons = [self.keyboardKeysModel specialCharactersWithLetter:self.button.titleLabel.text];

	if (multipleButtons.count >= 1) {


		self.popupView = [[PopupView alloc] initWithTitle:self.button.titleLabel.text];
		self.popupView.translatesAutoresizingMaskIntoConstraints = NO;
		[self.popupView setBackgroundColor:[UIColor clearColor]];
		[self addSubview:self.popupView];

		self.rowView = [self createViewWithArray:multipleButtons];
		self.rowView.translatesAutoresizingMaskIntoConstraints = NO;
		self.rowView.layer.cornerRadius = 4;
		self.rowView.backgroundColor = [UIColor clearColor];
		[self addSubview:self.rowView];


		NSDictionary *metrics = @{};
		NSDictionary *views = @{@"popupView" : self.popupView, @"rowView" : self.rowView};


		if (self.button.frame.origin.x > 125) {

			[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[rowView]-0-[popupView(==30)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		}
		else {

			[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[popupView(==30)]-0-[rowView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		}

		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[popupView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

		NSLayoutConstraint *leftConstriaint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.rowView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
		NSLayoutConstraint *heightConstriaint = [NSLayoutConstraint constraintWithItem:self.rowView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:40];
		NSLayoutConstraint *bottomConstriaint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.rowView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];

		[self addConstraints:@[leftConstriaint, heightConstriaint, bottomConstriaint]];

	}
	else {
		[self singlePopup];

	}
}

- (void)singlePopup {

	PopupView *view = [[PopupView alloc] initWithTitle:self.button.titleLabel.text];
	view.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:view];

	NSDictionary *metrics = @{};
	NSDictionary *views = @{@"view" : view};
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-(0)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

}


- (UIView *)createViewWithArray:(NSArray *)buttonArray {
	NSMutableArray *viewHolder = @[].mutableCopy;
	UIView *view = [UIView new];
	[view setBackgroundColor:[UIColor clearColor]];
	[buttonArray enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL *stop) {

		if (string) {
			PopupView *popupView = [self createView:string];

			[viewHolder addObject:popupView];

			if (buttonArray.count > 0) {

				[view addSubview:popupView];
			}

		}

	}];


	[self addIndividualConstraintsToViews:viewHolder WithView:view];


	return view;
}

- (PopupView *)createView:(NSString *)title {
	PopupView *popupView = [[PopupView alloc] initWithTitle:title];
	popupView.translatesAutoresizingMaskIntoConstraints = NO;
	[popupView setBackgroundColor:[UIColor clearColor]];
	return popupView;

}

- (void)addIndividualConstraintsToViews:(NSArray *)viewHolder WithView:(UIView *)mainView {

	[viewHolder enumerateObjectsUsingBlock:^(PopupView *popupView, NSUInteger idx, BOOL *stop) {

		NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:popupView attribute:NSLayoutAttributeTop
																		 relatedBy:NSLayoutRelationEqual
																			toItem:mainView attribute:NSLayoutAttributeTop
																		multiplier:1.0 constant:0];

		NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:popupView attribute:NSLayoutAttributeBottom
																			relatedBy:NSLayoutRelationEqual
																			   toItem:mainView attribute:NSLayoutAttributeBottom
																		   multiplier:1.0 constant:0];


		NSLayoutConstraint *rightConstraint;
		NSLayoutConstraint *leftConstraint;

		// LastView
		if (idx == viewHolder.count - 1) {

			rightConstraint = [NSLayoutConstraint constraintWithItem:popupView attribute:NSLayoutAttributeRight
														   relatedBy:NSLayoutRelationEqual
															  toItem:mainView attribute:NSLayoutAttributeRight
														  multiplier:1.0 constant:0];

			[mainView addConstraint:rightConstraint];

		}


		NSLayoutConstraint *widthConstraint;

		// First View
		if (idx == 0) {
			leftConstraint = [NSLayoutConstraint constraintWithItem:popupView attribute:NSLayoutAttributeLeft
														  relatedBy:NSLayoutRelationEqual
															 toItem:mainView attribute:NSLayoutAttributeLeft
														 multiplier:1.0 constant:0];

			widthConstraint = [NSLayoutConstraint constraintWithItem:popupView attribute:NSLayoutAttributeWidth
														   relatedBy:NSLayoutRelationEqual toItem:nil
														   attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30];


		}


		else {
			PopupView *prevView = viewHolder[idx - 1];
			leftConstraint = [NSLayoutConstraint constraintWithItem:popupView attribute:NSLayoutAttributeLeft
														  relatedBy:NSLayoutRelationEqual
															 toItem:prevView attribute:NSLayoutAttributeRight
														 multiplier:1.0 constant:0];

			PopupView *firstView = viewHolder[0];

			widthConstraint = [NSLayoutConstraint constraintWithItem:firstView attribute:NSLayoutAttributeWidth
														   relatedBy:NSLayoutRelationEqual toItem:popupView
														   attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];

			widthConstraint.priority = 800;
		}

		[mainView addConstraints:@[topConstraint, bottomConstraint, leftConstraint, widthConstraint]];


	}];

}


- (void)updatePosition:(CGPoint)position {

	CGPoint updatedPosition;
	if (self.button.frame.origin.x > 125) {
		updatedPosition = CGPointMake((position.x + self.frame.size.width) - self.button.frame.origin.x - self.button.frame.size.width, position.y);
	}
	else {

		updatedPosition = CGPointMake(position.x - self.button.frame.origin.x - self.button.frame.size.width, position.y);
	}

	[self containsPopupView:updatedPosition.x];

}


- (void)containsPopupView:(CGFloat)xOrigin {

	for (PopupView *popupView in self.rowView.subviews) {
		CGFloat popupViewOriginX = popupView.frame.origin.x;

		if (xOrigin < popupViewOriginX || xOrigin > popupViewOriginX + popupView.frame.size.width) {
			[popupView selectedPopupView:NO];
		}
		else {
			[popupView selectedPopupView:YES];
			self.selectedCharacter = popupView.titleLabel;

		}

		if (self.popupView) {

			if (self.button.frame.origin.x > 125) {
				if (xOrigin < self.popupView.frame.origin.x || xOrigin > self.popupView.frame.origin.x + self.button.frame.size.width) {

					[self.popupView selectedPopupView:NO];

				}
				else {
					self.selectedCharacter = self.button.titleLabel.text;;
					[self.popupView selectedPopupView:YES];
				}
			} else {

				if (xOrigin + self.popupView.frame.size.width < self.popupView.frame.origin.x || xOrigin > self.popupView.frame.origin.x) {

					[self.popupView selectedPopupView:NO];
				}

				else {
					self.selectedCharacter = self.button.titleLabel.text;
					[self.popupView selectedPopupView:YES];

				}


			}


		}
	}

}

@end