//
// Created by Tom Atterton on 13/05/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMKeyboardThemeModel.h"


@interface MMThemeModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


@property (nonatomic, strong) NSString *settingsID;
@property (nonatomic, strong) NSString *settingsTitle;
@property (nonatomic, assign) keyboardTheme keyboardTheme;


@end