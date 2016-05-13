//
// Created by Tom Atterton on 13/05/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMSettingsThemeView.h"
#import "MMSettingsHeaderView.h"
#import "MMSettingsThemeCell.h"
#import "MMThemeData.h"
#import "MMThemeModel.h"
#import "NSUserDefaults+Keyboard.h"


@interface MMSettingsThemeView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSUserDefaults *mySharedDefaults;

@property (nonatomic) keyboardTheme currentKeyboardTheme;
@end

@implementation MMSettingsThemeView


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	MMThemeData *mmThemeData = [[MMThemeData alloc] init];
	self.data = [mmThemeData.data mutableCopy];
}

- (void)viewDidLoad
{
	[super viewDidLoad];


	self.tableView = [UITableView new];
	self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.tableView registerClass:[MMSettingsThemeCell class] forCellReuseIdentifier:@"CELL"];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
	[self.tableView setSectionHeaderHeight:20];
	[self.tableView setSeparatorColor:[UIColor clearColor]];
	[self.tableView setBounces:NO];
	[self.tableView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.2 blue:0.5 alpha:0.7]];
	[self.tableView setOpaque:NO];
	[self.view addSubview:self.tableView];

	self.mySharedDefaults = [[NSUserDefaults alloc] init];
	[self.navigationItem setTitle:@"Themes"];

	NSDictionary *metrics = @{};
	NSDictionary *views = @{@"tableView" : self.tableView};

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	self.currentKeyboardTheme = self.mySharedDefaults.keyboardTheme;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

	MMSettingsThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
	NSUInteger item = (NSUInteger)indexPath.item;

	MMThemeModel *themeModel = [[MMThemeModel alloc] initWithDictionary:self.data[item]];
	[cell.titleLabel setText:themeModel.settingsTitle];
	cell.keyboardTheme = themeModel.keyboardTheme;
	NSLog(@"%d", cell.keyboardTheme);
	if (cell.keyboardTheme == self.currentKeyboardTheme)
	{
		[cell setSelected:YES];
		[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:nil];
		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];

	}
	else
	{
		[cell setAccessoryType:nil];
	}
	//TODO image of the theme

	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	MMSettingsThemeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	[self.mySharedDefaults setKeyboardTheme:cell.keyboardTheme];
	[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
	MMSettingsThemeCell *cell = [tableView cellForRowAtIndexPath:indexPath];

	[cell setAccessoryType:nil];
}

@end