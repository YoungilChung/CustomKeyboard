//
// Created by Tom Atterton on 07/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
	kpopUpStyleSingle = 100,
	kpopUpStyleMultiple,
	kpopUpStyleChangeKeyboard
} popUpStyle;


@class MMKeyboardButton;
@class PopupView;

@interface PopupButtonView : UIView


@property(nonatomic, assign) NSString * selectedCharacter;

- (instancetype)initWithButton:(MMKeyboardButton *)button WithPopupStyle:(popUpStyle)popUpStyle capitaliseButton:(BOOL)isCapitalised;
-(void)updatePosition:(CGPoint)position;
@end