//
// Created by Tom Atterton on 07/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "PopupButtonView.h"

@interface PopupButtonView()

@property (nonatomic, strong) NSString *buttonTitle;

@end

@implementation PopupButtonView
- (instancetype)initWithButtonTitle:(NSString *)buttonTitle {

	self = [super init];

	if (self)
	{
		self.buttonTitle = buttonTitle;
		[self setup];


	}
	return self;
}



-(void)setup
{

	UITextView *text = [[UITextView alloc] init];
	text.translatesAutoresizingMaskIntoConstraints = NO;
	[text setText:self.buttonTitle];
	text.layer.cornerRadius = 4;
	text.textContainerInset = UIEdgeInsetsZero;
	text.textContainer.lineFragmentPadding = 0;
	text.textAlignment = NSTextAlignmentCenter;
	[text setFont:[UIFont boldSystemFontOfSize:30]];
	text.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
	[self addSubview:text];

	NSDictionary *metrics = @{};
	NSDictionary *views = @{@"text" : text};

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[text]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[text]-(0)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];


}


@end