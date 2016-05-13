//
// Created by Tom Atterton on 13/05/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMFontModel.h"


@implementation MMFontModel
{

}
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	if (self = [super init])
	{
		self.settingsID = dictionary[@"ID"];
		self.settingsTitle = dictionary[@"title"];
	}
	return self;
}

@end