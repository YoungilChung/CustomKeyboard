//
// Created by Tom Atterton on 05/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SpellCheckerCommunicator : NSObject

@property (nonatomic, copy) NSString* word;
@property (nonatomic) NSUInteger likelihood;
+ (instancetype)resultWithWord:(NSString*)word likelihood:(NSUInteger)likelihood;

@end