//
// Created by Tom Atterton on 13/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface MMEmojiCollectionViewCell : UICollectionViewCell

+ (NSString *)reuseIdentifier;
@property (nonatomic, strong) UIImageView *imageView;

@end