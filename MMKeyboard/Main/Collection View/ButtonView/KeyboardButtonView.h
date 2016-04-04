//
// Created by Tom Atterton on 15/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class GIFEntity;

@interface KeyboardButtonView : UIView

@property (nonatomic, strong) NSString *gifUrl;

-(instancetype)initWithFrame: (CGRect)frame WithEntity:(GIFEntity*)entity;
@end