//
// Created by Tom Atterton on 13/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMEmojiCollectionViewFlowLayout.h"

@interface MMEmojiCollectionViewFlowLayout()
@property (nonatomic, strong) NSDictionary *layoutInfo;

@end

@implementation MMEmojiCollectionViewFlowLayout





//- (id)init
//{
//	self = [super init];
//	if (self) {
//		[self setup];
//	}
//
//	return self;
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//	self = [super init];
//	if (self) {
//		[self setup];
//	}
//
//	return self;
//}
//
//
//- (void)setup
//{
//	self.itemSize = CGSizeMake(50.0, 50.0);
//	self.itemSpacing = 10.0;
//}
//
//- (void)configureCollectionViewForLayout:(UICollectionView *)collectionView
//{
//	collectionView.alwaysBounceHorizontal = YES;
//
//	[collectionView setCollectionViewLayout:self animated:NO];
//}
//
//- (void)prepareLayout
//{
//	NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
//
//	NSInteger sectionCount = [self.collectionView numberOfSections];
//	NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
//
//	for (NSInteger section = 0; section < sectionCount; section++) {
//		NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
//
//		for (NSInteger item = 0; item < itemCount; item++) {
//			indexPath = [NSIndexPath indexPathForItem:item inSection:section];
//
//			UICollectionViewLayoutAttributes *itemAttributes =
//					[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//			itemAttributes.frame = [self frameForIndexPath:indexPath];
//
//			cellLayoutInfo[indexPath] = itemAttributes;
//		}
//	}
//
//	self.layoutInfo = cellLayoutInfo;
//}
//
//- (CGRect)frameForIndexPath:(NSIndexPath *)indexPath
//{
//	NSInteger column = indexPath.section;
//	NSInteger row = indexPath.item;
//
//	CGFloat originX = column * (self.itemSize.width + self.itemSpacing);
//	CGFloat originY = row * (self.itemSize.height + self.itemSpacing);
//
//	return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
//}
//
//- (CGSize)collectionViewContentSize
//{
//	NSInteger sectionCount = [self.collectionView numberOfSections];
//
//	if (sectionCount == 0) {
//		return CGSizeZero;
//	}
//
//	NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
//
//	CGFloat width = (self.itemSize.width + self.itemSpacing) * sectionCount - self.itemSpacing;
//	CGFloat height = (self.itemSize.height + self.itemSpacing) * itemCount - self.itemSpacing;
//
//	return CGSizeMake(width, height);
//}
//
//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//	return self.layoutInfo[indexPath];
//}
//
//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//	NSMutableArray *allAttributes = [NSMutableArray array];
//
//	[self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *stop) {
//		if (CGRectIntersectsRect(attributes.frame, rect)) {
//			[allAttributes addObject:attributes];
//		}
//	}];
//
//	return allAttributes;
//}



- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)offset
								 withScrollingVelocity:(CGPoint)velocity {

	CGRect cvBounds = self.collectionView.bounds;
	CGFloat halfWidth = (CGFloat) (cvBounds.size.width * 0.5);
	CGFloat proposedContentOffsetCenterX = offset.x + halfWidth;

	NSArray *attributesArray = [self layoutAttributesForElementsInRect:cvBounds];

	UICollectionViewLayoutAttributes *candidateAttributes;
	for (UICollectionViewLayoutAttributes *attributes in attributesArray) {

		// == Skip comparison with non-cell items (headers and footers) == //
		if (attributes.representedElementCategory !=
				UICollectionElementCategoryCell) {
			continue;
		}

		// == First time in the loop == //
		if (!candidateAttributes) {
			candidateAttributes = attributes;
			continue;
		}

		if (fabsf(attributes.center.x - proposedContentOffsetCenterX) <
				fabsf(candidateAttributes.center.x - proposedContentOffsetCenterX)) {
			candidateAttributes = attributes;
		}
	}

	return CGPointMake(candidateAttributes.center.x - halfWidth, offset.y);

}
@end