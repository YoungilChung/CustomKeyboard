//
// Created by Tom Atterton on 11/05/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMMainViewController.h"
#import "MMCollectedGIFSViewController.h"
#import "MMOnBoardingViewController.h"
#import "MMSearchViewController.h"
#import "MMSettingsViewController.h"


@interface MMMainViewController ()


@end

@implementation MMMainViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	MMOnBoardingViewController *onBoardingViewController = [[MMOnBoardingViewController alloc] init];
	[onBoardingViewController.tabBarItem initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:1];
	onBoardingViewController.title = @"About";

	MMCollectedGIFSViewController *collectedGIFSViewController = [[MMCollectedGIFSViewController alloc] init];
	[collectedGIFSViewController.tabBarItem initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:2];
	collectedGIFSViewController.title = @"GIFS";

	MMSearchViewController *searchViewController = [[MMSearchViewController alloc] init];
	[searchViewController.tabBarItem initWithTabBarSystemItem:UITabBarSystemItemSearch tag:3];

	MMSettingsViewController *settingsViewController = [[MMSettingsViewController alloc] init];
	[settingsViewController.tabBarItem initWithTabBarSystemItem:UITabBarSystemItemMore tag:4];

	[self setViewControllers:@[onBoardingViewController, collectedGIFSViewController, searchViewController, settingsViewController]];

}


@end