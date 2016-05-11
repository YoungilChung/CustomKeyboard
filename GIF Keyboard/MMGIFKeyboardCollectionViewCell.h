//
// Created by Tom Atterton on 16/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FLAnimatedImageView;

@interface MMGIFKeyboardCollectionViewCell : UICollectionViewCell

+ (NSString *)reuseIdentifier;
@property (nonatomic, strong) FLAnimatedImageView *imageView;

-(void) setData:(NSString*)urlString;
@end