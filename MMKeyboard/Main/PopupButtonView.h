//
// Created by Tom Atterton on 07/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
	kpopUpStyleSingle = 100,
	kpopUpStyleMultiple,
} popUpStyle;


@class MMkeyboardButton;
@class PopupView;

@interface PopupButtonView : UIView


@property(nonatomic, assign) NSString * selectedCharacter;

- (instancetype)initWithButton:(MMkeyboardButton *)button WithPopupStyle:(popUpStyle)popUpStyle;
-(void)updatePosition:(CGPoint)position;
@end