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


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
	return YES;
}
@end