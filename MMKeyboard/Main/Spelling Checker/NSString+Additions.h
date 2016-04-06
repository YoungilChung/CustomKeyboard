//
//  NSString+Additions.h
//  MMCustomKeyboard
//
//  Created by Tom Atterton on 06/04/16.
//  Copyright © 2016 mm0030240. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Additions)

@property (nonatomic, readonly) BOOL isUppercase;
@property (nonatomic, readonly) NSString* titleCase;
@property (nonatomic, readonly) NSString* quotedString;


@property (nonatomic, readonly) BOOL isValidForCorrecting;
@property (nonatomic, readonly) NSString* letterCharacterString;
@property (nonatomic, readonly) NSString* nonLetterCharacterString;

- (NSString*)stringByReplacingLetterCharactersWithString:(NSString*)string;

@end
