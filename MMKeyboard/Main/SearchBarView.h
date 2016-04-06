//
// Created by Tom Atterton on 31/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MMkeyboardButton;
@class MMCustomTextField;
@protocol KeyboardDelegate;

@interface SearchBarView : UIView

// Views
@property(nonatomic, strong) MMCustomTextField *searchBar;
@property(nonatomic, strong) MMkeyboardButton *gifButton;

// Delegate
@property(nonatomic, weak) id <KeyboardDelegate> keyboardDelegate;

@end