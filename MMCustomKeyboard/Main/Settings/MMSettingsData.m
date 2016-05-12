//
// Created by Tom Atterton on 12/05/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMSettingsData.h"


@implementation MMSettingsData


- (instancetype)init {
	self = [super init];
	if (self) {


		self.data = [self settingData];

	}

	return self;
}

- (NSArray *)settingData {


	NSDictionary *value1 = @{
			@"ID": @"AutoCorrect",
			@"title" : @"AutoCorrect",
			@"switch" : @"Yes",
			@"description" : @"Corrects and completes your words"
	};

	NSDictionary *value2 = @{
			@"ID": @"QuickPeriod",
			@"title" : @"Quick Period",
			@"switch" : @"Yes",
			@"description" : @"Double-tap the spacebar to insert a period"

	};

	NSDictionary *value3 = @{
			@"ID": @"AutoCapitalize",
			@"title" : @"Auto Capitalize",
			@"switch" : @"Yes",
			@"description" : @"Start new sentences with a capital letter"

	};

	NSDictionary *value4 = @{
			@"ID": @"DoubleSpace",
			@"title" : @"Double Space for Punctuation",
			@"switch" : @"Yes",
			@"description" : @"A period is inserted whenever you insert two spaces in a row"
	};

	NSDictionary *value5 = @{
			@"ID": @"KeyClick",
			@"title" : @"Key Click Sounds",
			@"switch" : @"Yes",
			@"description" : @"A click sound whenever you tap a key"

	};

	NSDictionary *value6 = @{
			@"ID": @"Theme",
			@"title" : @"Theme",
			@"switch" : @"No",
			@"description" : @"Change the theme of the keyboard"

	};
	NSDictionary *value7 = @{
			@"ID": @"KeyboardFont",
			@"title" : @"Keyboard Font",
			@"switch" : @"No",
			@"description" : @"Change the Font on the keyboard"

	};

	NSArray *values = @[value1, value2, value3, value4, value5, value6, value7];

	return values;
}


@end