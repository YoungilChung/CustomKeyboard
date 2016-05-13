//
// Created by Tom Atterton on 13/05/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMSettingsHeaderView.h"


@interface MMSettingsHeaderView ()
@property (nonatomic, copy) NSString *titleString;
@end

@implementation MMSettingsHeaderView


- (instancetype)initWithTitle:(NSString *)titleString
{
	self = [super init];
	if (self)
	{

		self.titleString = titleString;
		[self setup];
	}

	return self;
}


- (void)setup
{

	UILabel *label = [UILabel new];
	label.translatesAutoresizingMaskIntoConstraints = NO;
	[label setText:self.titleString];
	NSLog(@"%@", self.titleString);
	[label setTextColor:[UIColor whiteColor]];
	[label setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
	[self addSubview:label];

	[self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:20]];

}

- (CGSize)intrinsicContentSize
{

	CGSize size = [super intrinsicContentSize];
	return CGSizeMake(size.width, 80.0f);
}


@end