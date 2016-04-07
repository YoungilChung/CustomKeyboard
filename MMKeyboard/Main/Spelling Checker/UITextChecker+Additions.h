//
//  UITextChecker+Additions.h
//  MMCustomKeyboard
//
//  Created by Tom Atterton on 06/04/16.
//  Copyright © 2016 mm0030240. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextChecker (Additions
                          )

- (NSArray *)guessesForWord:(NSString *)word;

- (NSArray *)completionsForWord:(NSString *)word;

@end
