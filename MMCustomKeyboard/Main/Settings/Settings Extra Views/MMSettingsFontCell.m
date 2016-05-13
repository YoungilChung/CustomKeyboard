//
// Created by Tom Atterton on 13/05/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMSettingsFontCell.h"


@implementation MMSettingsFontCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self)
	{

		[self setup];
	}

	return self;
}


- (void)setup
{

	self.titleLabel = [UILabel new];
	self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.titleLabel setClipsToBounds:YES];
	[self.titleLabel setTextAlignment:NSTextAlignmentCenter];
	[self.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
	[self.titleLabel setTextColor:[UIColor blackColor]];
	[self addSubview:self.titleLabel];


	NSDictionary *views = @{@"titleLabel" : self.titleLabel};
	NSDictionary *metrics = @{@"padding" : @(5)};

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[titleLabel]-padding-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[titleLabel]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

}
@end