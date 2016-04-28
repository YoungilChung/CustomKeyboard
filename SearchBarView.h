//
// Created by Tom Atterton on 31/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MMKeyboardButton;
@class MMCustomTextField;
@protocol KeyboardDelegate;

@interface SearchBarView : UIView

// Views
@property(nonatomic, strong) MMCustomTextField *searchBar;
@property(nonatomic, strong) MMKeyboardButton *gifButton;
@property(nonatomic, assign) BOOL shouldContinueBlinking;

// Delegate
@property(nonatomic, weak) id <KeyboardDelegate> keyboardDelegate;

@property(nonatomic, strong) NSLayoutConstraint *leftCaretConstraint;
@end