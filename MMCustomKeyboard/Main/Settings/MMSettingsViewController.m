//
// Created by Tom Atterton on 11/05/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMSettingsViewController.h"
#import "MMSettingsTableViewCell.h"
#import "MMSettingsData.h"
#import "MMSettingsSubtitle.h"
#import "NSUserDefaults+Keyboard.h"

#define CASE(str)          if ([__s__ isEqualToString:(str)])
#define SWITCH(s)          for (NSString *__s__ = (s); ; )
#define DEFAULT

@interface MMSettingsViewController () <UITableViewDelegate, UITableViewDataSource>


@property(nonatomic, strong) NSMutableArray *data;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSUserDefaults *mySharedDefaults;

@end

@implementation MMSettingsViewController


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	MMSettingsData *mmSettingsData = [[MMSettingsData alloc] init];
	self.data = [mmSettingsData.data mutableCopy];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	UILabel *titleLabel = [UILabel new];
	titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[titleLabel setText:@"Settings"];
	[titleLabel setTextAlignment:NSTextAlignmentCenter];
	[titleLabel setTextColor:[UIColor whiteColor]];
	[self.view addSubview:titleLabel];

	self.mySharedDefaults = [[NSUserDefaults alloc] init];


	self.tableView = [UITableView new];
	self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.tableView registerClass:[MMSettingsTableViewCell class] forCellReuseIdentifier:@"CELL"];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
	[self.tableView setSectionHeaderHeight:20];
	[self.tableView setSeparatorColor:[UIColor clearColor]];
	[self.tableView setBounces:NO];
	[self.tableView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.2 blue:0.5 alpha:0.7]];
	[self.tableView setOpaque:NO];
	[self.view addSubview:self.tableView];

	NSDictionary *metrics = @{};
	NSDictionary *views = @{@"titleLabel" : titleLabel, @"tableView" : self.tableView};

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[titleLabel]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[titleLabel]-10-[tableView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

	return self.data ? self.data.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewAutomaticDimension;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	MMSettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
	NSUInteger item = (NSUInteger) indexPath.section;

	NSString *title = self.data[item][@"title"];
	NSString *subTitle = self.data[(NSUInteger) item][@"description"];
	cell.layer.cornerRadius = 4;
	cell.cellID = self.data[item][@"ID"];
	[cell.uiSwitch setOn:[self checkSwitchState:cell.cellID]];
	[cell.uiSwitch addTarget:self action:@selector(switchTapped:) forControlEvents:UIControlEventTouchUpInside];
	[cell.titleLabel setText:title];
	[cell.subTitleLabel setText:subTitle];

	return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 10;
}

- (BOOL)checkSwitchState:(NSString *)cellName {
	BOOL check = NO;
	SWITCH(cellName) {

		CASE(@"AutoCorrect") {

			check = self.mySharedDefaults.isAutoCorrect;

			break;
		}
		CASE(@"QuickPeriod") {
			check = self.mySharedDefaults.isQuickPeriod;

			break;
		}
		CASE(@"AutoCapitalize") {

			check = self.mySharedDefaults.isAutoCapitalize;

			break;
		}
		CASE(@"DoubleSpace") {

			check = self.mySharedDefaults.isDoubleSpacePunctuation;

			break;
		}
		CASE(@"KeyClick") {
			check = self.mySharedDefaults.isKeyClickSounds;

			break;
		}

		DEFAULT
		{
			break;
		}
	}

	return check;

}

- (void)switchTapped:(UISwitch *)sender {
	CGPoint switchPositionPoint = [sender convertPoint:CGPointZero toView:[self tableView]];
	NSIndexPath *indexPath = [[self tableView] indexPathForRowAtPoint:switchPositionPoint];
	MMSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];


	SWITCH(cell.cellID) {

		CASE(@"AutoCorrect") {
//			if (clicked) {

			[self.mySharedDefaults setIsAutoCorrect:sender.on];
//			}
//			else {
//			[self.uiSwitch setOn:self.shareDefaults.isAutoCorrect];

//			}
			NSLog(@"%@", cell.titleLabel.text);
			break;
		}
		CASE(@"QuickPeriod") {
//			if (clicked) {
			NSLog(@"%@", cell.titleLabel.text);

			[self.mySharedDefaults setIsQuickPeriod:sender.on];
//			}
//			else {
//			[self.uiSwitch setOn:self.shareDefaults.isQuickPeriod];

//			}
			break;
		}
		CASE(@"AutoCapitalize") {
//			if (clicked) {

			NSLog(@"%@", cell.titleLabel.text);
			[self.mySharedDefaults setIsAutoCapitalize:sender.on];
//			}
//			else {

//			}
//			NSLog(@"%@", self.titleLabel.text);
			break;
		}
		CASE(@"DoubleSpace") {
//			if (clicked) {

			[self.mySharedDefaults setIsDoubleSpacePunctuation:sender.on];
//			}
//			else {
			NSLog(@"%@", cell.titleLabel.text);


//			}
//			NSLog(@"%@", self.titleLabel.text);
			break;
		}
		CASE(@"KeyClick") {
//			if (clicked) {

			[self.mySharedDefaults setIsKeyClickSounds:sender.on];
//			}
//			else {
			NSLog(@"%@", cell.titleLabel.text);

//			}
			break;
		}
		CASE(@"Theme") {

			break;
		}
		CASE(@"KeyboardFont") {

			break;
		}

		DEFAULT
		{
			break;
		}
	}


}


@end