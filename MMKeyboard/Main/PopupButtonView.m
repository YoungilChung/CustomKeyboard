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

@end

@implementation PopupButtonView

- (instancetype)initWithButton:(MMkeyboardButton *)button WithPopupStyle:(popUpStyle)popUpStyle1 {

	self = [super init];

	if (self) {

		self.button = button;
		self.popUpStyle = popUpStyle1;
		self.keyboardKeysModel = [keyboardKeysModel new];
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

	self.rowView = [self createViewWithArray:multipleButtons];
	self.rowView.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.rowView];

	self.rowView.backgroundColor = [UIColor redColor];
	NSDictionary *metrics = @{};
	NSDictionary *views = @{@"rowView" : self.rowView};

//	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[rowView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[rowView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	NSLayoutConstraint *leftConstriaint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.rowView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
	NSLayoutConstraint *rightConstriaint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.rowView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
	NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth
																	   relatedBy:NSLayoutRelationEqual toItem:self.rowView
																	   attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
	[widthConstraint setPriority:800];
	[self addConstraints:@[leftConstriaint, rightConstriaint, widthConstraint]];


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


//- (void)multiplePopup:(UIView *)popUpView {
//
////	popUpView.translatesAutoresizingMaskIntoConstraints = NO;
////	popUpView.clipsToBounds = YES;
////	[self addSubview:popUpView];
//
//
//	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[rowView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
//	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[rowView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
//}


- (UIView *)createViewWithArray:(NSArray *)buttonArray {
	NSMutableArray *viewHolder = @[].mutableCopy;
	UIView *view = [UIView new];
	[buttonArray enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL *stop) {

		if (string) {
			PopupView *popupView = [self createView:string];
			popupView.backgroundColor = [UIColor redColor];
			
			[viewHolder addObject:view];

			if (buttonArray.count > 0) {

				[view addSubview:popupView];
			}

		}

	}];

	[self addIndividualConstraintsToViews:viewHolder WithView:view];

	return view;
}

- (PopupView *)createView:(NSString *)titile {
	PopupView *popupView = [[PopupView alloc] initWithTitle:titile];
	popupView.translatesAutoresizingMaskIntoConstraints = NO;
	popupView.clipsToBounds = YES;

	return popupView;

}

- (void)addIndividualConstraintsToViews:(NSArray *)viewHolder WithView:(UIView *)mainView {


	[viewHolder enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
		NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop
																		 relatedBy:NSLayoutRelationEqual
																			toItem:mainView attribute:NSLayoutAttributeTop
																		multiplier:1.0 constant:0];

		NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom
																			relatedBy:NSLayoutRelationEqual
																			   toItem:mainView attribute:NSLayoutAttributeBottom
																		   multiplier:1.0 constant:0];

		NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight
																			relatedBy:NSLayoutRelationEqual
																			   toItem:mainView attribute:NSLayoutAttributeHeight
																		   multiplier:1.0 constant:0];


		NSLayoutConstraint *rightConstraint;
		NSLayoutConstraint *leftConstraint;

		// LastView
		if (idx == viewHolder.count - 1) {
			rightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight
														   relatedBy:NSLayoutRelationEqual
															  toItem:mainView attribute:NSLayoutAttributeRight
														  multiplier:1.0 constant:0];

		}

		else {
			UIView *nextView = viewHolder[idx + 1];
			rightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight
														   relatedBy:NSLayoutRelationEqual
															  toItem:nextView attribute:NSLayoutAttributeLeft
														  multiplier:1.0 constant:0];


		}

		// First View
		if (idx == 0) {
			leftConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft
														  relatedBy:NSLayoutRelationEqual
															 toItem:mainView attribute:NSLayoutAttributeLeft
														 multiplier:1.0 constant:0];


		}


		else {
			UIView *prevView = viewHolder[idx - 1];
			leftConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft
														  relatedBy:NSLayoutRelationEqual
															 toItem:prevView attribute:NSLayoutAttributeRight
														 multiplier:1.0 constant:0];

			UIView *firstView = viewHolder[0];
			NSLayoutConstraint *widthConstraint;

			widthConstraint = [NSLayoutConstraint constraintWithItem:firstView attribute:NSLayoutAttributeWidth
														   relatedBy:NSLayoutRelationEqual toItem:view
														   attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];

			widthConstraint.priority = 800;
			[mainView addConstraint:widthConstraint];
		}

		[mainView addConstraints:@[topConstraint, bottomConstraint, rightConstraint, leftConstraint, heightConstraint]];


	}];


}


@end