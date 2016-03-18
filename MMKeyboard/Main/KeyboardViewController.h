//
//  KeyboardViewController.h
//  MMKeyboard
//
//  Created by mm0030240 on 06/10/15.
//  Copyright © 2015 mm0030240. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyboardViewController : UIInputViewController

@property(nonatomic, strong) NSString *gifURL;
@property(nonatomic, strong) UIButton *normalButton;
@property(nonatomic, strong) UIButton *awesomeButton;
@property(nonatomic, strong) UIButton *allGifsButton;

-(void)tappedGIF;


@end
