//
// Created by Tom Atterton on 01/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "SearchForGIFSCommunicator.h"

NSString *const publicKey = @"dc6zaTOxFJmzC";
NSString *const giphySearchURL = @"http://api.giphy.com/v1/gifs/search?q=%@&api_key=%@";
NSString *const giphyTrendingURL = @"http://api.giphy.com/v1/gifs/trending?api_key=%@";
NSString *const giphyRandomURL = @"http://api.giphy.com/v1/gifs/random?api_key=%@&tag=%@";

@implementation SearchForGIFSCommunicator


- (void)searchForGIFS:(NSString *)searchString withSearchType:(searchType)searchType {

	NSArray *randomTags = @[@"Cats", @"Dogs", @"Rabbits", @"Fox", @"Traffic", @"Crabs", @"Giraffe"];
	NSString *urlString;
	switch (searchType) {

		case kSearchTypeString: {
			NSString *newSearchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
			urlString = [NSString stringWithFormat:giphySearchURL, newSearchString, publicKey];
			break;
		}

		case kSearchTypeTrending: {

			urlString = [NSString stringWithFormat:giphyTrendingURL, publicKey];

			break;
		}
		case kSearchTypeRandom: {
			NSLog(@"came here");
			urlString = [NSString stringWithFormat:giphyRandomURL, publicKey, randomTags[3]];
			break;
		}
		default: {

			break;
		}
	}

	NSURL *url = [NSURL URLWithString:urlString];

	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
	NSURLSession *session = [NSURLSession sharedSession];
	NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest
											completionHandler:
													^(NSData *data, NSURLResponse *response, NSError *error) {

														if (error) {
															[self.delegate fetchingJSONFailedWithError:error];
														} else {
															[self.delegate receivedGIFJSON:data];
														}
													}];
	[task resume];

}

@end