//
// Created by Tom Atterton on 12/05/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMSettingsSubtitle.h"


@implementation MMSettingsSubtitle


- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		self.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
	}
	return self;
}

- (void)drawTextInRect:(CGRect)rect
{
	[super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

- (CGSize)intrinsicContentSize
{
	CGSize size = [super intrinsicContentSize];
	size.width += self.edgeInsets.left + self.edgeInsets.right;
	size.height += self.edgeInsets.top + self.edgeInsets.bottom;
	return size;
}


@end