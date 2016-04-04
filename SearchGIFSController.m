//
// Created by Tom Atterton on 01/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "SearchGIFSController.h"


@implementation SearchGIFSController


+ (NSArray *)gifsFromJSON:(NSData *)objectNotation error:(NSError **)error {

	NSError *localError = nil;
	NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];

	if (localError != nil) {
		*error = localError;
		return nil;
	}

	NSDictionary *dictResults = [parsedObject valueForKey:@"data"];
	NSDictionary *imageResults = [dictResults valueForKey:@"images"];
	NSDictionary *fixedHeightResults = [imageResults valueForKey:@"fixed_width_small"]; // This is the smallest gif size
	NSArray *results = [fixedHeightResults valueForKey:@"url"];


	return results;
}

+ (NSArray *)betterGifsFromJSON:(NSData *)objectNotation error:(NSError **)error {
	NSError *localError = nil;
	NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];

	if (localError != nil) {
		*error = localError;
		return nil;
	}

	NSDictionary *dictResults = [parsedObject valueForKey:@"data"];
	NSDictionary *imageResults = [dictResults valueForKey:@"images"];
	NSDictionary *fixedHeightResults = [imageResults valueForKey:@"fixed_height"]; // This is the largest gif size
	NSArray *results = [fixedHeightResults valueForKey:@"url"];


	return results;

}


@end