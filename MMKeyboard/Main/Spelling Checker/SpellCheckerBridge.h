//
// Created by Tom Atterton on 06/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SpellCheckerBridge : NSObject

+ (void)loadForSpellCorrection;
+ (NSArray*)correctionsForText:(NSString*)text;

@end