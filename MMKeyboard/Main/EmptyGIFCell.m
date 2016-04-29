//
// Created by Tom Atterton on 29/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "EmptyGIFCell.h"
#import "UIImage+emoji.h"


@implementation EmptyGIFCell


- (instancetype)init {

	self = [super init];

	if (self) {

		[self setup];

	}


	return self;
}


- (void)setup
{

	UILabel *emptyLabel = [UILabel new];
	emptyLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[emptyLabel setText:@"No GIF's For You"];
	emptyLabel.numberOfLines = 0;
	[emptyLabel setTextAlignment:NSTextAlignmentCenter];
	[emptyLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18]];
	[emptyLabel setTextColor:[UIColor whiteColor]];
	[self addSubview:emptyLabel];


	UIImageView *emojiView = [UIImageView new];
	emojiView.translatesAutoresizingMaskIntoConstraints = NO;
	[emojiView setImage:[UIImage imageWithEmoji:@"😭" withSize:60.0f]];
	emojiView.contentMode = UIViewContentModeScaleAspectFit;
	[self addSubview:emojiView];

	NSDictionary *views = @{@"message" : emptyLabel, @"emoji" : emojiView};
	NSDictionary *metrics = @{@"padding" : @(10)};


	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[message]-5-[emoji]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[message]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[emoji]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	[self addConstraint:[NSLayoutConstraint constraintWithItem:emptyLabel attribute:NSLayoutAttributeCenterY
																   relatedBy:NSLayoutRelationEqual
																	  toItem:self attribute:NSLayoutAttributeCenterY
																  multiplier:1.0 constant:-30]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:emptyLabel attribute:NSLayoutAttributeCenterX
																   relatedBy:NSLayoutRelationEqual
																	  toItem:self attribute:NSLayoutAttributeCenterX
																  multiplier:1.0 constant:0]];
}


@end