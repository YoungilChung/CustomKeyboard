//
// Created by Tom Atterton on 16/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SearchGIFManager;
@protocol KeyboardDelegate;

typedef NS_ENUM(NSUInteger, MMSearchType) {
	MMSearchTypeAll = 200,
	MMSearchTypeNormal,
	MMSearchTypeAwesome,
	MMSearchTypeGiphy,

};

@interface MMGIFKeyboardCollectionView : UIView


// Manger
@property(nonatomic, strong) SearchGIFManager *searchManager;

// Views
@property(nonatomic, strong) UICollectionView *keyboardCollectionView;

// Variables
@property(nonatomic, assign) CGSize keyboardCollectionViewSize;
@property(nonatomic, strong) NSString *gifURL;
@property(nonatomic, assign) NSUInteger type;
@property(nonatomic, weak) id <KeyboardDelegate> keyboardDelegate;

- (void)loadGIFS;


@end