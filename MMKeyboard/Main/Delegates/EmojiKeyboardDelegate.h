//
//  EmojiKeyboardDelegate.h
//  MMCustomKeyboard
//
//  Created by Tom Atterton on 15/04/16.
//  Copyright © 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EmojiKeyboardDelegate <NSObject>

- (void)keyWasTapped:(NSString *)key;

@end
