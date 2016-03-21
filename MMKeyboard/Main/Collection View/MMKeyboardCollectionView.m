//
// Created by Tom Atterton on 16/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMKeyboardCollectionView.h"
#import "MMKeyboardCollectionViewCell.h"
#import "AFURLSessionManager.h"
#import "KeyboardButtonView.h"
#import "CoreDataStack.h"
#import "GIFEntity.h"
#import "KeyboardViewController.h"
#import "MMKeyboardCollectionViewFlowLayout.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface MMKeyboardCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate>

// View
@property(nonatomic, strong) KeyboardButtonView *buttonView;
@property(nonatomic, strong) MMKeyboardCollectionViewFlowLayout *collectionFlowLayout;
@property(nonatomic, strong) KeyboardViewController *presentingViewController;


// Variables
@property(nonatomic, strong) NSMutableArray *data;
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, assign) MMSearchType type;
@property(nonatomic, assign) BOOL isPortrait;


// Gestures
@property(nonatomic, strong) UILongPressGestureRecognizer *lpgr;


@end


@implementation MMKeyboardCollectionView


	- (instancetype)initWithPresentingViewController:(KeyboardViewController *)presentingViewController {
		self = [super init];

		if (self) {

			self.type = MMSearchTypeAll;
			self.presentingViewController = presentingViewController;
			self.lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
			self.lpgr.minimumPressDuration = .5;
			self.lpgr.allowableMovement = 100.0f;
			self.lpgr.delaysTouchesBegan = YES;
			self.lpgr.delegate = self;
			self.lpgr.cancelsTouchesInView = NO;

			[self setup];
		}

		return self;
	}

- (void)setup {

	[self setTranslatesAutoresizingMaskIntoConstraints:NO];

	[self.fetchedResultsController performFetch:nil];


	self.collectionFlowLayout = [MMKeyboardCollectionViewFlowLayout new];
	[self.collectionFlowLayout setMinimumInteritemSpacing:1.0f];
	[self.collectionFlowLayout setMinimumLineSpacing:1.0f];
	[self.collectionFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

	self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionFlowLayout];
	self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	self.collectionView.clipsToBounds = YES;
	[self.collectionView registerClass:[MMKeyboardCollectionViewCell class] forCellWithReuseIdentifier:[MMKeyboardCollectionViewCell reuseIdentifier]];
	self.collectionView.pagingEnabled = YES;
	self.collectionView.backgroundColor = [UIColor blackColor];
	[self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	[self.collectionView addGestureRecognizer:self.lpgr];
	[self addSubview:self.collectionView];

	self.isPortrait = YES;

	NSDictionary *metrics = @{};
	NSDictionary *views = @{
			@"shareCollectionView" : self.collectionView,
	};

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[shareCollectionView]-0-|" options:metrics metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[shareCollectionView]-0-|" options:metrics metrics:metrics views:views]];

	[self loadGifs];
}

#pragma mark Methods

- (void)loadGifs {

	self.data = [@[] mutableCopy];


	NSArray *tempArray = [[self.fetchedResultsController fetchedObjects] valueForKey:NSLocalizedString(@"CoreData.Category.Key", nil)];

	if (tempArray.count == 0) {
		NSLog(@"Empty");
	}
	else {

		[self.fetchedResultsController.fetchedObjects enumerateObjectsUsingBlock:^(GIFEntity *entity, NSUInteger idx, BOOL *stop) {

			switch (self.type) {
				case MMSearchTypeAll: {
					[self.data addObject:entity.gifURL];
					break;
				}
				case MMSearchTypeNormal: {

					if ([entity.gifCategory isEqualToString:@"Normal"]) {
						[self.data addObject:entity.gifURL];
					}
					break;
				}
				case MMSearchTypeAwesome: {
					if ([entity.gifCategory isEqualToString:@"Awesome"]) {
						[self.data addObject:entity.gifURL];
					}
					break;
				}
			}

		}];
	}

	[self.collectionView.collectionViewLayout invalidateLayout];
	[self.collectionView reloadData];
}


#pragma mark CollectionView Delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.data ? self.data.count : 0;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

	return self.isPortrait ? CGSizeMake((CGFloat) (collectionView.frame.size.width / 2.015), (CGFloat) (collectionView.frame.size.width / 4.06)) : CGSizeMake((CGFloat) (collectionView.frame.size.width / 4.015), (CGFloat) (collectionView.frame.size.height / 1.45));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
	tapGestureRecognizer.delegate = self;
	tapGestureRecognizer.delaysTouchesBegan = YES;
	[self.collectionView addGestureRecognizer:tapGestureRecognizer];


	MMKeyboardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MMKeyboardCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
	[cell setBackgroundColor:[UIColor clearColor]];

	[cell setData:self.data[(NSUInteger) indexPath.row]];

	return cell;
}


#pragma mark Touch Gestures

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
	CGPoint p = [sender locationInView:self.collectionView];
	NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];

//	NSURL *url = [[NSURL alloc] initWithString:self.data[(NSUInteger) indexPath.row]];
	self.presentingViewController.gifURL = self.data[(NSUInteger) indexPath.row];
	[self.presentingViewController tappedGIF];
//	[self loadMessage:@"URL Copied!"];

}


- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender {
	if ([sender isEqual:self.lpgr]) {

		if (sender.state == UIGestureRecognizerStateBegan) {

			self.buttonView = [[KeyboardButtonView alloc] initWithFrame:self.frame];
			self.buttonView.translatesAutoresizingMaskIntoConstraints = NO;
			[self addSubview:self.buttonView];


			NSDictionary *views = @{@"buttonView" : self.buttonView};

			[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[buttonView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
			[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[buttonView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];


			CGPoint p = [sender locationInView:self.collectionView];
			NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];

			if (indexPath == nil) {
				NSLog(@"couldn't find index path");
			}
			else {

				self.buttonView.gifUrl = self.data[(NSUInteger) indexPath.row];
				self.presentingViewController.gifURL = self.data[(NSUInteger) indexPath.row];
			}
		}

	}
}


#pragma  mark - NSFetchedResultController

- (NSFetchRequest *)entryListFetchRequest {
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"GIFEntity"];
	fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"gifURL" ascending:NO]]; // This will sort how the request is shown
	return fetchRequest;
}

- (NSFetchedResultsController *)fetchedResultsController {
	if (_fetchedResultsController != nil) {
		return _fetchedResultsController;
	}
	CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
	NSFetchRequest *fetchRequest = [self entryListFetchRequest];
	_fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:@"gifURL" cacheName:nil];

	if ([_fetchedResultsController fetchedObjects]) {
		_fetchedResultsController.delegate = self;
	}
	return _fetchedResultsController;
}

#pragma  mark MMKeyboardView Actions

- (void)onAllGifsButtonTapped:(UIButton *)sender {

	if (self.type != MMSearchTypeAll) {
		self.type = MMSearchTypeAll;
		[self loadGifs];
		[self.collectionView setContentOffset:CGPointZero animated:YES];

	}
}

- (void)onNormalButtonTapped:(UIButton *)sender {

	if (self.type != MMSearchTypeNormal) {
		self.type = MMSearchTypeNormal;
		[self loadGifs];
		[self.collectionView setContentOffset:CGPointZero animated:YES];
	}

}

- (void)onAwesomeButtonTapped:(UIButton *)sender {

	if (self.type != MMSearchTypeAwesome) {
		self.type = MMSearchTypeAwesome;
		[self loadGifs];
		[self.collectionView setContentOffset:CGPointZero animated:YES];
	}
}

- (void)willRotateKeyboard:(UIInterfaceOrientation)toInterfaceOrientation {


	if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		self.isPortrait = NO;
	}
	else {
		self.isPortrait = YES;
	}
	[self.collectionView.collectionViewLayout invalidateLayout];
}

@end