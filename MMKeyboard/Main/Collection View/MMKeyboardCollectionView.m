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
#import "SearchGIFManager.h"
#import "MMAlphaKeyboardView.h"
#import "KeyboardDelegate.h"
#import <FLAnimatedImage/FLAnimatedImageView.h>
#import <FLAnimatedImage/FLAnimatedImage.h>

@interface MMKeyboardCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate,
		UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate, SearchMangerDelegate>

// View
@property(nonatomic, strong) KeyboardButtonView *buttonView;
@property(nonatomic, strong) MMKeyboardCollectionViewFlowLayout *collectionFlowLayout;

// Variables
@property(nonatomic, strong) NSMutableArray *data;
@property(nonatomic, strong) NSMutableArray *higherQualityGif;

@property(nonatomic, weak) NSMutableDictionary *gifHolder;

@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, assign) BOOL isPortrait;


// Gestures
@property(nonatomic, strong) UILongPressGestureRecognizer *lpgr;


@end


@implementation MMKeyboardCollectionView


- (instancetype)init {
	self = [super init];

	if (self) {

		self.type = MMSearchTypeAll;
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

	self.gifHolder = @{}.mutableCopy;
	self.higherQualityGif = @[].mutableCopy;


	self.collectionFlowLayout = [MMKeyboardCollectionViewFlowLayout new];
	[self.collectionFlowLayout setMinimumInteritemSpacing:0];
	[self.collectionFlowLayout setMinimumLineSpacing:0];
	[self.collectionFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

	self.keyboardCollectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:self.collectionFlowLayout];

	self.keyboardCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.keyboardCollectionView registerClass:[MMKeyboardCollectionViewCell class] forCellWithReuseIdentifier:[MMKeyboardCollectionViewCell reuseIdentifier]];
	self.keyboardCollectionView.backgroundColor = [UIColor blackColor];
	[self.keyboardCollectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
	self.keyboardCollectionView.delegate = self;
	self.keyboardCollectionView.dataSource = self;
	[self.keyboardCollectionView addGestureRecognizer:self.lpgr];
	[self addSubview:self.keyboardCollectionView];


	self.searchManager = [[SearchGIFManager alloc] init];
	self.searchManager.communicator = [[SearchForGIFSCommunicator alloc] init];
	self.searchManager.communicator.delegate = self.searchManager;
	self.searchManager.delegate = self;


	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
	tapGestureRecognizer.delegate = self;
	tapGestureRecognizer.delaysTouchesBegan = YES;
	[self.keyboardCollectionView addGestureRecognizer:tapGestureRecognizer];

	self.isPortrait = YES;

	NSDictionary *metrics = @{};
	NSDictionary *views = @{
			@"shareCollectionView" : self.keyboardCollectionView,
	};

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[shareCollectionView]-0-|" options:nil metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[shareCollectionView]-0-|" options:nil metrics:metrics views:views]];

	[self loadGifs];
}

#pragma mark Methods

- (void)loadGifs {

	[self.fetchedResultsController performFetch:nil];

	self.data = [@[] mutableCopy];


	NSArray *tempArray = [[self.fetchedResultsController fetchedObjects] valueForKey:NSLocalizedString(@"CoreData.Category.Key", nil)];

	if (tempArray.count == 0) {
		NSLog(@"Empty");
	}
	else {

		[self.fetchedResultsController.fetchedObjects enumerateObjectsUsingBlock:^(GIFEntity *entity, NSUInteger idx, BOOL *stop) {

			switch (self.type) {
				case MMSearchTypeAll: {
					[self.data addObject:entity];
					break;
				}
				case MMSearchTypeNormal: {

					if ([entity.gifCategory isEqualToString:@"Normal"]) {
						[self.data addObject:entity];
					}
					break;
				}
				case MMSearchTypeAwesome: {
					if ([entity.gifCategory isEqualToString:@"Awesome"]) {
						[self.data addObject:entity];
					}

					break;
				}
				case MMSearchTypeGiphy: {


					break;
				}
			}

		}];
	}

	[self.keyboardCollectionView reloadData];
//	[self.gifKeyboardView.collectionViewLayout invalidateLayout];
//	[self.gifKeyboardView layoutIfNeeded];
//	dispatch_async(dispatch_get_main_queue(), ^{
//		// Update the UI
//		self.collectionViewSize = CGSizeMake((CGFloat) (self.frame.size.width / 2), (CGFloat) (self.frame.size.width / 4));
//
//	});
}


#pragma mark CollectionView Delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.data ? self.data.count : 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

	return self.keyboardCollectionViewSize;

}

- (MMKeyboardCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

	MMKeyboardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MMKeyboardCollectionViewCell reuseIdentifier] forIndexPath:indexPath];

	[cell setBackgroundColor:[UIColor clearColor]];

	NSUInteger item = (NSUInteger) indexPath.item;
	FLAnimatedImage *image = self.gifHolder[self.data[item]];
	cell.imageView.alpha = 0.f;

	if (image) {

		[cell.imageView setAnimatedImage:image];
		cell.imageView.alpha = 1.f;
		return cell;
	}

	[self loadGifItem:item callback:^(FLAnimatedImage *tempImage) {

		if (self.type == MMSearchTypeGiphy) {
			[self.gifHolder setValue:tempImage forKey:self.data[item]];
		}
		else {
			[self.gifHolder setValue:tempImage forKey:[self.data valueForKey:@"gifURL"][item]];
		}

		cell.imageView.alpha = 1.f;
		[cell.imageView setAnimatedImage:tempImage];
	}];

	[cell layoutIfNeeded];
	return cell;
}

- (void)loadGifItem:(NSUInteger)item callback:(void (^)(FLAnimatedImage *image))callback {
	NSURL *url;
	if (item < self.data.count) {

		if (self.type == MMSearchTypeGiphy) {

			url = [[NSURL alloc] initWithString:self.data[item]];
		}
		else {
			url = [[NSURL alloc] initWithString:[self.data valueForKey:@"gifURL"][item]];
		}
		NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
		NSURLSession *session = [NSURLSession sharedSession];
		NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest
												completionHandler:
														^(NSData *data, NSURLResponse *response, NSError *error) {
															FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
															callback(image);

														}];
		[task resume];


	}
}


#pragma mark Touch Gestures

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
	CGPoint p = [sender locationInView:self.keyboardCollectionView];
	NSIndexPath *indexPath = [self.keyboardCollectionView indexPathForItemAtPoint:p];

	if (self.type == MMSearchTypeGiphy) {

		self.gifURL = self.higherQualityGif[(NSUInteger) indexPath.row];
	}
	else {

		self.gifURL = [self.data valueForKey:@"gifURL"][(NSUInteger) indexPath.row];
	}

	NSLog(@"gifURL:%@", self.gifURL);
	[self.keyboardDelegate cellWasTapped:self.gifURL WithMessageTitle:@"URL Copied"];

//	[self.presentingViewController tappedGIF];
//	[self.keyboardDelegate cellWasTapped:];
}


- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender {
	if ([sender isEqual:self.lpgr]) {

		if (sender.state == UIGestureRecognizerStateBegan) {

			CGPoint p = [sender locationInView:self.keyboardCollectionView];
			NSIndexPath *indexPath = [self.keyboardCollectionView indexPathForItemAtPoint:p];

			self.buttonView = [[KeyboardButtonView alloc] initWithFrame:self.frame WithEntity:(self.type == MMSearchTypeGiphy) ? nil : self.data[(NSUInteger) indexPath.row]];
			self.buttonView.translatesAutoresizingMaskIntoConstraints = NO;
			[self addSubview:self.buttonView];


			NSDictionary *views = @{@"buttonView" : self.buttonView};

			[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[buttonView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
			[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[buttonView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];


			if (indexPath == nil) {
				NSLog(@"couldn't find index path");
			}
			else {

				if (self.type == MMSearchTypeGiphy) {

					self.gifURL = self.higherQualityGif[(NSUInteger) indexPath.row];
				}
				else {

					self.gifURL = [self.data valueForKey:@"gifURL"][(NSUInteger) indexPath.row];
				}
				self.buttonView.gifUrl = self.gifURL;
				[self.keyboardDelegate cellWasTapped:self.gifURL WithMessageTitle:nil];
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
		[self.keyboardCollectionView setContentOffset:CGPointZero animated:YES];

	}
}

- (void)onNormalButtonTapped:(UIButton *)sender {

	if (self.type != MMSearchTypeNormal) {
		self.type = MMSearchTypeNormal;
		[self loadGifs];
		[self.keyboardCollectionView setContentOffset:CGPointZero animated:YES];
	}

}

- (void)onAwesomeButtonTapped:(UIButton *)sender {

	if (self.type != MMSearchTypeAwesome) {
		self.type = MMSearchTypeAwesome;
		[self loadGifs];
		[self.keyboardCollectionView setContentOffset:CGPointZero animated:YES];
	}
}


- (void)didReceiveGIFS:(NSArray *)groups didReceiveSendGifs:(NSArray *)sendGroups {


	self.higherQualityGif = [sendGroups mutableCopy];
	self.data = [groups mutableCopy];
	self.type = MMSearchTypeGiphy;
	[self.keyboardCollectionView reloadData];
}


- (void)fetchingGIFSFailedWithError:(NSError *)error {
	NSLog(@"Error %@; %@", error, [error localizedDescription]);
}



//- (void)willRotateKeyboard:(UIInterfaceOrientation)toInterfaceOrientation {
//
//
//	self.isPortrait = !(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
//	[self.gifKeyboardView.collectionViewLayout invalidateLayout];
//}

@end