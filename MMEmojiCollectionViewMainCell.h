//
// Created by Tom Atterton on 15/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol EmojiKeyboardDelegate;


@interface MMEmojiCollectionViewMainCell : UICollectionViewCell

+ (NSString *)reuseIdentifier;

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, assign) NSUInteger pageNumber;


@property(nonatomic, weak) id <EmojiKeyboardDelegate> emojiKeyboardDelegate;


@end