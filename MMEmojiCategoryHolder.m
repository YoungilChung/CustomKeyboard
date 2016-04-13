
//
// Created by Tom Atterton on 13/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMEmojiCategoryHolder.h"
#import "UIImage+emoji.h"


@implementation MMEmojiCategoryHolder


- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	if (self) {
		[self setup];
	}

	return self;
}

- (void)setup {


	[self setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self setBackgroundColor:[UIColor grayColor]];

	UIButton *smileyButton = [UIButton buttonWithType:UIButtonTypeCustom];
	smileyButton.translatesAutoresizingMaskIntoConstraints = NO;
	smileyButton.clipsToBounds = YES;
	[smileyButton setImage:[UIImage imageWithEmoji: @"😬" withSize:30] forState:UIControlStateNormal];
	[smileyButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
	[smileyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self addSubview:smileyButton];

	UIButton *natureButton = [UIButton buttonWithType:UIButtonTypeCustom];
	natureButton.translatesAutoresizingMaskIntoConstraints = NO;
    
	[natureButton setImage:[UIImage imageWithEmoji: @"😬" withSize:30] forState:UIControlStateNormal];
	[natureButton.imageView setContentMode:UIViewContentModeScaleAspectFit];

	[natureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self addSubview:natureButton];

	UIButton *foodButton = [UIButton buttonWithType:UIButtonTypeCustom];
	foodButton.translatesAutoresizingMaskIntoConstraints = NO;
	[foodButton setImage:[UIImage imageWithEmoji: @"😬" withSize:30] forState:UIControlStateNormal];
	[foodButton.imageView setContentMode:UIViewContentModeScaleAspectFit];

	[foodButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self addSubview:foodButton];

	UIButton *sportButton = [UIButton buttonWithType:UIButtonTypeCustom];
	sportButton.translatesAutoresizingMaskIntoConstraints = NO;
	[sportButton setImage:[UIImage imageWithEmoji: @"😬" withSize:30] forState:UIControlStateNormal];
	[sportButton.imageView setContentMode:UIViewContentModeScaleAspectFit];

	[sportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self addSubview:sportButton];

	UIButton *placesButton = [UIButton buttonWithType:UIButtonTypeCustom];
	placesButton.translatesAutoresizingMaskIntoConstraints = NO;
	[placesButton setImage:[UIImage imageWithEmoji: @"😬" withSize:30] forState:UIControlStateNormal];
	[placesButton.imageView setContentMode:UIViewContentModeScaleAspectFit];

	[placesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self addSubview:placesButton];

	UIButton *objectsButton = [UIButton buttonWithType:UIButtonTypeCustom];
	objectsButton.translatesAutoresizingMaskIntoConstraints = NO;
	[objectsButton setImage:[UIImage imageWithEmoji: @"😬" withSize:30] forState:UIControlStateNormal];
	[objectsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[objectsButton.imageView setContentMode:UIViewContentModeScaleAspectFit];

	[self addSubview:objectsButton];

	UIButton *symbolButton = [UIButton buttonWithType:UIButtonTypeCustom];
	symbolButton.translatesAutoresizingMaskIntoConstraints = NO;
	[symbolButton setImage:[UIImage imageWithEmoji: @"😬" withSize:30] forState:UIControlStateNormal];
	[symbolButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[symbolButton.imageView setContentMode:UIViewContentModeScaleAspectFit];

	[self addSubview:symbolButton];

	UIButton *flagsButton = [UIButton buttonWithType:UIButtonTypeCustom];
	flagsButton.translatesAutoresizingMaskIntoConstraints = NO;
	[flagsButton setImage:[UIImage imageWithEmoji: @"😬" withSize:30] forState:UIControlStateNormal];
	[flagsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[flagsButton.imageView setContentMode:UIViewContentModeScaleAspectFit];

	[self addSubview:flagsButton];

	NSDictionary *metrics = @{};
	NSDictionary *views = @{@"smileyButton": smileyButton, @"natureButton": natureButton, @"foodButton": foodButton, @"sportButton": sportButton, @"placesButton": placesButton, @"objectsButton": objectsButton, @"symbolButton": symbolButton, @"flagsButton": flagsButton};

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[smileyButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[foodButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[sportButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[placesButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[objectsButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[symbolButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[flagsButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[smileyButton(==flagsButton)]-2-[natureButton(==smileyButton)]-2-[foodButton(==smileyButton)]-2-[sportButton(==smileyButton)]-2-[placesButton(==smileyButton)]-2-[objectsButton(==smileyButton)]-2-[symbolButton(==smileyButton)]-2-[flagsButton(==smileyButton)]-(0)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
}


@end