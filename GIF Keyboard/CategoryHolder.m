//
// Created by Tom Atterton on 05/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "CategoryHolder.h"
#import "MMKeyboardButton.h"


@implementation CategoryHolder

- (instancetype)init {

	self = [super init];

	if (self) {

		self.translatesAutoresizingMaskIntoConstraints = NO;
		self.backgroundColor = [UIColor blackColor];

		self.allButton = [UIButton buttonWithType:UIButtonTypeCustom];
		self.allButton.translatesAutoresizingMaskIntoConstraints = NO;
		self.allButton.layer.cornerRadius = 4;
		self.allButton.backgroundColor = [UIColor darkGrayColor];
		[self.allButton setTitle:@"All" forState:UIControlStateNormal];
		[self.allButton.titleLabel setFont:[UIFont fontWithName:@"AmericanTypewriter" size:14]];

		[self.allButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[self addSubview:self.allButton];

		self.normalButton = [UIButton buttonWithType:UIButtonTypeCustom];
		self.normalButton.translatesAutoresizingMaskIntoConstraints = NO;
		self.normalButton.layer.cornerRadius = 4;
		self.normalButton.backgroundColor = [UIColor darkGrayColor];
		[self.normalButton.titleLabel setFont:[UIFont fontWithName:@"AmericanTypewriter" size:14]];
		[self.normalButton setTitle:@"Normal" forState:UIControlStateNormal];
		[self.normalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[self addSubview:self.normalButton];

		self.awesomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		self.awesomeButton.translatesAutoresizingMaskIntoConstraints = NO;
		self.awesomeButton.layer.cornerRadius = 4;
		self.awesomeButton.backgroundColor = [UIColor darkGrayColor];
		[self.awesomeButton setTitle:@"Awesome" forState:UIControlStateNormal];
		[self.awesomeButton.titleLabel setFont:[UIFont fontWithName:@"AmericanTypewriter" size:14]];
		[self.awesomeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[self addSubview:self.awesomeButton];

		self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
		self.deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
		self.deleteButton.layer.cornerRadius = 4;
		self.deleteButton.backgroundColor = [UIColor darkGrayColor];
		[self.deleteButton setTitle:@"⌫" forState:UIControlStateNormal];
		[self.deleteButton.titleLabel setFont:[UIFont fontWithName:@"AmericanTypewriter" size:14]];
		[self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[self addSubview:self.deleteButton];


		NSDictionary *views = @{@"allButton" : self.allButton, @"normalButton" : self.normalButton, @"awesomeButton" : self.awesomeButton, @"deleteButton" : self.deleteButton};
		NSDictionary *metrics = @{};

		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[allButton]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[normalButton]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[awesomeButton]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[deleteButton]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[allButton(==awesomeButton)]-2-[normalButton(==allButton)]-2-[awesomeButton(allButton)]-2-[deleteButton(40)]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	}
	return self;

}


@end