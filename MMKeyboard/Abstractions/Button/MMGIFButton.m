//
// Created by Tom Atterton on 03/05/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMGIFButton.h"

@interface MMGIFButton ()

@property(nonatomic, strong) CAShapeLayer *circleLayer;
@property(nonatomic, strong) UIColor *color;
@end

@implementation MMGIFButton




- (instancetype)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if (self) {

		self = [super initWithCoder:coder];


		if (self) {
			[self initialize];
		}

		return self;


	}

	return self;
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
	MMGIFButton *button = (MMGIFButton *) [super buttonWithType:buttonType];

	if (button) {
		[button initialize];
	}

	return button;
}


- (void)initialize {

	self.color = [UIColor whiteColor];

	[self setTitleColor:self.color forState:UIControlStateNormal];
	self.layer.borderColor= self.color.CGColor;
	self.layer.borderWidth=2.0f;

}

- (void)setHighlighted:(BOOL)highlighted {
	if (highlighted) {
		self.titleLabel.textColor = [UIColor whiteColor];
		[self.circleLayer setFillColor:self.color.CGColor];
	}
	else {
		[self.circleLayer setFillColor:[UIColor clearColor].CGColor];
		self.titleLabel.textColor = self.color;
	}
}

- (CGSize)intrinsicContentSize {
	CGSize size = [super intrinsicContentSize];
	return CGSizeMake(32.5, 32.5);
//	return CGSizeMake(size.width, size.width);
}

@end