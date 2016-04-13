//
// Created by Tom Atterton on 13/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMEmojiCollectionView.h"
#import "MMEmojiCollectionViewCell.h"
#import "MMEmojiCategoryHolder.h"
#import "MMEmojiCollectionViewFlowLayout.h"
#import "MMKeyboardKeysModel.h"
#import "UIImage+emoji.h"


@interface MMEmojiCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

//Views

@property(nonatomic, strong) MMEmojiCollectionViewFlowLayout *collectionFlowLayout;
@property(nonatomic, strong) MMEmojiCategoryHolder *emojiCategoryHolder;
@property(nonatomic, strong) UIScrollView *scrollView;

//Variables
@property(nonatomic, strong) MMKeyboardKeysModel *keyboardKeysModel;
@property(nonatomic, strong) NSMutableArray *collectionArray;
@property(nonatomic, assign) NSUInteger pageNumber;

@property(nonatomic, strong) NSLayoutConstraint *heightConstraint;
@end

@implementation MMEmojiCollectionView


- (instancetype)init {

	self = [super init];

	if (self) {
		self.keyboardKeysModel = [[MMKeyboardKeysModel alloc] init];

		[self setup];

	}

	return self;

}


- (void)setup {
	[self setTranslatesAutoresizingMaskIntoConstraints:NO];


	[self.collectionArray addObject:self.keyboardKeysModel.emojiTilesSmiley];
	self.pageNumber = 0;

	self.scrollView = [UIScrollView new];
	[self.scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
//	self.scrollView.clipsToBounds = YES;
	[self.scrollView setBackgroundColor:[UIColor yellowColor]];
	[self addSubview:self.scrollView];


	self.emojiCategoryHolder = [MMEmojiCategoryHolder new];
	[self.emojiCategoryHolder setTranslatesAutoresizingMaskIntoConstraints:NO];

	[self addSubview:self.emojiCategoryHolder];


	self.collectionFlowLayout = [MMEmojiCollectionViewFlowLayout new];
	[self.collectionFlowLayout setMinimumInteritemSpacing:0];
	[self.collectionFlowLayout setMinimumLineSpacing:0];
	[self.collectionFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

	self.collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:self.collectionFlowLayout];

	self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.collectionView registerClass:[MMEmojiCollectionViewCell class] forCellWithReuseIdentifier:[MMEmojiCollectionViewCell reuseIdentifier]];
	self.collectionView.backgroundColor = [UIColor blackColor];
	self.collectionView.clipsToBounds = YES;
	[self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	[self.scrollView addSubview:self.collectionView];

	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
	tapGestureRecognizer.delegate = self;
	tapGestureRecognizer.delaysTouchesBegan = YES;
	[self.collectionView addGestureRecognizer:tapGestureRecognizer];

	NSDictionary *metrics = @{};
	NSDictionary *views = @{
			@"collectionView" : self.collectionView, @"categoryHolder" : self.emojiCategoryHolder, @"scrollView" : self.scrollView
	};

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[scrollView]-0-[categoryHolder(==40)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
//	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[categoryHolder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[scrollView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	[self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collectionView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
//	[self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
//	self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
//	[self addConstraint:self.heightConstraint];
//	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:800]];


	[self.collectionArray[self.pageNumber] reloadData];
	NSLog(@"array of strings%@", self.collectionArray[0]);
	NSLog(@"array of strings%@", self.keyboardKeysModel.emojiTilesSmiley[self.pageNumber]);

}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [self.keyboardKeysModel.emojiTilesSmiley[self.pageNumber] count];
}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//	return CGSizeMake((CGFloat) (self.collectionView.layer.frame.size.width / 7), (CGFloat) (self.collectionView.layer.frame.size.height / 7));
//
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

	MMEmojiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MMEmojiCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
	[cell setBackgroundColor:[UIColor clearColor]];

	NSUInteger item = (NSUInteger) indexPath.item;
	UIImage *image = [UIImage imageWithEmoji:self.keyboardKeysModel.emojiTilesSmiley[self.pageNumber][item] withSize:46];
	cell.imageView.alpha = 0.f;

	if (image) {
		[cell.imageView setImage:image];
		cell.imageView.alpha = 1.f;
		return cell;
	}

	[cell layoutIfNeeded];

	return cell;
}


#pragma mark Touch Gestures

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
	CGPoint p = [sender locationInView:self.collectionView];
	NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];

//	if (self.type == MMSearchTypeGiphy) {
//
//		self.gifURL = self.higherQualityGif[(NSUInteger) indexPath.row];
//	}
//	else {
//
//		self.gifURL = [self.data valueForKey:@"gifURL"][(NSUInteger) indexPath.row];
//	}
//
//	NSLog(@"gifURL:%@", self.gifURL);
//	[self.keyboardDelegate cellWasTapped:self.gifURL WithMessageTitle:@"URL Copied"];

//	[self.presentingViewController tappedGIF];
//	[self.keyboardDelegate cellWasTapped:];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGFloat pageWidth = scrollView.frame.size.width;
	self.pageNumber = (NSUInteger) lround(scrollView.contentOffset.x / pageWidth);;

	[self.collectionArray[self.pageNumber] reloadData];


}

- (void)layoutSubviewsEmoji {
	[self.scrollView setContentSize:CGSizeMake(7 * self.scrollView.frame.size.width, 600)];
//	self.heightConstraint.constant = 500;
	[self layoutIfNeeded];
}


@end