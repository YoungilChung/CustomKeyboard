//
// Created by Tom Atterton on 13/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMEmojiCollectionView.h"
#import "MMEmojiCategoryHolder.h"
#import "MMEmojiCollectionViewFlowLayout.h"
#import "MMEmojiCollectionViewMainCell.h"
#import "KeyboardDelegate.h"
#import "EmojiKeyboardDelegate.h"


@interface MMEmojiCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, UIScrollViewDelegate, EmojiKeyboardDelegate>

//Views

@property(nonatomic, strong) MMEmojiCollectionViewFlowLayout *collectionFlowLayout;
@property(nonatomic, strong) MMEmojiCategoryHolder *emojiCategoryHolder;

@end

@implementation MMEmojiCollectionView


- (instancetype)init {

	self = [super init];

	if (self) {

		[self setup];

	}

	return self;

}


- (void)setup {
	[self setTranslatesAutoresizingMaskIntoConstraints:NO];

	self.emojiCategoryHolder = [MMEmojiCategoryHolder new];
	[self.emojiCategoryHolder setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.emojiCategoryHolder.keyboardButton addTarget:self action:@selector(keyboardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.emojiCategoryHolder.deleteButton addTarget:self action:@selector(keyboardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

	[self.emojiCategoryHolder.smileyButton addTarget:self action:@selector(keyboardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.emojiCategoryHolder.natureButton addTarget:self action:@selector(keyboardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.emojiCategoryHolder.foodButton addTarget:self action:@selector(keyboardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.emojiCategoryHolder.sportButton addTarget:self action:@selector(keyboardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.emojiCategoryHolder.placesButton addTarget:self action:@selector(keyboardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.emojiCategoryHolder.objectsButton addTarget:self action:@selector(keyboardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.emojiCategoryHolder.symbolButton addTarget:self action:@selector(keyboardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.emojiCategoryHolder.flagsButton addTarget:self action:@selector(keyboardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:self.emojiCategoryHolder];

	self.collectionFlowLayout = [MMEmojiCollectionViewFlowLayout new];
	[self.collectionFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

	self.mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionFlowLayout];
	self.mainCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.mainCollectionView registerClass:[MMEmojiCollectionViewMainCell class] forCellWithReuseIdentifier:[MMEmojiCollectionViewMainCell reuseIdentifier]];
	self.mainCollectionView.backgroundColor = [UIColor blackColor];
	[self.mainCollectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
	self.mainCollectionView.delegate = self;
	self.mainCollectionView.dataSource = self;
	[self addSubview:self.mainCollectionView];

	NSDictionary *metrics = @{};
	NSDictionary *views = @{
			@"collectionView" : self.mainCollectionView, @"categoryHolder" : self.emojiCategoryHolder,
	};

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[categoryHolder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collectionView]-0-[categoryHolder(==40)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

}

- (void)keyboardButtonPressed:(UIButton *)sender {
	switch (sender.tag) {

		case kTagEmojiExit: {

			[self.keyboardDelegate keyboardButtonPressed];
			break;
		}
		case kTagEmojiDelete: {

			[self.keyboardDelegate keyWasTapped:@"⌫"];
			break;
		}


		default: {
			[self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:sender.tag inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
			break;
		}

	}
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 8;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//	return CGSizeMake((CGFloat) self.layer.frame.size.width, (CGFloat) self.layer.frame.size.height);
	return self.emojiCollectionViewSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

	MMEmojiCollectionViewMainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MMEmojiCollectionViewMainCell reuseIdentifier] forIndexPath:indexPath];

	[cell setBackgroundColor:[UIColor clearColor]];
	cell.emojiKeyboardDelegate = self;

	NSUInteger item = (NSUInteger) indexPath.item;

	cell.pageNumber = item;

	[cell.collectionView reloadData];
	return cell;
}

- (void)keyWasTapped:(NSString *)key {

	[self.keyboardDelegate keyWasTapped:key];

}


@end