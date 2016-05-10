//
// Created by Tom Atterton on 30/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMKeyboardSelection.h"
#import "UIImage+emoji.h"
#import "MMKeyboardSelectionCell.h"
#import "KeyboardDelegate.h"
#import "NSUserDefaults+Keyboard.h"

@interface MMKeyboardSelection () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property(nonatomic, strong) NSArray *arrayImages;
@property(nonatomic, strong) NSArray *arrayText;
@property(nonatomic, copy) NSString *language;
@property(nonatomic, strong) NSUserDefaults *mySharedDefaults;
@end

@implementation MMKeyboardSelection

- (instancetype)init {

	self = [super init];
	if (self) {
		self.mySharedDefaults = [[NSUserDefaults alloc] init];

		switch (self.mySharedDefaults.language) {

			case kChangeLanguageEnglish: {

				self.language = @"English Keyboard";
				break;
			}
			case kChangeLanguageDutch: {

				self.language = @"Dutch Keyboard";
				break;
			}
			default: {
				self.language = @"Language";
				break;
			}
		}

		self.arrayImages = @[[UIImage imageWithEmoji:@"⌨️" withSize:26], [UIImage imageWithEmoji:@"🌐" withSize:26], [UIImage imageWithEmoji:@"😀" withSize:26]]; // TODO more efficient
		self.arrayText = @[self.language, @"Switch To Next Keyboard", @"Emoji"];

		[self setup];
	}

	return self;
}

- (void)setup {

	self.tableView = [UITableView new];
	self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
	self.tableView.clipsToBounds = YES;
	self.tableView.layer.cornerRadius = 4;
	self.tableView.scrollEnabled = NO;
	[self.tableView setSeparatorColor:[UIColor lightGrayColor]];
	[self.tableView registerClass:[MMKeyboardSelectionCell class] forCellReuseIdentifier:@"CELL"];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	[self.tableView setAllowsSelection:YES];
	[self addSubview:self.tableView];

	NSDictionary *views = @{@"tableView" : self.tableView};

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.arrayText.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	MMKeyboardSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];

	cell.imageView.image = self.arrayImages[(NSUInteger) indexPath.row];

	[cell.textLabel setText:self.arrayText[(NSUInteger) indexPath.row]];
	[cell.textLabel setFont:[UIFont fontWithName:@"AmericanTypewriter" size:11]];
	[cell.textLabel setTextColor:[UIColor whiteColor]];

	[cell setBackgroundColor:[UIColor lightGrayColor]];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	[self selectedRowWithIndexPath:indexPath];
	[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void)selectedRowWithIndexPath:(NSIndexPath *)indexPath {

	if (indexPath) {


		NSUInteger item = (NSUInteger) indexPath.item;

		if ([self.arrayText[item] isEqualToString:@"Emoji"]) {

			[self.keyboardDelegate changeKeyboard:kTagEmojiKeyboard];

		}

		else if ([self.arrayText[item] isEqualToString:@"Switch To Next Keyboard"]) {
			[self.keyboardDelegate changeKeyboard:kTagSwitchKeyboard];

		}
		else {

			[self.keyboardDelegate changeLanguage:self.mySharedDefaults.language];

		}
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40;
}
@end