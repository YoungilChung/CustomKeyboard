//
// Created by Tom Atterton on 08/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <CoreMedia/CoreMedia.h>
#import "PopupView.h"

#define HMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:0.8]

@interface PopupView ()
@property(nonatomic, strong) UITextView *text;
@end

@implementation PopupView {

}

- (instancetype)initWithTitle:(NSString *)title {

	self = [super init];


	if (self) {

		[self setBackgroundColor:[UIColor clearColor]];
		self.titleLabel = title;
		self.text = [[UITextView alloc] init];
		self.text.translatesAutoresizingMaskIntoConstraints = NO;
//		self.text.clipsToBounds = YES;
		[self.text setText:title];
		self.text.layer.cornerRadius = 4;
		self.text.textContainerInset = UIEdgeInsetsZero;
		self.text.textContainer.lineFragmentPadding = 0;
		self.text.textAlignment = NSTextAlignmentCenter;
		[self.text setFont:[UIFont boldSystemFontOfSize:30]];
		[self.text setBackgroundColor:[UIColor colorWithRed:(CGFloat) (135 / 255.0) green:(CGFloat) (208 / 255.0) blue:(CGFloat) (250 / 255.0) alpha:0.8]];
		[self addSubview:self.text];

		NSDictionary *metrics = @{};
		NSDictionary *views = @{@"text" : self.text};

		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[text]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[text]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];


	}


	return self;
}

- (void)selectedPopupView:(BOOL)selected {

	if (selected) {

		[self.text setBackgroundColor:[UIColor colorWithPatternImage:[self createImageWithColor:HMColor(248, 248, 248)]]];

	}
	else {

		[self.text setBackgroundColor:[UIColor colorWithRed:(CGFloat) (135 / 255.0) green:(CGFloat) (208 / 255.0) blue:(CGFloat) (250 / 255.0) alpha:0.8]];
	}


}

- (UIImage *)createImageWithColor:(UIColor *)color {
	CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, rect);
	UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return theImage;
}


@end