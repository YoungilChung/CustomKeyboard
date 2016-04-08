//
// Created by Tom Atterton on 23/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMkeyboardButton.h"


@implementation MMkeyboardButton


- (instancetype
)initWithCoder:(NSCoder *)coder {
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
	MMkeyboardButton *button = (MMkeyboardButton *) [super buttonWithType:buttonType];

	if (button) {
		[button initialize];
	}

	return button;
}

- (void)initialize {

	self.backgroundColor = [UIColor darkGrayColor];
	[self.titleLabel setFont:[UIFont fontWithName:@"AmericanTypewriter" size:20]];

	self.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f] CGColor];
	self.layer.shadowOffset = CGSizeMake(0, 2.0f);
	self.layer.shadowOpacity = 1.0f;
	self.layer.shadowRadius = 0.0f;
	self.layer.masksToBounds = NO;
	self.layer.cornerRadius = 4.0f;

}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {

	CGFloat margin = 10.0;
//	CGRect area = CGRectInset(self.bounds, -margin, -margin);
//
////	NSLog(@"came here with Point:%f, area:%f", self.bounds.origin.x,self.bounds.origin.y);
//	return CGRectContainsPoint(area, point);

	CGRect newBound = CGRectMake(self.bounds.origin.x - margin,
			self.bounds.origin.y - margin,
			self.bounds.size.width + 2 * margin,
			self.bounds.size.height + 2 * margin );
//	CGRect relativeFrame = self.bounds;
//	UIEdgeInsets hitTestEdgeInsets = UIEdgeInsetsMake(-margin,-5, 0, -5);
//	CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets);


	return CGRectContainsPoint(newBound, point);

}

- (CGSize)intrinsicContentSize {
	CGSize size = [super intrinsicContentSize];
	return CGSizeMake(size.width, 45);
}
@end