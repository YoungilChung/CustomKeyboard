//
// Created by Tom Atterton on 12/05/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMSettingsTableViewCell.h"
#import "MMSettingsSubtitle.h"
#import "NSUserDefaults+Keyboard.h"


#define CASE(str)          if ([__s__ isEqualToString:(str)])
#define SWITCH(s)          for (NSString *__s__ = (s); ; )
#define DEFAULT

@interface MMSettingsTableViewCell ()


@end

@implementation MMSettingsTableViewCell


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

	[self setClipsToBounds:YES];
	self.titleLabel = [UILabel new];
	self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.titleLabel setClipsToBounds:YES];
	[self.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
	[self.titleLabel setTextColor:[UIColor blackColor]];
	[self addSubview:self.titleLabel];

	self.subTitleLabel = [MMSettingsSubtitle new];
	self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.subTitleLabel setClipsToBounds:YES];
	[self.subTitleLabel setNumberOfLines:2];
	[self.subTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
	[self.subTitleLabel setBackgroundColor:[UIColor clearColor]];
	[self.subTitleLabel setEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
	[self.subTitleLabel setTextColor:[UIColor blackColor]];
	[self addSubview:self.subTitleLabel];

	self.uiSwitch = [UISwitch new];
	self.uiSwitch.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.uiSwitch];

	NSDictionary *views = @{@"titleLabel" : self.titleLabel, @"subTitleLabel" : self.subTitleLabel, @"switch" : self.uiSwitch};
	NSDictionary *metrics = @{@"padding" : @(5)};

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[titleLabel]-5-[subTitleLabel]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[titleLabel]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[subTitleLabel]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[switch]-5-[subTitleLabel]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[switch]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

}

@end