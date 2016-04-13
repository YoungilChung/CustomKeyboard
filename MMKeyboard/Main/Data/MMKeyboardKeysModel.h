//
// Created by Tom Atterton on 07/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MMKeyboardKeysModel : NSObject

@property (nonatomic, strong) NSArray *alphaTiles1;
@property (nonatomic, strong) NSArray *alphaTiles2;
@property (nonatomic, strong) NSArray *alphaTiles3;

@property (nonatomic, strong) NSArray *numericTiles1;
@property (nonatomic, strong) NSArray *numericTiles2;
@property (nonatomic, strong) NSArray *numericTiles3;

@property (nonatomic, strong) NSArray *specialTiles1;
@property (nonatomic, strong) NSArray *specialTiles2;
@property (nonatomic, strong) NSArray *specialTiles3;


@property (nonatomic, strong) NSArray *emojiTilesSmiley;
@property (nonatomic, strong) NSArray *emojiTilesNature;
@property (nonatomic, strong) NSArray *emojiTilesFood;
@property (nonatomic, strong) NSArray *emojiTilesSport;
@property (nonatomic, strong) NSArray *emojiTilesPlaces;
@property (nonatomic, strong) NSArray *emojiTilesObjects;
@property (nonatomic, strong) NSArray *emojiTilesSymbols;
@property (nonatomic, strong) NSArray *emojiTilesFlags;


-(NSArray *)specialCharactersWithLetter:(NSString *)letter;



@end