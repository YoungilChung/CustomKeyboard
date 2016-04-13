//
// Created by Tom Atterton on 08/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PopupView : UIView

@property (nonatomic, strong) NSString *titleLabel;

-(void)selectedPopupView:(BOOL)selected;
-(instancetype)initWithTitle:(NSString *)title;

@end