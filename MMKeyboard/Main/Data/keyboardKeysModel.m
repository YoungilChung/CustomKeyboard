//
// Created by Tom Atterton on 07/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "keyboardKeysModel.h"


@implementation keyboardKeysModel


- (instancetype)init {

	self = [super init];
	if (self) {


		self.alphaTiles1 = @[@"q", @"w", @"e", @"r", @"t", @"y", @"u", @"i", @"o", @"p"];
		self.alphaTiles2 = @[@"a", @"s", @"d", @"f", @"g", @"h", @"j", @"k", @"l"];
		self.alphaTiles3 = @[@"⇧", @"z", @"x", @"c", @"v", @"b", @"n", @"m", @"⌫"];

		self.numericTiles1 = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0"];
		self.numericTiles2 = @[@"-", @"/", @":", @";", @"(", @")", @"€", @"&", @"@"];
		self.numericTiles3 = @[@"#+=", @".", @",", @"?", @"!", @"™", @"'", @"\"", @"⌫"];

		self.specialTiles1 = @[@"[", @"]", @"{", @"}", @"#", @"%", @"^", @"*", @"+", @"="];
		self.specialTiles2 = @[@"_", @"\"", @"|", @"~", @"<", @">", @"£", @"$", @"¥"];
		self.specialTiles3 = @[@"?!@", @".", @",", @"?", @"!", @"®", @"'", @"•", @"⌫"];
	}
	return self;

//	e: è é ê ë ē ė ę
//	y: ÿ
//	u: û ü ù ú ū
//	i: î ï í ī į ì
//	o: ô ö ò ó œ ø ō õ
//	a: à á â ä æ ã å ā
//	s: ß ś š
//	l: ł
//	z: ž ź ż
//	c: ç ć č
//	n: ñ ń
//	0: °
//	-: – — •
//	/: \
//	$: € £ ¥ ₩ ₽
//	&: §
//	": " " „ » «
//			.: …
//	?: ¿
//	!: ¡
//	': ' ' `
//%: ‰
//

}

- (NSArray *)specialCharactersWithLetter:(NSString *)letter {

	NSArray *specialArray = @[];

	if ([letter isEqualToString:@"e"]) {
		specialArray = @[@"è", @"é", @"ê", @"ë", @"ē", @"ė", @"ę"];
	}

	if ([letter isEqualToString:@"y"]) {
		specialArray = @[@"ÿ"];
	}

	if ([letter isEqualToString:@"u"]) {
		specialArray = @[@"û", @"ü", @"ù", @"ú", @"ū"];
	}

	if ([letter isEqualToString:@"i"]) {
		specialArray = @[@"î", @"ï", @"í", @"ī", @"į", @"ì"];
	}

	if ([letter isEqualToString:@"o"]) {
		specialArray = @[@"ô", @"ö", @"ò", @"ó", @"œ", @"ø", @"ō", @"õ"];
	}

	if ([letter isEqualToString:@"a"]) {
		specialArray = @[@"à", @"á", @"â", @"ä", @"æ", @"ã", @"å", @"ā"];
	}

	if ([letter isEqualToString:@"s"]) {
		specialArray = @[@"ß", @"ś", @"š"];
	}

	if ([letter isEqualToString:@"l"]) {
		specialArray = @[@"ł",];
	}

	if ([letter isEqualToString:@"z"]) {
		specialArray = @[@"ž", @"ź", @"ż"];
	}

	if ([letter isEqualToString:@"c"]) {
		specialArray = @[@"ç", @"ć", @"č"];
	}

	if ([letter isEqualToString:@"n"]) {
		specialArray = @[@"ñ", @"ń"];
	}

	return specialArray;
}


@end