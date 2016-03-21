//
// Created by Tom Atterton on 18/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ShareViewController;

@interface ShareCollectionView : UIView

// Views
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UIView *emptyCellView;

// Variables
@property(nonatomic, strong) NSMutableArray *data;
@property(nonatomic, strong) NSString *gifURL;
@property(nonatomic, strong) NSIndexPath *currentIndexPath;

// Public Methods
- (void)normalButtonPressed;
- (void)awesomeButtonPressed;
- (void)loadGifs;
- (void)currentIndexPathMethod;


- (instancetype)initWithPresentingViewController:(ShareViewController *)shareViewController;

@end