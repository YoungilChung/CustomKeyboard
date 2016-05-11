//
// Created by Tom Atterton on 06/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "SuggestionView.h"


@implementation SuggestionView


- (instancetype)init {

	self = [super init];

	if (self) {

		[self setup];
	}

	return self;
}


- (void)setup {


	self.translatesAutoresizingMaskIntoConstraints = NO;
	[self setBackgroundColor:[UIColor darkGrayColor]];
	self.layer.cornerRadius = 4;

	self.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f] CGColor];
	self.layer.shadowOffset = CGSizeMake(0, 2.0f);
	self.layer.shadowOpacity = 1.0f;
	self.layer.shadowRadius = 0.0f;
	self.layer.masksToBounds = NO;
	self.layer.cornerRadius = 4.0f;

	self.suggestionLabel = [UILabel new];
	self.suggestionLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.suggestionLabel setTextAlignment:NSTextAlignmentCenter];
	self.suggestionLabel.textColor = [UIColor whiteColor];
	[self.suggestionLabel setFont:[UIFont fontWithName:@"AmericanTypewriter" size:20]];
	[self addSubview:self.suggestionLabel];

	NSDictionary *views = @{@"suggestionLabel" : self.suggestionLabel};
	NSDictionary *metrics = @{};

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[suggestionLabel]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[suggestionLabel]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

}

- (void)updateLabel:(NSString *)labelText {

	[self.suggestionLabel setText:labelText];

}


@end