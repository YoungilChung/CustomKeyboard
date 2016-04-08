//
// Created by Tom Atterton on 01/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SearchGifsDelegate

- (void)recievedGIFJSON:(NSData *)objectNotation;
- (void)fetchingJSONFailedWithError:(NSError *)error;

@end


@interface SearchForGIFSCommunicator : NSObject

@property(weak, nonatomic) id <SearchGifsDelegate> delegate;

- (void)searchForGifs:(NSString *)searchString;

@end