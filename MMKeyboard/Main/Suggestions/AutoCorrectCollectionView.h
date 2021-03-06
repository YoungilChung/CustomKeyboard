//
// Created by Tom Atterton on 06/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SpellCheckerManager;
@protocol SpellCheckerDelegate;
typedef enum {
	ksectionHeaderPrimary = 100,
	ksectionHeaderSecondary,
	ksectionHeaderTertiary,
} sectionHeaders;

@interface AutoCorrectCollectionView : UIView

// Views
@property(nonatomic, strong) NSString *primaryString;
@property(nonatomic, strong) NSString *secondaryString;
@property(nonatomic, strong) NSString *tertiaryString;

//Delegate
@property(nonatomic, weak) id <SpellCheckerDelegate> delegate;

// Method
-(void)updateText:(NSString*)updatedText forSection:(sectionHeaders)section;

@end