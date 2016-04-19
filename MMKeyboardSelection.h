//
// Created by Tom Atterton on 18/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol KeyboardDelegate;



typedef enum {
	kTagSwitchKeyboard = 100,
	kTagEmojiKeyboard,
} keyboardTags;

@interface MMKeyboardSelection : UIView


@property(nonatomic, weak) id <KeyboardDelegate> keyboardDelegate;


@end
