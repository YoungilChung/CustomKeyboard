//
// Created by Tom Atterton on 01/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "SearchGIFManager.h"
#import "SearchGIFSController.h"


@implementation SearchGIFManager


- (void)fetchGIFSForSearchQuery:(NSString *)searchString withSearchType:(searchType)searchType {

	[self.communicator searchForGIFS:searchString withSearchType:searchType];
}

- (void)receivedGIFJSON:(NSData *)objectNotation withSearchType:(searchType)searchType {

	NSError *error = nil;
	NSArray *groups = [SearchGIFSController gifsFromJSON:objectNotation withSearchType:searchType error:&error];

	if (error != nil) {
		[self.delegate fetchingGIFSFailedWithError:error];

	} else {
		[self.delegate didReceiveGIFS:groups];
	}
}

- (void)fetchingJSONFailedWithError:(NSError *)error {
	[self.delegate fetchingGIFSFailedWithError:error];

}


@end