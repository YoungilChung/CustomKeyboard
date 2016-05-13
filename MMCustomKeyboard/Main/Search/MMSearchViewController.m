//
// Created by Tom Atterton on 11/05/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <FLAnimatedImage/FLAnimatedImage.h>
#import "MMSearchViewController.h"
#import "MMGIFKeyboardCollectionViewCell.h"
#import "SearchForGIFSCommunicator.h"
#import "SearchGIFManager.h"
#import "MMGIFKeyboardCollectionView.h"
#import "EmptyGIFCell.h"
#import "MMSearchPreviewViewController.h"


@interface MMSearchViewController () <UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SearchGifsDelegate, SearchMangerDelegate>

// Views
@property (nonatomic, strong) UITextField *searchBar;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) EmptyGIFCell *emptyCellView;


// Variables
@property (nonatomic, strong) SearchGIFManager *searchManager;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableDictionary *gifHolder;


@property (nonatomic, strong) UILabel *searchTitle;
@end

@implementation MMSearchViewController


- (void)viewDidAppear:(BOOL)animated
{

	self.gifHolder = @{}.mutableCopy;
	self.data = @[].mutableCopy;

	self.searchManager = [[SearchGIFManager alloc] init];
	self.searchManager.communicator = [[SearchForGIFSCommunicator alloc] init];
	self.searchManager.communicator.delegate = self.searchManager;
	self.searchManager.delegate = self;

	[self retrieveGIFSWithString:nil withType:kSearchTypeTrending];

}

- (void)viewDidLoad
{
	[super viewDidLoad];


	UILabel *magnifyingGlass = [[UILabel alloc] init];
	[magnifyingGlass setText:[[NSString alloc] initWithUTF8String:"\xF0\x9F\x94\x8D"]];
	[magnifyingGlass sizeToFit];


	self.searchTitle = [UILabel new];
	self.searchTitle.translatesAutoresizingMaskIntoConstraints = NO;
	[self.searchTitle setText:@"Trending"];
	[self.searchTitle setTextColor:[UIColor whiteColor]];
	[self.searchTitle setFont:[UIFont fontWithName:@"Helvetica" size:19]];
	[self.searchTitle setTextAlignment:NSTextAlignmentCenter];
	[self.view addSubview:self.searchTitle];

//	self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.2 blue:0.5 alpha:0.7];


	self.searchBar = [[UITextField alloc] init];
	self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
	self.searchBar.clipsToBounds = YES;
	self.searchBar.backgroundColor = [UIColor whiteColor];
	[self.searchBar setPlaceholder:@"Search for a GIF"];
	[self.searchBar setFont:[UIFont fontWithName:@"Helvetica" size:16]];
	self.searchBar.layer.cornerRadius = 4;
	[self.searchBar setLeftView:magnifyingGlass];
	[self.searchBar setLeftViewMode:UITextFieldViewModeAlways];
	[self.view addSubview:self.searchBar];
	self.searchBar.delegate = self;

	self.flowLayout = [UICollectionViewFlowLayout new];
	self.flowLayout.minimumInteritemSpacing = 0;
	[self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

	self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.flowLayout];
	[self.collectionView registerClass:[MMGIFKeyboardCollectionViewCell class] forCellWithReuseIdentifier:[MMGIFKeyboardCollectionViewCell reuseIdentifier]];
	self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	self.collectionView.backgroundColor = [UIColor blackColor];
	[self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 60, 0)];
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	[self.view addSubview:self.collectionView];

	NSDictionary *views = @{@"searchBar" : self.searchBar, @"searchTitle" : self.searchTitle, @"collectionView" : self.collectionView};
	NSDictionary *metrics = @{@"searchBarHeight" : @(40)};

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[searchBar(searchBarHeight)]-5-[searchTitle]-5-[collectionView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[searchBar]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[searchTitle]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];


//	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
//	[self.view addGestureRecognizer:tap];

}


#pragma mark CollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.data ? self.data.count : 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

	return CGSizeMake((CGFloat)(self.view.frame.size.width / 3 - 4), (CGFloat)(self.view.frame.size.width / 3 - 4));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

	MMGIFKeyboardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MMGIFKeyboardCollectionViewCell reuseIdentifier] forIndexPath:indexPath];

	[cell setBackgroundColor:[UIColor clearColor]];

	NSUInteger item = (NSUInteger)indexPath.item;
	FLAnimatedImage *image = self.gifHolder[self.data[item]];
	cell.imageView.alpha = 0.f;

	if (image)
	{

		[cell.imageView setAnimatedImage:image];
		cell.imageView.alpha = 1.f;
		return cell;
	}

	[self loadGifItem:item callback:^(FLAnimatedImage *tempImage)
	{


		[self.gifHolder setValue:tempImage forKey:self.data[item]];


		cell.imageView.alpha = 1.f;
		[cell.imageView setAnimatedImage:tempImage];
	}];

	[cell layoutIfNeeded];
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

	NSLog(@"came jere");

	MMGIFKeyboardCollectionViewCell *cell = (MMGIFKeyboardCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
	MMSearchPreviewViewController *viewController = [[MMSearchPreviewViewController alloc] initWithAnimatedImage:cell.imageView.animatedImage withURL:self.data[(NSUInteger)indexPath.row]];
	viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
	[self presentViewController:viewController animated:YES completion:nil];

}


#pragma  mark Loading Gif Helper Method

- (void)loadGifItem:(NSUInteger)item callback:(void (^) (FLAnimatedImage *image))callback
{
	NSURL *url;

	if (item < self.data.count)
	{


		url = [[NSURL alloc] initWithString:self.data[item]];


		NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
		NSURLSession *session = [NSURLSession sharedSession];
		NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest
											  completionHandler:
													  ^(NSData *data, NSURLResponse *response, NSError *error)
													  {
														  FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
														  callback(image);

													  }];
		[task resume];

	}

}

- (void)retrieveGIFSWithString:(NSString *)query withType:(searchType)searchType
{

	[self.searchManager fetchGIFSForSearchQuery:query withSearchType:searchType];

	if (query)
	{

		[self.searchTitle setText:query];
	}
}


#pragma mark Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

	// This is where you search
	[self retrieveGIFSWithString:textField.text withType:kSearchTypeString];
	[self dismissKeyboard];

	return YES;
}


#pragma  mark SearchGifs Delegate

- (void)didReceiveGIFS:(NSArray *)groups
{


	if (groups.count > 0)
	{

		dispatch_async(dispatch_get_main_queue(), ^
		{
			[self.emptyCellView removeFromSuperview];
			self.data = [groups mutableCopy];
			[self.collectionView reloadData];
		});

	}
	else
	{

		dispatch_async(dispatch_get_main_queue(), ^
		{

			self.data = @[].mutableCopy;
			[self.collectionView reloadData];
			[self loadEmptyCell];

		});

	}

}

- (void)fetchingGIFSFailedWithError:(NSError *)error
{

}


#pragma mark Keyboard Method

- (void)dismissKeyboard
{
	[self.searchBar resignFirstResponder];
}

#pragma mark Helper

- (void)loadEmptyCell
{

	self.emptyCellView = [EmptyGIFCell new];
	self.emptyCellView.translatesAutoresizingMaskIntoConstraints = NO;
	self.emptyCellView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.emptyCellView];
	NSDictionary *views = @{@"emptyCellView" : self.emptyCellView};
	NSDictionary *metrics = @{@"padding" : @(10)};

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[emptyCellView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[emptyCellView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

	[self.searchTitle setText:@"Trending"];
}

@end