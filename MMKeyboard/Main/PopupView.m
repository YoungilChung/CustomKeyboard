//
// Created by Tom Atterton on 08/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "PopupView.h"


@implementation PopupView {

}
- (instancetype)initWithTitle:(NSString *)title {

	self = [super init];


	if (self) {

		[self setBackgroundColor:[UIColor whiteColor]];
		self.titleLabel = title;
		UITextView *text = [[UITextView alloc] init];
		text.translatesAutoresizingMaskIntoConstraints = NO;
		text.clipsToBounds = YES;
		[text setText:title];
		text.layer.cornerRadius = 4;
		text.textContainerInset = UIEdgeInsetsZero;
		text.textContainer.lineFragmentPadding = 0;
		text.textAlignment = NSTextAlignmentCenter;
		[text setFont:[UIFont boldSystemFontOfSize:30]];
		text.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
		[self addSubview:text];

		NSDictionary *metrics = @{};
		NSDictionary *views = @{ @"text" : text};

		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[text]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[text]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];


	}


	return self;
}

@end