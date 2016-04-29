//
// Created by Tom Atterton on 13/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMEmojiCollectionViewFlowLayout.h"

@interface MMEmojiCollectionViewFlowLayout()
@property (nonatomic, strong) NSDictionary *layoutInfo;

@end

@implementation MMEmojiCollectionViewFlowLayout


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

		if (fabs(attributes.center.x - proposedContentOffsetCenterX) <
				fabs(candidateAttributes.center.x - proposedContentOffsetCenterX)) {
			candidateAttributes = attributes;
		}
	}

	return CGPointMake(candidateAttributes.center.x - halfWidth, offset.y);

}
@end