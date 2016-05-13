//
// Created by Tom Atterton on 13/05/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMFontData.h"


@implementation MMFontData


- (instancetype)init
{
	self = [super init];
	if (self)
	{


		self.data = [self settingData];

	}

	return self;
}

- (NSArray *)settingData
{


	NSDictionary *value1 = @{

			@"ID" : @"Helvetica",
			@"title" : @"System Font",
	};

	NSDictionary *value2 = @{

			@"ID" : @"HelveticaNeue",
			@"title" : @"HelveticaNeue",

	};

	NSDictionary *value3 = @{

			@"ID" : @"HelveticaNeue-Bold",
			@"title" : @"HelveticaNeue-Bold",

	};

	NSDictionary *value4 = @{

			@"ID" : @"HelveticaNeue-Thin",
			@"title" : @"HelveticaNeue-Thin",
	};

	NSDictionary *value5 = @{

			@"ID" : @"Futura-MediumItalic",
			@"title" : @"Futura-MediumItalic",
			@"description" : @"A click sound whenever you tap a key"

	};

	NSDictionary *value6 = @{

			@"ID" : @"Menlo-Regular",
			@"title" : @"Menlo-Regular",

	};
	NSDictionary *value7 = @{

			@"ID" : @"Avenir-Light",
			@"title" : @"Avenir-Light",

	};

	NSArray *values = @[value1, value2, value3, value4, value5, value6, value7];

	return values;
}


@end