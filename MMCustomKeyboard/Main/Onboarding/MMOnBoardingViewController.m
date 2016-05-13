//
// Created by Tom Atterton on 11/05/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMOnBoardingViewController.h"


@implementation MMOnBoardingViewController


- (void)viewDidLoad
{
	[super viewDidLoad];


	UILabel *titleLabel = [UILabel new];
	titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[titleLabel setText:@"This is how are you install the app...."];
	[titleLabel setTextColor:[UIColor whiteColor]];
	[titleLabel setTextAlignment:NSTextAlignmentCenter];
	[self.view addSubview:titleLabel];

	NSDictionary *metrics = @{};
	NSDictionary *views = @{@"title" : titleLabel};

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[title]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];

}


@end