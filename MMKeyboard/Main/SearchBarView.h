//
// Created by Tom Atterton on 31/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MMkeyboardButton;
@class MMCustomTextField;

@interface SearchBarView : UIView

@property(nonatomic, strong) MMCustomTextField *searchBar;
@property(nonatomic, strong) MMkeyboardButton *gifButton;

@end