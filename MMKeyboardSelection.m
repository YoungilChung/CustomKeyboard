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
@property(nonatomic, strong) UITableViewCell *oldCell;
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

//	UIPanGestureRecognizer *panner = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
//	panner.delegate = self;
//	[self addGestureRecognizer:panner];


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

//	UIPanGestureRecognizer *panning = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning:)];
////	panning.minimumNumberOfTouches = 1;
////	panning.maximumNumberOfTouches = 1;
//	panning.cancelsTouchesInView = NO;
//	panning.delegate = self;
//	[self.tableView addGestureRecognizer:panning];


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


- (void)updatePosition:(CGPoint)position {

	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:position];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	if (cell) {
		if (![self.oldCell isEqual:cell]) {

//			[cell setSelected:NO];
//		}
//		else {
			
			self.oldCell = cell;
			[cell setSelected:YES];
		}

	}
	else {
		for (int i = 0; i < self.arrayText.count; i++) {

			UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
			[cell setSelected:NO];

		}

	}


}


//
//// Allow simultaneous recognition
////- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
////	return YES;
////}
//
////- (void)handlePanning:(UIPanGestureRecognizer *)sender {
////	NSLog(@"PAN");
////
////	CGPoint beginLocation = [sender locationInView:self.tableView]; // touch begin state.
//////
//////	CGPoint endLocation = [sender locationInView:self.tableView];
////	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:beginLocation];
////	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath : indexPath];
//////
////	[cell setHighlighted:YES];
////
////}
//
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//	return [NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"];
//}
//
//- (void)handlePanning:(UIPanGestureRecognizer *)sender {
////	MMKeyboardSelectionCell *cell = (MMKeyboardSelectionCell *) [sender view];
////	CGPoint translation = [sender translationInView:[cell superview]];
////	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:translation];
//////	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath : indexPath];
////	switch (sender.state) {
////		case UIGestureRecognizerStateChanged:
////		{
////
////			[cell setHighlighted:YES];
////
////			break;
////		}
////		case UIGestureRecognizerStateBegan:
////		case UIGestureRecognizerStateEnded:
////		case UIGestureRecognizerStateFailed:
////		default:
////			break;
////	}
//}
////
////- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
////	if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
////		CGPoint translation = [(UIPanGestureRecognizer*)gestureRecognizer translationInView:self.superview];
////		return fabsf(translation.x) > fabsf(translation.y);
////	}
////
////	return YES;
////}
////- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
////{
////	UIView *cell = [gestureRecognizer view];
////	CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:[cell superview]];
////
////
////
////
////	// Check for horizontal gesture
////	return fabs(translation.y) > fabs(translation.x);
////
////}
//
//
////- (void) tableViewCell:(UITableViewCell*)tableViewCell gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer
////{
////
////}
////- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
////	return YES;
////}
//
//
//
//
////- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
////{
////	return ![touch.view isDescendantOfView:self.tableView];
////
////}
//
////- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
////	   shouldReceiveTouch:(UITouch *)touch
////{
////	UIView *superview = touch.view;
////	do {
////		superview = superview.superview;
////		if ([superview isKindOfClass:[UITableViewCell class]])
////			return YES;
////	} while (superview && ![superview isKindOfClass:[UITableView class]]);
////
////	return NO;
////}
@end