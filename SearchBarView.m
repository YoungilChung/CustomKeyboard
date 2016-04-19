//
// Created by Tom Atterton on 31/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "SearchBarView.h"
#import "MMKeyboardButton.h"
#import "MMCustomTextField.h"
#import "KeyboardDelegate.h"


@interface SearchBarView () <UITextFieldDelegate>


@end

@implementation SearchBarView

- (instancetype)init {
	self = [super init];
	if (self) {

		UILabel *magnifyingGlass = [[UILabel alloc] init];
		[magnifyingGlass setText:[[NSString alloc] initWithUTF8String:"\xF0\x9F\x94\x8D"]];
		[magnifyingGlass sizeToFit];

		self.translatesAutoresizingMaskIntoConstraints = NO;

		self.searchBar = [[MMCustomTextField alloc] init];
		self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
		self.searchBar.backgroundColor = [UIColor whiteColor];
		[self.searchBar setPlaceholder:@"Search for a GIF"];
		self.searchBar.delegate = self;
		self.searchBar.isTextFieldSelected = NO;
		self.searchBar.layer.cornerRadius = 4;
		[self.searchBar setLeftView:magnifyingGlass];
		[self.searchBar setLeftViewMode:UITextFieldViewModeAlways];
		self.searchBar.clipsToBounds = YES;
		[self addSubview:self.searchBar];

		self.gifButton = [MMKeyboardButton buttonWithType:UIButtonTypeCustom];
		self.gifButton.translatesAutoresizingMaskIntoConstraints = NO;
		[self.gifButton setTitle:@"GIF" forState:UIControlStateNormal];
		[self.gifButton setBackgroundColor:[UIColor clearColor]];
		[self.gifButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[self addSubview:self.gifButton];

		NSDictionary *views = @{@"searchBar" : self.searchBar, @"gifButton" : self.gifButton};
		NSDictionary *metrics = @{};

		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[searchBar]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[gifButton]-2-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[searchBar]-10-[gifButton]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	}

	return self;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	NSLog(@"came here");
	self.searchBar.isTextFieldSelected = YES;
	self.searchBar.text = @"";
	[self.keyboardDelegate searchBarTapped];
	return NO;
}

//- (void)blinkAnimation:(NSString *)animationId finished:(BOOL)finished target:(UIView *)target
//{
//	if (shouldContinueBlinking) {
//		[UIView beginAnimations:animationId context:target];
//		[UIView setAnimationDuration:0.5f];
//		[UIView setAnimationDelegate:self];
//		[UIView setAnimationDidStopSelector:@selector(blinkAnimation:finished:target:)];
//		if ([target alpha] == 1.0f)
//			[target setAlpha:0.0f];
//		else
//			[target setAlpha:1.0f];
//		[UIView commitAnimations];
//	}
//}


@end