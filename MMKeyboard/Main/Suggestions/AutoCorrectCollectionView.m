//
// Created by Tom Atterton on 06/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "AutoCorrectCollectionView.h"
#import "SpellCheckerDelegate.h"
#import "SpellCheckerManager.h"

@interface AutoCorrectCollectionView () <SpellCheckerDelegate>


@property(nonatomic, strong) UILabel *primaryLabel;
@property(nonatomic, strong) UILabel *secondaryLabel;
@property(nonatomic, strong) UILabel *tertiaryLabel;
@property(nonatomic, strong) SpellCheckerManager *spellCheckerManager;

@end

@implementation AutoCorrectCollectionView


- (instancetype)initWithSpellManager:(SpellCheckerManager *)manager {
	self = [super init];

	if (self) {
		self.spellCheckerManager = manager;
		manager.delegate = self;
		[self setup];
	}

	return self;
}


- (void)setup {


	UIView *primaryHolder = [UIView new];
	primaryHolder.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:primaryHolder];

	self.primaryLabel = [UILabel new];
	self.primaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.primaryLabel setText:self.primaryString];
	[self.primaryLabel setTextAlignment:NSTextAlignmentCenter];
	[primaryHolder addSubview:self.primaryLabel];


	UIView *secondaryHolder = [UIView new];
	secondaryHolder.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:secondaryHolder];

	self.secondaryLabel = [UILabel new];
	self.secondaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.secondaryLabel setText:self.secondaryString];
	[self.secondaryLabel setTextAlignment:NSTextAlignmentCenter];
	[secondaryHolder addSubview:self.secondaryLabel];


	UIView *tertiaryHolder = [UIView new];
	tertiaryHolder.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:tertiaryHolder];

	self.tertiaryLabel = [UILabel new];
	self.tertiaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.tertiaryLabel setText:self.tertiaryString];
	[self.tertiaryLabel setTextAlignment:NSTextAlignmentCenter];
	[tertiaryHolder addSubview:self.tertiaryLabel];


	NSDictionary *metrics = @{};
	NSDictionary *views = @{@"primaryHolder" : primaryHolder, @"primaryLabel" : self.primaryLabel, @"secondaryHolder" : secondaryHolder, @"secondaryLabel" : self.secondaryLabel, @"tertiaryHolder" : tertiaryHolder, @"tertiaryLabel" : self.tertiaryLabel};


	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[primaryHolder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[secondaryHolder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tertiaryHolder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[primaryHolder(tertiaryHolder)]-2-[secondaryHolder(primaryHolder)]-2-[tertiaryHolder(primaryHolder)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

	[primaryHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[primaryLabel]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[primaryHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[primaryLabel]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

	[secondaryHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[secondaryLabel]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[secondaryHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[secondaryLabel]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

	[tertiaryHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tertiaryLabel]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[tertiaryHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tertiaryLabel]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

}


- (void)primarySpell:(NSString *)primaryString {
	NSLog(@"primary:%@", primaryString);
	dispatch_async(dispatch_get_main_queue(), ^{

		[self.primaryLabel setText:primaryString];

	});
//	[self layoutIfNeeded];
}

- (void)secondarySpell:(NSString *)secondaryString {
	NSLog(@"secondary:%@", secondaryString);
	dispatch_async(dispatch_get_main_queue(), ^{

		[self.secondaryLabel setText:secondaryString];
	});
//	[self layoutIfNeeded];

}

- (void)tertiarySpell:(NSString *)tertiaryString {
	NSLog(@"tertiary:%@", tertiaryString);
	dispatch_async(dispatch_get_main_queue(), ^{

		[self.tertiaryLabel setText:tertiaryString];
	});
//	[self layoutIfNeeded];


}

- (void)hideView:(BOOL)shouldHide {

}

- (NSArray *)checkText:(NSString *)checkedText {
	return nil;
}


@end