//
// Created by Tom Atterton on 13/05/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMThemeData.h"


@implementation MMThemeData


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

			@"ID" : @"Dark",
			@"title" : @"Dark Theme",
			@"keyboardThemeID" : @"100",
			@"description" : @"Corrects and completes your words"
	};

	NSDictionary *value2 = @{

			@"ID" : @"Sun",
			@"title" : @"Sun Theme",
			@"keyboardThemeID" : @"101",
			@"description" : @"Double-tap the spacebar to insert a period"

	};

	NSDictionary *value3 = @{

			@"ID" : @"Orange",
			@"title" : @"Orange Theme",
			@"keyboardThemeID" : @"102",
			@"description" : @"Start new sentences with a capital letter"

	};

	NSDictionary *value4 = @{

			@"ID" : @"Nature",
			@"title" : @"Nature Theme",
			@"keyboardThemeID" : @"103",
			@"description" : @"A period is inserted whenever you insert two spaces in a row"
	};

	NSDictionary *value5 = @{

			@"ID" : @"Steel",
			@"title" : @"Steel grey Theme",
			@"keyboardThemeID" : @"104",
			@"description" : @"A click sound whenever you tap a key"

	};

	NSDictionary *value6 = @{

			@"ID" : @"Purple",
			@"title" : @"Purple Theme",
			@"keyboardThemeID" : @"105",
			@"description" : @"Change the theme of the keyboard"

	};
	NSDictionary *value7 = @{

			@"ID" : @"Sea",
			@"title" : @"Blue sea Theme",
			@"keyboardThemeID" : @"106",
			@"description" : @"Change the Font on the keyboard"

	};

	NSArray *values = @[value1, value2, value3, value4, value5, value6, value7];

	return values;
}

@end