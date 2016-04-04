//
// Created by Tom Atterton on 31/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MMkeyboardButton;
@class MMCustomTextField;

@interface SearchBarView : UIView

// Views
@property(nonatomic, strong) MMCustomTextField *searchBar;
@property(nonatomic, strong) MMkeyboardButton *gifButton;
@property(nonatomic, strong) MMkeyboardButton *allButton;
@property(nonatomic, strong) MMkeyboardButton *normalButton;
@property(nonatomic, strong) MMkeyboardButton *awesomeButton;

@property(nonatomic, strong) NSLayoutConstraint *allButtonLeftConstraint;

@property(nonatomic, strong) NSLayoutConstraint *normalButtonLeftConstraint;
@property(nonatomic, strong) NSLayoutConstraint *awesomeButtonLeftConstraint ;

-(void) animateButtonsOut: (BOOL)isOut;

@end