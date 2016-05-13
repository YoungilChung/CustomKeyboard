//
// Created by Tom Atterton on 13/05/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MMKeyboardThemeModel.h"

@interface MMSettingsThemeCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) keyboardTheme keyboardTheme;


@end