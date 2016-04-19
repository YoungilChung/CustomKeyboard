//
// Created by Tom Atterton on 04/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMKeyboardSelection.h"

@protocol KeyboardDelegate <NSObject>

// Which key was tapped
- (void)keyWasTapped:(NSString *)key;

- (void)cellWasTapped:(NSString *)gifURL WithMessageTitle:(NSString *)message;

// SearchBar was tapped
- (void)searchBarTapped;

// For updating the layouts of all subviews
- (void)updateLayout;

// Used to pass reference of a button press
- (void)keyboardButtonPressed;

- (void)changeKeyboard:(keyboardTags)tag;

@end