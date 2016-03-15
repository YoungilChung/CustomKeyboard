//
// Created by Tom Atterton on 15/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMKeyboardButton.h"

@interface MMKeyboardButton ()
@property(nonatomic, strong) UIImageView *iconView;
@end

@implementation MMKeyboardButton

- (NSString *)title
{
	return self.titleLabel.text;
}

- (void)setTitle:(NSString *)title
{
	[self setTitle:title forState:UIControlStateNormal];
}



//+ (instancetype)initWithType:(MMButtonType)type {
//
//	MMKeyboardButton *button = [self new];
//	[button styleButtonWithType:type];
//
//	return button;
//}

//- (void)styleButtonWithType:(MMButtonType)type {
//
//	self.type = type;
//	// TODO: mention 'highlighted' in the stylesheet color names
//
//	UIColor *iconColor = [UIColor blackColor];
//	UIColor *highlightedIconColor = [UIColor whiteColor];
//
//	UIColor *backgroundColor = nil;
//	UIColor *highlightedBackgroundColor = nil;
//
//	CGFloat borderWidth = 0;
//	UIColor *borderColor = nil;
//
//
//	switch (self.type) {
//		case MMButtonTypeImage: {
//			break;
//		}
//		case MMButtonTypeTitle: {
//
//			break;
//		}
//	}
//}
//- (NSString *)title
//{
//	return self.titleLabel.text;
//}
//
//- (void)setTitle:(NSString *)title
//{
//	[self setTitle:title forState:UIControlStateNormal];
//}

//- (CGSize)intrinsicContentSize {
//	CGSize size = [super intrinsicContentSize];
//	return CGSizeMake(size.width, 60.0f);
//}
//
//- (void)layoutSubviews {
//	[super layoutSubviews];
//
//	CGFloat spacing = 6.0;
//
//	CGSize imageSize = self.imageView.image.size;
//	self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0);
//
//	CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}];
//	self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, -titleSize.width);
//}

@end