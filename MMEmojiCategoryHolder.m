
// Created by Tom Atterton on 13/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMEmojiCategoryHolder.h"
#import "UIImage+emoji.h"


#define HMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:0.8]




@implementation MMEmojiCategoryHolder


- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	if (self) {
		[self setup];
	}

	return self;
}

- (void)setup {

	[self setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self setBackgroundColor:[UIColor grayColor]];
	int hEdgeInsets = 2;
	int vEdgeInsets = 4;

	self.keyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.keyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.keyboardButton.layer.cornerRadius = 4;
	self.keyboardButton.tag = kTagEmojiExit;
	[self.keyboardButton setImage:[UIImage imageWithEmoji:@"🌐" withSize:30] forState:UIControlStateNormal];
	[self.keyboardButton setImageEdgeInsets:UIEdgeInsetsMake(vEdgeInsets, hEdgeInsets, vEdgeInsets, hEdgeInsets)];
	[self.keyboardButton setBackgroundImage:[self createImageWithColor:HMColor(208, 208, 208)] forState:UIControlStateHighlighted];
	[self.keyboardButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
	[self addSubview:self.keyboardButton];


	self.smileyButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.smileyButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.smileyButton.tag = kTagEmojiSmiley;
	self.smileyButton.layer.cornerRadius = 4;
	[self.smileyButton setImage:[UIImage imageWithEmoji:@"😀" withSize:30] forState:UIControlStateNormal];
	[self.smileyButton setImageEdgeInsets:UIEdgeInsetsMake(vEdgeInsets, hEdgeInsets, vEdgeInsets, hEdgeInsets)];
	[self.smileyButton setBackgroundImage:[self createImageWithColor:HMColor(208, 208, 208)] forState:UIControlStateHighlighted];
	[self.smileyButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
	[self addSubview:self.smileyButton];

	self.natureButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.natureButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.natureButton.tag = kTagEmojiNature;
	self.natureButton.layer.cornerRadius = 4;
	[self.natureButton setImage:[UIImage imageWithEmoji:@"🐱" withSize:30] forState:UIControlStateNormal];
	[self.natureButton setImageEdgeInsets:UIEdgeInsetsMake(vEdgeInsets, hEdgeInsets, vEdgeInsets, hEdgeInsets)];
	[self.natureButton setBackgroundImage:[self createImageWithColor:HMColor(208, 208, 208)] forState:UIControlStateHighlighted];
	[self.natureButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
	[self addSubview:self.natureButton];

	self.foodButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.foodButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.foodButton.tag = kTagEmojiFood;
	self.foodButton.layer.cornerRadius = 4;
	[self.foodButton setImageEdgeInsets:UIEdgeInsetsMake(vEdgeInsets, hEdgeInsets, vEdgeInsets, hEdgeInsets)];
	[self.foodButton setImage:[UIImage imageWithEmoji:@
                               "🍎" withSize:30] forState:UIControlStateNormal];
	[self.foodButton setBackgroundImage:[self createImageWithColor:HMColor(208, 208, 208)] forState:UIControlStateHighlighted];
	[self.foodButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
	[self addSubview:self.foodButton];

	self.sportButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.sportButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.sportButton.tag = kTagEmojiSport;
	self.sportButton.layer.cornerRadius = 4;
	[self.sportButton setImageEdgeInsets:UIEdgeInsetsMake(vEdgeInsets, hEdgeInsets, vEdgeInsets, hEdgeInsets)];
	[self.sportButton setImage:[UIImage imageWithEmoji:@"🏀" withSize:30] forState:UIControlStateNormal];
	[self.sportButton setBackgroundImage:[self createImageWithColor:HMColor(208, 208, 208)] forState:UIControlStateHighlighted];
	[self.sportButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
	[self addSubview:self.sportButton];

	self.placesButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.placesButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.placesButton.tag = kTagEmojiPlaces;
	self.placesButton.layer.cornerRadius = 4;
	[self.placesButton setImageEdgeInsets:UIEdgeInsetsMake(vEdgeInsets, hEdgeInsets, vEdgeInsets, hEdgeInsets)];
	[self.placesButton setImage:[UIImage imageWithEmoji:@"🚗" withSize:30] forState:UIControlStateNormal];
	[self.placesButton setBackgroundImage:[self createImageWithColor:HMColor(208, 208, 208)] forState:UIControlStateHighlighted];
	[self.placesButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
	[self addSubview:self.placesButton];

	self.objectsButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.objectsButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.objectsButton.tag = kTagEmojiObjects;
	self.objectsButton.layer.cornerRadius = 4;
	[self.objectsButton setImageEdgeInsets:UIEdgeInsetsMake(vEdgeInsets, hEdgeInsets, vEdgeInsets, hEdgeInsets)];
	[self.objectsButton setImage:[UIImage imageWithEmoji:@"⏰" withSize:30] forState:UIControlStateNormal];
	[self.objectsButton setBackgroundImage:[self createImageWithColor:HMColor(208, 208, 208)] forState:UIControlStateHighlighted];
	[self.objectsButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
	[self addSubview:self.objectsButton];

	self.symbolButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.symbolButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.symbolButton.tag = kTagEmojiSymbol;
	self.symbolButton.layer.cornerRadius = 4;
	[self.symbolButton setImageEdgeInsets:UIEdgeInsetsMake(vEdgeInsets, hEdgeInsets, vEdgeInsets, hEdgeInsets)];
	[self.symbolButton setImage:[UIImage imageWithEmoji:@"❤️" withSize:30] forState:UIControlStateNormal];
	[self.symbolButton setBackgroundImage:[self createImageWithColor:HMColor(208, 208, 208)] forState:UIControlStateHighlighted];
	[self.symbolButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
	[self addSubview:self.symbolButton];

	self.flagsButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.flagsButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.flagsButton.tag = kTagEmojiFlags;
	self.flagsButton.imageView.layer.cornerRadius = 4;
	[self.flagsButton setImageEdgeInsets:UIEdgeInsetsMake(vEdgeInsets, hEdgeInsets, vEdgeInsets, hEdgeInsets)];
	[self.flagsButton setImage:[UIImage imageWithEmoji:@"🇬🇧" withSize:30] forState:UIControlStateNormal];
	[self.flagsButton setBackgroundImage:[self createImageWithColor:HMColor(208, 208, 208)] forState:UIControlStateHighlighted];
	[self.flagsButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
	[self addSubview:self.flagsButton];


	self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.deleteButton.tag = kTagEmojiDelete;
	self.deleteButton.layer.cornerRadius = 4;
	[self.deleteButton setImageEdgeInsets:UIEdgeInsetsMake(vEdgeInsets, hEdgeInsets, vEdgeInsets, hEdgeInsets)];
	[self.deleteButton setImage:[UIImage imageNamed:@"backspaceIcon"] forState:UIControlStateNormal];
	[self.deleteButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
	[self.deleteButton setBackgroundImage:[self createImageWithColor:HMColor(208, 208, 208)] forState:UIControlStateHighlighted];
	[self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self addSubview:self.deleteButton];

	NSDictionary *metrics = @{@"paddingH" : @(8), @"paddingV" : @(2)};
	NSDictionary *views = @{@"keyboardButton" : self.keyboardButton, @"smileyButton" : self.smileyButton, @"natureButton" : self.natureButton, @"foodButton" : self.foodButton,
			@"sportButton" : self.sportButton, @"placesButton" : self.placesButton, @"objectsButton" : self.objectsButton, @"symbolButton" : self.symbolButton, @"flagsButton" : self.flagsButton, @"deleteButton" : self.deleteButton
	};

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(paddingV)-[keyboardButton]-(paddingV)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(paddingV)-[smileyButton]-(paddingV)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(paddingV)-[natureButton]-(paddingV)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(paddingV)-[foodButton]-(paddingV)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(paddingV)-[sportButton]-(paddingV)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(paddingV)-[placesButton]-(paddingV)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(paddingV)-[objectsButton]-(paddingV)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(paddingV)-[symbolButton]-(paddingV)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(paddingV)-[flagsButton]-(paddingV)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(paddingV)-[deleteButton]-(paddingV)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(5)-[keyboardButton(==smileyButton)]-(paddingH)-[smileyButton(==flagsButton)]-(paddingH)-[natureButton(==smileyButton)]-(paddingH)-[foodButton(==smileyButton)]-(paddingH)-[sportButton(==smileyButton)]-(paddingH)-[placesButton(==smileyButton)]-(paddingH)-[objectsButton(==smileyButton)]-(paddingH)-[symbolButton(==smileyButton)]-(paddingH)-[flagsButton(==smileyButton)]-(paddingH)-[deleteButton(==smileyButton)]-(2)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
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