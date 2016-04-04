//
// Created by Tom Atterton on 01/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "SearchGIFManager.h"
#import "SearchGIFSController.h"


@implementation SearchGIFManager


- (void)fetchGIFSForSearchQuery:(NSString *)searchString {

	[self.communicator searchForGifs:searchString];
}

- (void)recievedGIFJSON:(NSData *)objectNotation {


	NSError *error = nil;
	NSArray *groups = [SearchGIFSController gifsFromJSON:objectNotation error:&error];
	NSArray *sendGroups = [SearchGIFSController betterGifsFromJSON:objectNotation error:&error];

	if (error != nil) {
		[self.delegate fetchingGIFSFailedWithError:error];

	} else {
		[self.delegate didReceiveGIFS:groups didReceiveSendGifs:sendGroups];
	}
}

- (void)fetchingJSONFailedWithError:(NSError *)error {
	[self.delegate fetchingGIFSFailedWithError:error];

}


@end