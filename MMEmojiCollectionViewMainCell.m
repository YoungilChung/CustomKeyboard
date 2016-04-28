//
// Created by Tom Atterton on 15/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMEmojiCollectionViewMainCell.h"
#import "MMEmojiCollectionViewCell.h"
#import "MMEmojiCollectionViewFlowLayout.h"
#import "MMKeyboardKeysModel.h"
#import "UIImage+emoji.h"
#import "EmojiKeyboardDelegate.h"


@interface MMEmojiCollectionViewMainCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) UICollectionViewFlowLayout *collectionFlowLayout;
@property(nonatomic, strong) MMKeyboardKeysModel *keyboardKeysModel;
//@property(nonatomic, weak) NSMutableArray *emojiArray;

@end

@implementation MMEmojiCollectionViewMainCell


- (instancetype)initCellWithPageNumber:(NSUInteger)pageNumber {
	self = [super init];

	if (self) {

		self.keyboardKeysModel = [[MMKeyboardKeysModel alloc] init];
//		self.emojiArray = [self.keyboardKeysModel.emojiTilesSmiley mutableCopy];
		self.pageNumber = pageNumber;
		[self setup];
	}

	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	if (self) {
		self.keyboardKeysModel = [[MMKeyboardKeysModel alloc] init];
//		self.emojiArray = [self.keyboardKeysModel.emojiTilesSmiley mutableCopy];
		[self setup];
	}

	return self;
}

- (void)setData:(NSUInteger)page {
	self.pageNumber = page;
	[self.collectionView reloadData];

}


- (void)setup {

	self.translatesAutoresizingMaskIntoConstraints = NO;
	self.clipsToBounds = YES;
	self.collectionFlowLayout = [UICollectionViewFlowLayout new];
//   self.collectionFlowLayout.itemSize = CGSizeMake(50,50);
	[self.collectionFlowLayout setMinimumInteritemSpacing:0];
	[self.collectionFlowLayout setMinimumLineSpacing:0];
	[self.collectionFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

	self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionFlowLayout];
	self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.collectionView registerClass:[MMEmojiCollectionViewCell class] forCellWithReuseIdentifier:[MMEmojiCollectionViewCell reuseIdentifier]];
	self.collectionView.backgroundColor = [UIColor blackColor];
	[self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	[self addSubview:self.collectionView];


	NSDictionary *metrics = @{};
	NSDictionary *views = @{
			@"collectionView" : self.collectionView,
	};

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[collectionView]-10-|" options:kNilOptions metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collectionView]-0-|" options:kNilOptions metrics:metrics views:views]];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [self.keyboardKeysModel.emojiTilesSmiley[self.pageNumber] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	MMEmojiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MMEmojiCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
	[cell setBackgroundColor:[UIColor clearColor]];

	NSUInteger item = (NSUInteger) indexPath.item;
	UIImage *image = [UIImage imageWithEmoji:self.keyboardKeysModel.emojiTilesSmiley[self.pageNumber][item] withSize:26];
	cell.imageView.alpha = 0.f;

	if (image) {
		[cell.imageView setImage:image];
		cell.imageView.alpha = 1.f;
		return cell;
	}
//	[cell setNeedsDisplay];
	[cell layoutIfNeeded];

	return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

	NSUInteger item = (NSUInteger) indexPath.item;
	[self.emojiKeyboardDelegate keyWasTapped:self.keyboardKeysModel.emojiTilesSmiley[self.pageNumber][item]];

}

+ (NSString *)reuseIdentifier {
	return @"MainCell";
}


@end