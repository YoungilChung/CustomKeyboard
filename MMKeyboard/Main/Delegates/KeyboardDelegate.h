//
// Created by Tom Atterton on 04/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KeyboardDelegate <NSObject>

- (void)keyWasTapped:(NSString *)key;

- (void)cellWasTapped:(NSString *)gifURL WithMessageTitle:(NSString *)message;

- (void)searchBarTapped;

- (void)updateLayout;

@end