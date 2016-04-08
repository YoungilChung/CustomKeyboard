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

@interface PopupButtonView : UIView

-(instancetype)initWithButton:(MMkeyboardButton*)button WithPopupStyle:(popUpStyle)popUpStyle;

@end