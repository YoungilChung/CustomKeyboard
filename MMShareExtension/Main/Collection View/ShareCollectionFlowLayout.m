//
// Created by Tom Atterton on 18/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "ShareCollectionFlowLayout.h"


@implementation ShareCollectionFlowLayout


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
	NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
	NSMutableArray *newAttributes = [NSMutableArray arrayWithCapacity:attributes.count];
	for (UICollectionViewLayoutAttributes *attribute in attributes) {
		if ((attribute.frame.origin.x + attribute.frame.size.width <= self.collectionViewContentSize.width) &&
				(attribute.frame.origin.y + attribute.frame.size.height <= self.collectionViewContentSize.height)) {
			[newAttributes addObject:attribute];
		}
	}
	return newAttributes;
}
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)offset
								 withScrollingVelocity:(CGPoint)velocity {

	CGRect cvBounds = self.collectionView.bounds;
	CGFloat halfWidth = cvBounds.size.width * 0.5f;
	CGFloat proposedContentOffsetCenterX = offset.x + halfWidth;

	NSArray* attributesArray = [self layoutAttributesForElementsInRect:cvBounds];

	UICollectionViewLayoutAttributes* candidateAttributes;
	for (UICollectionViewLayoutAttributes* attributes in attributesArray) {

		// == Skip comparison with non-cell items (headers and footers) == //
		if (attributes.representedElementCategory !=
				UICollectionElementCategoryCell) {
			continue;
		}

		// == First time in the loop == //
		if(!candidateAttributes) {
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
//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
//{
//	CGFloat offsetAdjustment = MAXFLOAT;
//	CGFloat horizontalOffset = proposedContentOffset.x + 5;
//
//	CGRect targetRect = CGRectMake(proposedContentOffset.x, 0, self.gifKeyboardView.bounds.size.width, self.gifKeyboardView.bounds.size.height);
//
//	NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
//
//	for (UICollectionViewLayoutAttributes *layoutAttributes in array) {
//		CGFloat itemOffset = layoutAttributes.frame.origin.x;
//		if (ABS(itemOffset - horizontalOffset) < ABS(offsetAdjustment)) {
//			offsetAdjustment = itemOffset - horizontalOffset;
//		}
//	}
//
//	return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
//}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
	return YES;
}
@end