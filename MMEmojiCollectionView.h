//
// Created by Tom Atterton on 13/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol KeyboardDelegate;

@interface MMEmojiCollectionView : UIView

@property(nonatomic, strong) UICollectionView *mainCollectionView;
@property(nonatomic, weak) id <KeyboardDelegate> keyboardDelegate;

@property(nonatomic, assign) CGSize emojiCollectionViewSize;


@end