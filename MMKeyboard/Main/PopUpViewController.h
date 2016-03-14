//
//  PopUpViewController.h
//  MMCustomKeyboard
//
//  Created by mm0030240 on 22/10/15.
//  Copyright © 2015 mm0030240. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FLAnimatedImageView.h>

@interface PopUpViewController : UIViewController

@property (strong, nonatomic) IBOutlet FLAnimatedImageView *photoView;
@property (strong, nonatomic) NSURL *url;
@end
