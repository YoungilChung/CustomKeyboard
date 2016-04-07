//
// Created by Tom Atterton on 05/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SpellCheckerDelegate;


@interface SpellCheckerManager : NSObject


@property(nonatomic, strong) NSString *primaryString;
@property(nonatomic, strong) NSString *secondaryString;
@property(nonatomic, strong) NSString *tertiaryString;

// Delegate
@property(nonatomic, weak) id <SpellCheckerDelegate> delegate;

- (void)loadForSpellCorrection;

- (void)fetchWords:(NSString *)queryString;


@end