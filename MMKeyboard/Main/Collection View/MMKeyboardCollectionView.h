//
// Created by Tom Atterton on 16/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , MMSearchType){
	MMSearchTypeAll = 0,
	MMSearchTypeNormal,
	MMSearchTypeAwesome,

};
@interface MMKeyboardCollectionView : UIView

-(instancetype)initWithPresentingViewController;


@end