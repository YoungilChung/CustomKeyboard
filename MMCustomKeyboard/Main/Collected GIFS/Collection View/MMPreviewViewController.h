//
// Created by Tom Atterton on 14/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FLAnimatedImageView;
@class GIFEntity;
@class FLAnimatedImage;


@interface MMPreviewViewController : UIViewController

- (instancetype)initWithAnimatedImage:(FLAnimatedImage *)animatedImage withGifEntity:(GIFEntity *)gifEntity;

@end