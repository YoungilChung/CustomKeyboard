//
// Created by Tom Atterton on 13/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum {
	kTagEmojiSmiley = 0,
	kTagEmojiNature,
	kTagEmojiFood,
	kTagEmojiSport,
	kTagEmojiPlaces,
	kTagEmojiObjects,
	kTagEmojiSymbol,
	kTagEmojiFlags,
	kTagEmojiKeyboard,
	kTagEmojiDelete,
} EmojiButtonTag;
@interface MMEmojiCategoryHolder : UIView

// Views
@property(nonatomic, strong) UIButton *keyboardButton;
@property(nonatomic, strong) UIButton *deleteButton;
@property(nonatomic, strong) UIButton *smileyButton;
@property(nonatomic, strong) UIButton *natureButton;
@property(nonatomic, strong) UIButton *foodButton;
@property(nonatomic, strong) UIButton *sportButton;
@property(nonatomic, strong) UIButton *placesButton;
@property(nonatomic, strong) UIButton *objectsButton;
@property(nonatomic, strong) UIButton *symbolButton;
@property(nonatomic, strong) UIButton *flagsButton;
@end