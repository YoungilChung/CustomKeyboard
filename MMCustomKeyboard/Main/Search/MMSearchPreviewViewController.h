//
// Created by Tom Atterton on 11/05/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FLAnimatedImage;

@interface MMSearchPreviewViewController : UIViewController

- (instancetype)initWithAnimatedImage:(FLAnimatedImage *)animatedImage withURL:(NSString *)urlString;

@end