//
// Created by Tom Atterton on 05/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMGIFCategoryHolder.h"
#import "MMKeyboardButton.h"


@implementation MMGIFCategoryHolder

- (instancetype)init {

	self = [super init];

	if (self) {

		self.translatesAutoresizingMaskIntoConstraints = NO;
		self.backgroundColor = [UIColor blackColor];

		self.trendingButton = [UIButton buttonWithType:UIButtonTypeCustom];
		self.trendingButton.translatesAutoresizingMaskIntoConstraints = NO;
		self.trendingButton.layer.cornerRadius = 4;
		[self.trendingButton setImage:[UIImage imageNamed:@"trendingIcon"] forState:UIControlStateNormal];
		[self.trendingButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
		[self.trendingButton setImageEdgeInsets:UIEdgeInsetsMake(5,5,5,5)];
		[self addSubview:self.trendingButton];

		self.randomButton = [UIButton buttonWithType:UIButtonTypeCustom];
		self.randomButton.translatesAutoresizingMaskIntoConstraints = NO;
		self.randomButton.layer.cornerRadius = 4;
		[self.randomButton setImage:[UIImage imageNamed:@"randomIcon"] forState:UIControlStateNormal];
		[self.randomButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
		[self.randomButton setContentEdgeInsets:UIEdgeInsetsMake(5,5,5,5)];
		[self addSubview:self.randomButton];

		self.allButton = [UIButton buttonWithType:UIButtonTypeCustom];
		self.allButton.translatesAutoresizingMaskIntoConstraints = NO;
		self.allButton.layer.cornerRadius = 4;
		[self.allButton setImage:[UIImage imageNamed:@"allIcon"] forState:UIControlStateNormal];
		[self.allButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
		[self.allButton setImageEdgeInsets:UIEdgeInsetsMake(5,5,5,5)];
		[self addSubview:self.allButton];

		self.normalButton = [UIButton buttonWithType:UIButtonTypeCustom];
		self.normalButton.translatesAutoresizingMaskIntoConstraints = NO;
		self.normalButton.layer.cornerRadius = 4;
		[self.normalButton setImage:[UIImage imageNamed:@"foodIcon"] forState:UIControlStateNormal];
		[self.normalButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
		[self.normalButton setImageEdgeInsets:UIEdgeInsetsMake(5,5,5,5)];
		[self addSubview:self.normalButton];

		self.awesomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		self.awesomeButton.translatesAutoresizingMaskIntoConstraints = NO;
		self.awesomeButton.layer.cornerRadius = 4;
		[self.awesomeButton setImage:[UIImage imageNamed:@"awesomeIcon"] forState:UIControlStateNormal];
		[self.awesomeButton.imageView setContentMode:UIViewContentModeScaleToFill];
		[self.awesomeButton setContentEdgeInsets:UIEdgeInsetsMake(8,8,8,8)];

		[self addSubview:self.awesomeButton];

		self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
		self.deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
		self.deleteButton.layer.cornerRadius = 4;
		[self.deleteButton setImage:[UIImage imageNamed:@"backspaceIcon"] forState:UIControlStateNormal];
		[self.deleteButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
		[self.deleteButton setImageEdgeInsets:UIEdgeInsetsMake(5,5,5,5)];
		[self addSubview:self.deleteButton];


		NSDictionary *views = @{@"trendingButton" : self.trendingButton, @"randomButton" : self.randomButton, @"allButton" : self.allButton, @"normalButton" : self.normalButton, @"awesomeButton" : self.awesomeButton, @"deleteButton" : self.deleteButton};
		NSDictionary *metrics = @{@"paddingH":@(10), @"paddingV":@(2)};

		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-paddingV-[trendingButton(==35)]-paddingV-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-paddingV-[randomButton]-paddingV-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-paddingV-[allButton]-paddingV-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-paddingV-[normalButton]-paddingV-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-paddingV-[awesomeButton]-paddingV-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-paddingV-[deleteButton]-paddingV-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[allButton(==awesomeButton)]-paddingH-[normalButton(==awesomeButton)]-paddingH-[awesomeButton(==normalButton)]-paddingH-[trendingButton(==allButton)]-paddingH-[randomButton(allButton)]-paddingH-[deleteButton(trendingButton)]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	}
	return self;

}


@end