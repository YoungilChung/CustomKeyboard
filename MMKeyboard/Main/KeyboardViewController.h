//
//  KeyboardViewController.h
//  MMKeyboard
//
//  Created by mm0030240 on 06/10/15.
//  Copyright © 2015 mm0030240. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMAlphaKeyboardView;

@interface KeyboardViewController : UIInputViewController

@property(nonatomic, strong) NSString *gifURL;
@property(nonatomic, strong) UIButton *normalButton;
@property(nonatomic, strong) UIButton *awesomeButton;
@property(nonatomic, strong) UIButton *allGifsButton;
// Views
@property(nonatomic, strong) UIView *menuHolder;
@property(nonatomic, strong) UIView *searchHolder;

@property(nonatomic, strong) UIButton *abcButton;

@property(nonatomic, strong) MMAlphaKeyboardView *customKeyboard;


@property(nonatomic, strong) UIView *customKeyboardHolder;

@property(nonatomic, strong) NSLayoutConstraint *customeKeyboardLeftConstraint;

-(void)tappedGIF;


@end
