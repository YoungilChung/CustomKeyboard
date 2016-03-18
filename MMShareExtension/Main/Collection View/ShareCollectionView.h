//
// Created by Tom Atterton on 18/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ShareViewController;

typedef NS_ENUM(NSInteger, MMSearchType) {
	MMSearchTypeAll = 0,
	MMSearchTypeNormal,
	MMSearchTypeAwesome,

};

@interface ShareCollectionView : UIView
@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong) NSMutableArray *data;

@property(nonatomic, strong) UIView *emptyCellView;

- (instancetype)initWithPresentingViewController:(ShareViewController *)shareViewController;

- (void)normalButtonPressed;

- (void)awesomeButtonPressed;

- (void)loadGifs;
@end