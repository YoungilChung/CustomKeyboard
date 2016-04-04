//
// Created by Tom Atterton on 23/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol KeyboardDelegate;
@class MMkeyboardButton;


@interface MMAlphaKeyboardView : UIInputView

@property(nonatomic, strong) UIImageView *keyboardImageView;

@property(nonatomic, strong) UIImage *keyboardImage;

// Delegate
@property(nonatomic, weak) id <KeyboardDelegate> keyboardDelegate;

@property(nonatomic, strong) MMkeyboardButton *nextKeyboardButton;
@end