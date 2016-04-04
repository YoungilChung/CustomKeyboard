//
// Created by Tom Atterton on 31/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "SearchBarView.h"
#import "MMKeyboardButton.h"
#import "MMKeyboardButton.h"
#import "MMCustomTextField.h"


@interface SearchBarView () <UITextFieldDelegate>


@end

@implementation SearchBarView

- (instancetype)init {
	self = [super init];
	if (self) {

		UILabel *magnifyingGlass = [[UILabel alloc] init];
		[magnifyingGlass setText:[[NSString alloc] initWithUTF8String:"\xF0\x9F\x94\x8D"]];
        [magnifyingGlass sizeToFit];

		self.translatesAutoresizingMaskIntoConstraints= NO;
		
		self.searchBar = [[MMCustomTextField alloc] init];
		self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
		self.searchBar.backgroundColor = [UIColor whiteColor];
		self.searchBar.clearButtonMode;
		[self.searchBar setPlaceholder:@"Search for a GIF"];
		self.searchBar.delegate = self;
		self.searchBar.isTextFieldSelected = NO;
		self.searchBar.layer.cornerRadius = 4;
		[self.searchBar setLeftView:magnifyingGlass];
		[self.searchBar setLeftViewMode:UITextFieldViewModeAlways];
		self.searchBar.clipsToBounds = YES;
		[self addSubview:self.searchBar];


		self.allButton = [MMkeyboardButton buttonWithType:UIButtonTypeCustom];
		self.allButton.translatesAutoresizingMaskIntoConstraints = NO;
		[self.allButton setTitle:@"All" forState:UIControlStateNormal];
		[self.allButton.titleLabel setFont:[UIFont fontWithName:@"AmericanTypewriter" size:11]];

		[self.allButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[self addSubview:self.allButton];

		self.normalButton = [MMkeyboardButton buttonWithType:UIButtonTypeCustom];
		self.normalButton.translatesAutoresizingMaskIntoConstraints = NO;
		[self.normalButton.titleLabel setFont:[UIFont fontWithName:@"AmericanTypewriter" size:11]];
		[self.normalButton setTitle:@"Normal" forState:UIControlStateNormal];
		[self.normalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[self addSubview:self.normalButton];

		self.awesomeButton = [MMkeyboardButton buttonWithType:UIButtonTypeCustom];
		self.awesomeButton.translatesAutoresizingMaskIntoConstraints = NO;
		[self.awesomeButton setTitle:@"Awesome" forState:UIControlStateNormal];
		[self.awesomeButton.titleLabel setFont:[UIFont fontWithName:@"AmericanTypewriter" size:11]];

		[self.awesomeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[self addSubview:self.awesomeButton];

		self.gifButton = [MMkeyboardButton buttonWithType:UIButtonTypeCustom];
		self.gifButton.translatesAutoresizingMaskIntoConstraints = NO;
		[self.gifButton setTitle:@"GIF" forState:UIControlStateNormal];
		[self.gifButton setBackgroundColor:[UIColor clearColor]];
		[self.gifButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[self addSubview:self.gifButton];

		NSDictionary *views = @{@"searchBar" : self.searchBar, @"gifButton" : self.gifButton, @"allButton" : self.allButton, @"normalButton" : self.normalButton, @"awesomeButton" : self.awesomeButton};
		NSDictionary *metrics = @{};

		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[searchBar]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[gifButton]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[allButton]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[normalButton]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[awesomeButton]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[searchBar]-10-[gifButton]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
//		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[allButton]-5-[normalButton]-5-[awesomeButton]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];


		self.allButtonLeftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.allButton attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-200];
		[self addConstraint:self.allButtonLeftConstraint];
		self.normalButtonLeftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.normalButton attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-200];
		[self addConstraint:self.normalButtonLeftConstraint];
		self.awesomeButtonLeftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.awesomeButton attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-200];
		[self addConstraint:self.awesomeButtonLeftConstraint];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.gifButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.gifButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.allButton attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.gifButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.normalButton attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.gifButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.awesomeButton attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];

//		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.searchBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
//		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.gifButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
//		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.searchBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
//		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.gifButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
//
//		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.allButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
//		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.normalButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
//		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.awesomeButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
//
//
//		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.allButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
//		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.normalButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
//		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.awesomeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
//		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.searchBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
//		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.gifButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];

	}

	return self;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	NSLog(@"came here");
	self.searchBar.isTextFieldSelected = YES;
	self.searchBar.text = @"";

	return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

	self.searchBar.isTextFieldSelected = NO;
	@"nooooooo";
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	self.searchBar.isTextFieldSelected = NO;
	@"nooooooo";
	return NO;
}

- (void)animateButtonsOut:(BOOL)isOut {
	NSDictionary *views = @{@"searchBar" : self.searchBar, @"gifButton" : self.gifButton, @"allButton" : self.allButton, @"normalButton" : self.normalButton, @"awesomeButton" : self.awesomeButton};
	NSDictionary *metrics = @{};
	if (isOut) {

		[self addConstraints:@[self.allButtonLeftConstraint, self.normalButtonLeftConstraint, self.awesomeButtonLeftConstraint]];
//		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[searchBar]-10-[gifButton]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];


	}
	else {
		[self removeConstraints:@[self.allButtonLeftConstraint, self.normalButtonLeftConstraint, self.awesomeButtonLeftConstraint]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[searchBar]-2-[awesomeButton]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

//		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.allButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
//		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.normalButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
//		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.awesomeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];


//		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[searchBar]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
//		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[searchBar]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
//		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[searchBar]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

//		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[searchBar]-5-[allButton]-5-[normalButton]-5-[awesomeButton]-5-[gifButton(==50)]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	}


	[self layoutIfNeeded];


}


@end