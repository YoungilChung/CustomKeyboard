//
// Created by Tom Atterton on 16/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class KeyboardViewController;

typedef NS_ENUM(NSInteger, MMSearchType) {
	MMSearchTypeAll = 0,
	MMSearchTypeNormal,
	MMSearchTypeAwesome,

};

@interface MMKeyboardCollectionView : UIView

@property (nonatomic, strong) NSString *gifURL;


@property(nonatomic, strong) UICollectionView *keyboardCollectionView;
@property(nonatomic, assign) CGSize keyboardCollectionViewSize;

- (instancetype)initWithPresentingViewController:(KeyboardViewController *)presentingViewController;

- (void)onAllGifsButtonTapped:(UIButton *)sender;

- (void)onNormalButtonTapped:(UIButton *)sender;

- (void)onAwesomeButtonTapped:(UIButton *)sender;

- (void)willRotateKeyboard:(UIInterfaceOrientation)toInterfaceOrientation;

- (void)loadGifs;


@end