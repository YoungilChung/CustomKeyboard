//
// Created by Tom Atterton on 01/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	kSearchTypeString = 100,
	kSearchTypeTrending,
	kSearchTypeRandom
} searchType;


@protocol SearchGifsDelegate

- (void)receivedGIFJSON:(NSData *)objectNotation;
- (void)fetchingJSONFailedWithError:(NSError *)error;

@end


@interface SearchForGIFSCommunicator : NSObject

@property(weak, nonatomic) id <SearchGifsDelegate> delegate;

- (void)searchForGIFS:(NSString *)searchString withSearchType:(searchType)searchType;

@end