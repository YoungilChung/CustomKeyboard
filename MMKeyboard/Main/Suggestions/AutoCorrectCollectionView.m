

// Created by Tom Atterton on 06/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "AutoCorrectCollectionView.h"
#import "SpellCheckerDelegate.h"

@interface AutoCorrectCollectionView () <UIGestureRecognizerDelegate>


@property(nonatomic, strong) UILabel *primaryLabel;
@property(nonatomic, strong) UILabel *secondaryLabel;
@property(nonatomic, strong) UILabel *tertiaryLabel;

@property(nonatomic, strong) UIView *secondaryHolder;
@property(nonatomic, strong) UIView *tertiaryHolder;
@property(nonatomic, strong) UIView *primaryHolder;
@end

@implementation AutoCorrectCollectionView


- (instancetype)init
{
	self = [super init];

	if (self) {

		[self setup];
	}

	return self;
}


- (void)setup {


	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
	tapGestureRecognizer.delegate = self;
	tapGestureRecognizer.delaysTouchesBegan = YES;
	[self addGestureRecognizer:tapGestureRecognizer];

	self.primaryHolder = [UIView new];
	self.primaryHolder.translatesAutoresizingMaskIntoConstraints = NO;
	self.primaryHolder.userInteractionEnabled = YES;
	[self addSubview:self.primaryHolder];

	self.primaryLabel = [UILabel new];
	self.primaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.primaryLabel setText:self.primaryString];
	[self.primaryLabel setTextAlignment:NSTextAlignmentCenter];
	[self.primaryHolder addSubview:self.primaryLabel];


	self.secondaryHolder = [UIView new];
	self.secondaryHolder.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.secondaryHolder];

	self.secondaryLabel = [UILabel new];
	self.secondaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.secondaryLabel setText:self.secondaryString];
	[self.secondaryLabel setTextAlignment:NSTextAlignmentCenter];
	[self.secondaryHolder addSubview:self.secondaryLabel];


	self.tertiaryHolder = [UIView new];
	self.tertiaryHolder.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.tertiaryHolder];

	self.tertiaryLabel = [UILabel new];
	self.tertiaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.tertiaryLabel setText:self.tertiaryString];
	[self.tertiaryLabel setTextAlignment:NSTextAlignmentCenter];
	[self.tertiaryHolder addSubview:self.tertiaryLabel];


	NSDictionary *metrics = @{};
	NSDictionary *views = @{@"primaryHolder" : self.primaryHolder, @"primaryLabel" : self.primaryLabel, @"secondaryHolder" : self.secondaryHolder, @"secondaryLabel" : self.secondaryLabel, @"tertiaryHolder" : self.tertiaryHolder, @"tertiaryLabel" : self.tertiaryLabel};


	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[primaryHolder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[secondaryHolder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tertiaryHolder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[primaryHolder(tertiaryHolder)]-2-[secondaryHolder(primaryHolder)]-2-[tertiaryHolder(primaryHolder)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

	[self.primaryHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[primaryLabel]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self.primaryHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[primaryLabel]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

	[self.secondaryHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[secondaryLabel]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self.secondaryHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[secondaryLabel]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

	[self.tertiaryHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tertiaryLabel]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self.tertiaryHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tertiaryLabel]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

}


- (void)updateText:(NSString *)updatedText forSection:(sectionHeaders)section {

	switch (section) {
		case ksectionHeaderPrimary: {
			[self.primaryLabel setText:updatedText];
			self.primaryString = updatedText;

			break;
		}
		case ksectionHeaderSecondary: {

			[self.secondaryLabel setText:updatedText];
			self.secondaryString = updatedText;
			break;
		}
		case ksectionHeaderTertiary: {

			[self.tertiaryLabel setText:updatedText];
			self.tertiaryString = updatedText;
			break;
		}
	}

}

#pragma mark Touch Gestures

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {

	UIView *view = sender.view;
	CGPoint loc = [sender locationInView:view];
	UIView *subview = [view hitTest:loc withEvent:nil];

	if (subview == self.primaryHolder) {
		NSLog(@"primary");
		if (self.primaryString) {

			[self.delegate tappedWord:self.primaryString];
		}

	}
	if (subview == self.secondaryHolder) {
		if (self.secondaryString) {

			[self.delegate tappedWord:self.secondaryString];
		}
	}
	if (subview == self.tertiaryHolder) {
		if (self.tertiaryString) {

			[self.delegate tappedWord:self.tertiaryString];
		}
	}


}

@end