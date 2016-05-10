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

typedef enum {
	kChangeLanguageEnglish = 70,
	kChangeLanguageDutch,
} changeLanguage;

@interface MMKeyboardSelection : UIView


@property(nonatomic, weak) id <KeyboardDelegate> keyboardDelegate;

- (void)updatePosition:(CGPoint)position;

- (void)selectedRowWithIndexPath:(NSIndexPath *)indexPath;

@property(nonatomic, strong) UITableView *tableView;


@end
