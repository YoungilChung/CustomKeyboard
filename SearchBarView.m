//
// Created by Tom Atterton on 31/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "SearchBarView.h"
#import "MMKeyboardButton.h"
#import "MMCustomTextField.h"
#import "KeyboardDelegate.h"
#import "MMGIFButton.h"


@interface SearchBarView () <UITextFieldDelegate>


@property(nonatomic, strong) UIView *caretView;
@end

@implementation SearchBarView

- (instancetype)init {
	self = [super init];
	if (self) {

		UILabel *magnifyingGlass = [[UILabel alloc] init];
		[magnifyingGlass setText:[[NSString alloc] initWithUTF8String:"\xF0\x9F\x94\x8D"]];
		[magnifyingGlass sizeToFit];

		self.translatesAutoresizingMaskIntoConstraints = NO;

		self.searchBar = [[MMCustomTextField alloc] init];
		self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
		self.searchBar.clipsToBounds = YES;
//		[self.searchBar setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];

		self.searchBar.backgroundColor = [UIColor whiteColor];
		[self.searchBar setPlaceholder:@"Search for a GIF"];
		[self.searchBar setFont:[UIFont fontWithName:@"Helvetica" size:16]];
		self.searchBar.layer.cornerRadius = 4;

		[self.searchBar setLeftView:magnifyingGlass];
		[self.searchBar setLeftViewMode:UITextFieldViewModeAlways];

		[self addSubview:self.searchBar];

		self.searchBar.isTextFieldSelected = NO;
		self.searchBar.delegate = self;

		self.gifButton = [MMGIFButton buttonWithType:UIButtonTypeSystem];
		self.gifButton.translatesAutoresizingMaskIntoConstraints = NO;
		[self.gifButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
		[self.gifButton setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
		[self.gifButton setContentCompressionResistancePriority:800 forAxis:UILayoutConstraintAxisHorizontal];
		[self.gifButton setTitle:@"GIF" forState:UIControlStateNormal];

		[self addSubview:self.gifButton];

		self.caretView = [UIView new];
		self.caretView.translatesAutoresizingMaskIntoConstraints = NO;
		[self.caretView setBackgroundColor:[UIColor blueColor]];
		[self.searchBar addSubview:self.caretView];
		self.caretView.alpha = 0;

		NSDictionary *views = @{@"searchBar" : self.searchBar, @"gifButton" : self.gifButton, @"caret" : self.caretView};
		NSDictionary *metrics = @{};

		self.shouldContinueBlinking = NO;


		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[searchBar]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.gifButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:5]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[searchBar]-5-[gifButton]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];


		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[caret]-6-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		self.leftCaretConstraint = [NSLayoutConstraint constraintWithItem:self.caretView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.searchBar attribute:NSLayoutAttributeLeft multiplier:1.0 constant:24];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.caretView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:2]];
		[self addConstraint:self.leftCaretConstraint];
	}

	return self;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {


	if (!self.shouldContinueBlinking) {
		self.caretView.alpha = 1;
		self.shouldContinueBlinking = YES;
		[self blinkAnimation:@"blinkAnimation" finished:YES target:self.caretView];
	}


	self.searchBar.isTextFieldSelected = YES;
	self.searchBar.text = @"";
	[self.keyboardDelegate searchBarTapped];
	return NO;
}

- (void)blinkAnimation:(NSString *)animationId finished:(BOOL)finished target:(UIView *)target {

	if (self.shouldContinueBlinking) {

		[UIView beginAnimations:animationId context:(__bridge void *) target];
		[UIView setAnimationDuration:0.5f];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(blinkAnimation:finished:target:)];
		if ([target alpha] == 1.0f)
			[target setAlpha:0.0f];
		else
			[target setAlpha:1.0f];
		[UIView commitAnimations];
	}
}

@end