




//
// Created by Tom Atterton on 23/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMkeyboardButton.h"


@implementation MMkeyboardButton



- (instancetype)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if (self) {

		self = [super initWithCoder:coder];
        

		if (self)
		{
			[self initialize];
		}

		return self;



	}

	return self;
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
	MMkeyboardButton *button = (MMkeyboardButton *)[super buttonWithType:buttonType];

	if (button)
	{
		[button initialize];
	}

	return button;
}

-(void)initialize
{

	self.backgroundColor = [UIColor darkGrayColor];
	[self.titleLabel setFont:[UIFont fontWithName:@"AmericanTypewriter" size:12]];
	self.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f] CGColor];
	self.layer.shadowOffset = CGSizeMake(0, 2.0f);
	self.layer.shadowOpacity = 1.0f;
	self.layer.shadowRadius = 0.0f;
	self.layer.masksToBounds = NO;
	self.layer.cornerRadius = 4.0f;


}



//
//- (CGSize)intrinsicContentSize
//{
//	CGSize size = [super intrinsicContentSize];
//	return CGSizeMake(size.width, size.height);
//}
@end