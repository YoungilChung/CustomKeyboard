//
// Created by Tom Atterton on 01/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "SearchGIFSController.h"


@implementation SearchGIFSController


+ (NSArray *)gifsFromJSON:(NSData *)objectNotation withSearchType:(searchType)searchType error:(NSError **)error {

	NSError *localError = nil;
	NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];

	if (localError != nil) {
		*error = localError;
		return nil;
	}
	NSArray *results = @[];
	NSDictionary *dictResults = [parsedObject valueForKey:@"data"];

	switch (searchType) {

		case kSearchTypeString:
		case kSearchTypeTrending: {


			NSDictionary *imageResults = [dictResults valueForKey:@"images"];
			NSDictionary *fixedHeightResults = [imageResults valueForKey:@"fixed_width_downsampled"]; // This is the smallest gif size
			results = [fixedHeightResults valueForKey:@"url"];

			break;
		}

		case kSearchTypeRandom: {
			results = [dictResults valueForKey:@"fixed_width_downsampled_url"];

			break;
		}

		default: {

			break;
		}
	}


	return results;
}


@end