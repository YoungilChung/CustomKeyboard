//
// Created by Tom Atterton on 01/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "SearchForGIFSCommunicator.h"

NSString *const publicKey = @"dc6zaTOxFJmzC";
NSString *const giphySearchURL = @"http://api.giphy.com/v1/gifs/search?q=%@&api_key=%@";
NSString *const giphyTrendingURL = @"http://api.giphy.com/v1/gifs/trending?api_key=%@";
NSString *const giphyRandomURL = @"http://api.giphy.com/v1/gifs/random?api_key=%@";

@interface SearchForGIFSCommunicator ()
@property(nonatomic) searchType customSearchType;
@end

@implementation SearchForGIFSCommunicator


- (void)searchForGIFS:(NSString *)searchString withSearchType:(searchType)searchType {

	NSString *urlString;
	self.customSearchType = searchType;

	switch (searchType) {

		case kSearchTypeString: {
			NSString *newSearchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
			urlString = [NSString stringWithFormat:giphySearchURL, newSearchString, publicKey];
			[self requestURL:urlString];
			break;
		}

		case kSearchTypeTrending: {

			urlString = [NSString stringWithFormat:giphyTrendingURL, publicKey];
			[self requestURL:urlString];


			break;
		}
		case kSearchTypeRandom: {

			urlString = [NSString stringWithFormat:giphyRandomURL, publicKey];
			[self requestURL:urlString];

			break;
		}
		default: {

			break;
		}
	}


}

- (void)requestURL:(NSString *)urlString {
	NSURL *url = [NSURL URLWithString:urlString];

	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
	NSURLSession *session = [NSURLSession sharedSession];
	NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest
											completionHandler:
													^(NSData *data, NSURLResponse *response, NSError *error) {

														if (error) {
															[self.delegate fetchingJSONFailedWithError:error];
														}

														[self.delegate receivedGIFJSON:data withSearchType:self.customSearchType];

													}];
	[task resume];
}

@end