//
// Created by Tom Atterton on 17/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMKeyboardCollectionViewFlowLayout.h"

@interface MMKeyboardCollectionViewFlowLayout()
@property (nonatomic,strong)NSIndexPath* pathForFocusItem;

@end
@implementation MMKeyboardCollectionViewFlowLayout

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
{
	if (self.pathForFocusItem) {
		UICollectionViewLayoutAttributes* layoutAttrs = [self layoutAttributesForItemAtIndexPath:self.pathForFocusItem];
		return CGPointMake(layoutAttrs.frame.origin.x - self.collectionView.contentInset.left, layoutAttrs.frame.origin.y-self.collectionView.contentInset.top);
	}else{
		return [super targetContentOffsetForProposedContentOffset:proposedContentOffset];
	}
}
@end