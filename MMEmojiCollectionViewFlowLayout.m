//
// Created by Tom Atterton on 13/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMEmojiCollectionViewFlowLayout.h"


@implementation MMEmojiCollectionViewFlowLayout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)offset
								 withScrollingVelocity:(CGPoint)velocity {

	CGRect cvBounds = self.collectionView.bounds;
	CGFloat halfWidth = (CGFloat) (cvBounds.size.width * 0.25);
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