//
// Created by Tom Atterton on 18/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMKeyboardSelectionCell.h"


@implementation MMKeyboardSelectionCell

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	if (self) {
		[self setup];
	}

	return self;
}

- (void)setup {

	[self setTranslatesAutoresizingMaskIntoConstraints:NO];


	self.imageView = [UIImageView new];
	self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
	self.imageView.contentMode = UIViewContentModeScaleToFill;
	self.imageView.clipsToBounds = YES;
	self.imageView.backgroundColor = [UIColor clearColor];
	[self addSubview:self.imageView];

	NSDictionary *metrics = @{};
	NSDictionary *views = @{
			@"imageView" : self.imageView
	};


	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:kNilOptions metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[imageView]-10-|" options:kNilOptions metrics:metrics views:views]];

}

+ (NSString *)reuseIdentifier {
	return @"Cell";
}
@end