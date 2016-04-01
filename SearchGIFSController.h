//
// Created by Tom Atterton on 01/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SearchGIFSController : NSObject

+ (NSArray *)gifsFromJSON:(NSData *)objectNotation error:(NSError **)error;

@end