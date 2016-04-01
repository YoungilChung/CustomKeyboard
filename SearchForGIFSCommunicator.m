//
// Created by Tom Atterton on 01/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "SearchForGIFSCommunicator.h"

static NSString *publicKey = @"dc6zaTOxFJmzC";

@implementation SearchForGIFSCommunicator {

}
- (void)searchForGifs:(NSString *)searchString {

	NSString *newSearchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString*urlString =[NSString stringWithFormat:@"http://api.giphy.com/v1/gifs/search?q=%@&api_key=%@", newSearchString, publicKey];
    NSURL *url = [NSURL URLWithString:urlString];


    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

		if (error) {
			[self.delegate fetchingJSONFailedWithError:error];
		} else {
			[self.delegate recievedGIFJSON:data];
		}
	}];

}

@end