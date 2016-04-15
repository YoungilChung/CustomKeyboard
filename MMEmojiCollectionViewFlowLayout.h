//
// Created by Tom Atterton on 13/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MMEmojiCollectionViewFlowLayout : UICollectionViewFlowLayout

// properties to configure the size and spacing of the grid
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat itemSpacing;

// this method was used because I was switching between layouts
- (void)configureCollectionViewForLayout:(UICollectionView *)collectionView;

@end