//
// Created by Tom Atterton on 13/05/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMSettingsFontView.h"
#import "MMFontData.h"
#import "MMSettingsFontCell.h"
#import "NSUserDefaults+Keyboard.h"
#import "MMFontModel.h"


@interface MMSettingsFontView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSString *currentKeyboardFont;
@property (nonatomic, strong) NSUserDefaults *mySharedDefaults;
@end

@implementation MMSettingsFontView


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	MMFontData *mmThemeData = [[MMFontData alloc] init];
	self.data = [mmThemeData.data mutableCopy];
}

- (void)viewDidLoad
{
	[super viewDidLoad];


	self.tableView = [UITableView new];
	self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.tableView registerClass:[MMSettingsFontCell class] forCellReuseIdentifier:@"CELL"];
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
	[self.navigationItem setTitle:@"Fonts"];

	NSDictionary *metrics = @{};
	NSDictionary *views = @{@"tableView" : self.tableView};

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	self.currentKeyboardFont = self.mySharedDefaults.isKeyboardFont;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

	MMSettingsFontCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
	NSUInteger item = (NSUInteger)indexPath.item;

	MMFontModel *fontModel = [[MMFontModel alloc] initWithDictionary:self.data[item]];
	[cell.titleLabel setText:fontModel.settingsTitle];
	cell.fontString = fontModel.settingsID;
	[cell.titleLabel setFont:[UIFont fontWithName:fontModel.settingsID size:16]];
	if ([cell.fontString isEqualToString:self.currentKeyboardFont])
	{
		[cell setSelected:YES];
		[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:nil];
		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];

	}
	else
	{
		[cell setAccessoryType:nil];
	}

	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	MMSettingsFontCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	[self.mySharedDefaults setIsKeyboardFont:cell.fontString];
	[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
	MMSettingsFontCell *cell = [tableView cellForRowAtIndexPath:indexPath];

	[cell setAccessoryType:nil];
}


@end