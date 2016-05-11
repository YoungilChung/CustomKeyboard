//
//  collectionViewFlowLayout.m
//  MMCustomKeyboard
//
//  Created by mm0030240 on 04/11/15.
//  Copyright © 2015 mm0030240. All rights reserved.
//

#import "MMCollectionViewFlowLayout.h"

@implementation MMCollectionViewFlowLayout



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


-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

@end
