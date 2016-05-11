//
// Created by Tom Atterton on 05/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SpellCheckerDelegate <NSObject>

-(void)primarySpell:(NSString *)primaryString;
-(void)secondarySpell:(NSString *)secondaryString;
-(void)tertiarySpell:(NSString *)tertiaryString;
- (void)tappedWord:(NSString *)tappedWord;

-(void)hideView:(BOOL)shouldHide;

-(NSArray *)checkText:(NSString *)checkedText;

@end