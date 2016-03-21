//
//  ShareViewController.h
//  MMShareExtension
//
//  Created by mm0030240 on 06/10/15.
//  Copyright © 2015 mm0030240. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
@interface ShareViewController : UIViewController

@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, strong) NSArray *holderConstraints;
@property(nonatomic, strong) UIView *holder;
@property(nonatomic, strong) UIButton *normalButton;
@property(nonatomic, strong) UIButton *awesomeButton;
@end
