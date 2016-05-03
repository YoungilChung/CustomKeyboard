//
// Created by Tom Atterton on 01/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchForGIFSCommunicator.h"


@protocol SearchMangerDelegate
- (void)didReceiveGIFS:(NSArray *)groups;

- (void)fetchingGIFSFailedWithError:(NSError *)error;
@end

@interface SearchGIFManager : NSObject <SearchGifsDelegate>

@property(strong, nonatomic) SearchForGIFSCommunicator *communicator;
@property(weak, nonatomic) id <SearchMangerDelegate> delegate;

- (void)fetchGIFSForSearchQuery:(NSString *)searchString withSearchType:(searchType)searchType;

@end