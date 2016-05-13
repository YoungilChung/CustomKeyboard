//
// Created by Tom Atterton on 12/05/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MMSettingsSubtitle;

@interface MMSettingsTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *cellID;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) MMSettingsSubtitle *subTitleLabel;
@property (nonatomic, strong) UISwitch *uiSwitch;
@property (nonatomic, assign) BOOL showSwitch;

- (void)setSwitch;
@end