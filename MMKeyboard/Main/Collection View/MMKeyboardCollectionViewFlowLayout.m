//
// Created by Tom Atterton on 17/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMKeyboardCollectionViewFlowLayout.h"

@interface MMKeyboardCollectionViewFlowLayout()
@property (nonatomic,strong)NSIndexPath* pathForFocusItem;

@end
@implementation MMKeyboardCollectionViewFlowLayout

//-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
//{
//	if (self.pathForFocusItem) {
//		UICollectionViewLayoutAttributes* layoutAttrs = [self layoutAttributesForItemAtIndexPath:self.pathForFocusItem];
//		return CGPointMake(layoutAttrs.frame.origin.x - self.collectionView.contentInset.left, layoutAttrs.frame.origin.y-self.collectionView.contentInset.top);
//	}else{
//		return [super targetContentOffsetForProposedContentOffset:proposedContentOffset];
//	}
//}

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



@end