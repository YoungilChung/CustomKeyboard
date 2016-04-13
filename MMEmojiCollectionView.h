//
// Created by Tom Atterton on 13/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MMEmojiCollectionView : UIView


@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, assign) CGSize keyboardCollectionViewSize;
-(void)layoutSubviewsEmoji;

@end