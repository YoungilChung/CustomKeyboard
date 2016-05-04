//
// Created by Tom Atterton on 04/05/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "RandomCategories.h"

NSString *const riffyCategories = @"";
@interface RandomCategories()

@end

@implementation RandomCategories {

}
+ (NSString *)searchString {

	NSArray *searchQuery = @[@"no",@"facepalm",@"fail",@"deal with it",@"frustrated",@"confused",@"unimpressed",@"shocked",@"surprised patrick", @"eye roll",@"yawn",@"bitch please",@"come at me bro",@"haters gonna hate"
			,@"sorry",@"feels",@"yes",@"thank you",@"hug",@"thumbs up",@"win",@"wink", @"laughing",@"smile",@"hello",@"excited",@"applause",@"high five",@"love",@"like a boss",@"bitch im fabulous",@"finger guns",@"dance"
			,@"gangnam style",@"swag",@"fan girling",@"keep calm and",@"family guy",@"cats",@"dogs",@"food",@"burgers",@"monks",@"hats",@"piano",@"icecream",];
	int randomIndex = arc4random() % (searchQuery.count - 1);

return searchQuery[randomIndex];


}

@end