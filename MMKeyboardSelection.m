//
// Created by Tom Atterton on 30/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMKeyboardSelection.h"
#import "UIImage+emoji.h"
#import "MMKeyboardSelectionCell.h"
#import "KeyboardDelegate.h"

@interface MMKeyboardSelection () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property(nonatomic, strong) NSArray *arrayImages;
@property(nonatomic, strong) NSArray *arrayText;
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation MMKeyboardSelection

- (instancetype)init {

	self = [super init];
	if (self) {

		self.arrayImages = @[[UIImage imageWithEmoji:@"🌐" withSize:26], [UIImage imageWithEmoji:@"😀" withSize:26]];
		self.arrayText = @[@"Switch To Next Keyboard", @"Emoji"];

		[self setup];
	}

	return self;
}

- (void)setup {

	UIPanGestureRecognizer *panner = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
	panner.delegate = self;
	[self addGestureRecognizer:panner];


	self.tableView = [UITableView new];
	self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
	self.tableView.clipsToBounds = YES;
	self.tableView.layer.cornerRadius = 4;
	self.tableView.scrollEnabled = NO;
	[self.tableView setSeparatorColor:[UIColor lightGrayColor]];
	[self.tableView registerClass:[MMKeyboardSelectionCell class] forCellReuseIdentifier:@"CELL"];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	[self addSubview:self.tableView];


	NSDictionary *views = @{@"tableView" : self.tableView};

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.arrayImages.count;
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

	NSUInteger item = (NSUInteger) indexPath.item;

	if ([self.arrayText[item] isEqualToString:@"Emoji"]) {

		[self.keyboardDelegate changeKeyboard:kTagEmojiKeyboard];
	}
	else {
		[self.keyboardDelegate changeKeyboard:kTagSwitchKeyboard];


	}

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	UIView *cell = [gestureRecognizer view];
	CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:[cell superview]];

	// Check for horizontal gesture
	return fabs(translation.x) > fabs(translation.y);

}

@end