//
// Created by Tom Atterton on 07/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "PopupButtonView.h"
#import "MMkeyboardButton.h"
#import "keyboardKeysModel.h"
#import "PopupView.h"

@interface PopupButtonView () <UIGestureRecognizerDelegate>

// Views
@property(nonatomic, strong) MMkeyboardButton *button;
// Variables
@property(nonatomic, assign) popUpStyle popUpStyle;
@property(nonatomic, strong) keyboardKeysModel *keyboardKeysModel;
@property(nonatomic, strong) UIView *rowView;

@end

@implementation PopupButtonView

- (instancetype)initWithButton:(MMkeyboardButton *)button WithPopupStyle:(popUpStyle)popUpStyle1 {

	self = [super init];

	if (self) {

		UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
		tapGestureRecognizer.delegate = self;
		tapGestureRecognizer.delaysTouchesBegan = YES;
		[self addGestureRecognizer:tapGestureRecognizer];
		self.button = button;
		self.popUpStyle = popUpStyle1;
		self.keyboardKeysModel = [keyboardKeysModel new];
		self.backgroundColor = [UIColor clearColor];
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

//			NSLayoutConstraint *topConstriaint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.rowView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
//			NSLayoutConstraint *bottomConstriaint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.rowView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
//
////			NSLayoutConstraint *widthConstriaint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.rowView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
//			NSLayoutConstraint *heightConstriaint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.rowView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
//
//	NSLayoutConstraint *rightConstriaint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.rowView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
//	NSLayoutConstraint *rightConstriaint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.rowView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];


//			[self multiplePopup:self.rowView];
//			for (PopupView *view in self.rowView.subviews)
//			{
//
//				NSLog(@"%@", view.titleLabel);
//
//			}
			break;
		}
	}


}

- (void)multiplePopup {


	NSArray *multipleButtons = [self.keyboardKeysModel specialCharactersWithLetter:self.button.titleLabel.text];

	if (multipleButtons.count >= 1) {


		PopupView *view = [[PopupView alloc] initWithTitle:self.button.titleLabel.text];
		view.translatesAutoresizingMaskIntoConstraints = NO;
		[view setBackgroundColor:[UIColor clearColor]];
		[view setBackgroundColor:[UIColor whiteColor]];
		[self addSubview:view];

		self.rowView = [self createViewWithArray:multipleButtons];
		self.rowView.translatesAutoresizingMaskIntoConstraints = NO;
		self.rowView.backgroundColor = [UIColor clearColor];
		[self addSubview:self.rowView];


		NSDictionary *metrics = @{};
		NSDictionary *views = @{@"view" : view, @"rowView" : self.rowView};


		if (self.button.frame.origin.x > 125) {

			[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[rowView]-0-[view(==30)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		}
		else {

			[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view(==30)]-0-[rowView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		}

		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

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
	[popupView setBackgroundColor:[UIColor whiteColor]];
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
//			[mainView addConstraint:widthConstraint];
		}

		[mainView addConstraints:@[topConstraint, bottomConstraint, leftConstraint, widthConstraint]];


	}];

}


#pragma mark Touch Gestures

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {

	UIView *view = sender.view;
	CGPoint loc = [sender locationInView:view];
	UIView *subview = [view hitTest:loc withEvent:nil];

	NSLog(@"%@", subview);


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

@end