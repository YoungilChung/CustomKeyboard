//
// Created by Tom Atterton on 13/05/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MMSettingsModel : NSObject


- (instancetype)initWithDictionary:(NSDictionary *)data;

@property (nonatomic, strong) NSString *settingsID;
@property (nonatomic, strong) NSString *settingsTitle;
@property (nonatomic, assign) BOOL isSwitchON;
@property (nonatomic, strong) NSString *settingsDescription;


@end