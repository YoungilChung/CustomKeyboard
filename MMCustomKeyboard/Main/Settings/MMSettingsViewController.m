//
// Created by Tom Atterton on 11/05/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMSettingsViewController.h"
#import "MMSettingsTableViewCell.h"
#import "MMSettingsData.h"
#import "MMSettingsSubtitle.h"
#import "NSUserDefaults+Keyboard.h"
#import "MMSettingsThemeView.h"
#import "MMSettingsHeaderView.h"
#import "MMSettingsModel.h"
#import "MMSettingsFontView.h"

#define CASE(str)          if ([__s__ isEqualToString:(str)])
#define SWITCH(s)          for (NSString *__s__ = (s); ; )
#define DEFAULT

@interface MMSettingsViewController () <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSUserDefaults *mySharedDefaults;

@end

@implementation MMSettingsViewController


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	MMSettingsData *mmSettingsData = [[MMSettingsData alloc] init];
	self.data = [mmSettingsData.data mutableCopy];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

//	UILabel *titleLabel = [UILabel new];
//	titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
//	[titleLabel setText:@"Settings"];
//	[titleLabel setTextAlignment:NSTextAlignmentCenter];
//	[titleLabel setTextColor:[UIColor whiteColor]];
//	[self.view addSubview:titleLabel];

//	MMSettingsHeaderView *headerView = [[MMSettingsHeaderView alloc] initWithTitle:@"Settings"];
//	headerView.translatesAutoresizingMaskIntoConstraints = NO;
//	[headerView setBackgroundColor:[UIColor blackColor]];
//	[self.view addSubview:headerView];

	self.mySharedDefaults = [[NSUserDefaults alloc] init];
	[self.view setBackgroundColor:[UIColor blackColor]];
	self.tableView = [UITableView new];
	self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.tableView registerClass:[MMSettingsTableViewCell class] forCellReuseIdentifier:@"CELL"];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
	[self.tableView setSectionHeaderHeight:20];
	[self.tableView setSeparatorColor:[UIColor clearColor]];
	[self.tableView setBounces:NO];
	[self.tableView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.2 blue:0.5 alpha:0.7]];
	[self.tableView setOpaque:NO];
	[self.view addSubview:self.tableView];

	NSDictionary *metrics = @{};
	NSDictionary *views = @{@"tableView" : self.tableView};

//	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[headerView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

	return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

	return self.data ? self.data.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewAutomaticDimension;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

	MMSettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
	NSUInteger item = (NSUInteger)indexPath.section;

	MMSettingsModel *settingsModel = [[MMSettingsModel alloc] initWithDictionary:self.data[item]];

	cell.layer.cornerRadius = 4;
	cell.cellID = settingsModel.settingsID;
	cell.showSwitch = settingsModel.isSwitchON;

	if (!cell.showSwitch)
	{
		[cell.uiSwitch setHidden:YES];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	[cell.uiSwitch setOn:[self checkSwitchState:cell.cellID]];
	[cell.uiSwitch addTarget:self action:@selector(switchTapped:) forControlEvents:UIControlEventTouchUpInside];
	[cell.titleLabel setText:settingsModel.settingsTitle];
	[cell.subTitleLabel setText:settingsModel.settingsDescription];
	return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 10;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	MMSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	if (!cell.showSwitch)
		SWITCH(cell.cellID)
		{

			CASE(@"Theme")
			{
				MMSettingsThemeView *themeView = [MMSettingsThemeView new];
				[self.navigationController pushViewController:themeView animated:NO];
				break;
			}
			CASE(@"KeyboardFont")
			{
				MMSettingsFontView *fontView = [MMSettingsFontView new];
				[self.navigationController pushViewController:fontView animated:NO];
				break;
			}
		}
}





- (BOOL)checkSwitchState:(NSString *)cellName
{
	BOOL check = NO;
	SWITCH(cellName)
	{

		CASE(@"AutoCorrect")
		{

			check = self.mySharedDefaults.isAutoCorrect;

			break;
		}
		CASE(@"QuickPeriod")
		{
			check = self.mySharedDefaults.isQuickPeriod;

			break;
		}
		CASE(@"AutoCapitalize")
		{

			check = self.mySharedDefaults.isAutoCapitalize;

			break;
		}
		CASE(@"DoubleSpace")
		{

			check = self.mySharedDefaults.isDoubleSpacePunctuation;

			break;
		}
		CASE(@"KeyClick")
		{
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

- (void)switchTapped:(UISwitch *)sender
{

	CGPoint switchPositionPoint = [sender convertPoint:CGPointZero toView:[self tableView]];
	NSIndexPath *indexPath = [[self tableView] indexPathForRowAtPoint:switchPositionPoint];
	MMSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];


	SWITCH(cell.cellID)
	{

		CASE(@"AutoCorrect")
		{

			[self.mySharedDefaults setIsAutoCorrect:sender.on];

			break;
		}
		CASE(@"QuickPeriod")
		{

			[self.mySharedDefaults setIsQuickPeriod:sender.on];

			break;
		}
		CASE(@"AutoCapitalize")
		{

			[self.mySharedDefaults setIsAutoCapitalize:sender.on];

			break;
		}
		CASE(@"DoubleSpace")
		{

			[self.mySharedDefaults setIsDoubleSpacePunctuation:sender.on];

			break;
		}
		CASE(@"KeyClick")
		{

			[self.mySharedDefaults setIsKeyClickSounds:sender.on];

			break;
		}

		DEFAULT
		{
			break;
		}
	}
}




@end