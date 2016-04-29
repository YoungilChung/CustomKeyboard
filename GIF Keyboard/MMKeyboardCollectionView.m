//
// Created by Tom Atterton on 16/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMKeyboardCollectionView.h"
#import "MMKeyboardCollectionViewCell.h"
#import "AFURLSessionManager.h"
#import "MMKeyboardButtonView.h"
#import "CoreDataStack.h"
#import "GIFEntity.h"
#import "MMKeyboardCollectionViewFlowLayout.h"
#import "SearchGIFManager.h"
#import "MMAlphaKeyboardView.h"
#import "KeyboardDelegate.h"
#import <FLAnimatedImage/FLAnimatedImageView.h>
#import <FLAnimatedImage/FLAnimatedImage.h>
#import "UIImage+emoji.h"
#import "EmptyGIFCell.h"


@interface MMKeyboardCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate,
		UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate, SearchMangerDelegate>

// View
@property(nonatomic, strong) MMKeyboardButtonView *buttonView;
@property(nonatomic, strong) MMKeyboardCollectionViewFlowLayout *collectionFlowLayout;
@property(nonatomic, strong) EmptyGIFCell *emptyCellView;


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

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[shareCollectionView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[shareCollectionView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	[self loadGIFS];
}

#pragma mark Methods

- (void)loadGIFS {

	[self.fetchedResultsController performFetch:nil];

	self.data = [@[] mutableCopy];
	[self.keyboardCollectionView setContentOffset:CGPointZero animated:YES];


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
}


#pragma mark CollectionView Delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

	if (self.data.count == 0) {

		[self loadEmptyCell];

		return 0;
	}
	else {

		[self.emptyCellView removeFromSuperview];

	}
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
			if (item) {

				[self.gifHolder setValue:tempImage forKey:[self.data valueForKey:@"gifURL"][item]];
			}
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

			self.buttonView = [[MMKeyboardButtonView alloc] initWithFrame:self.frame WithEntity:(self.type == MMSearchTypeGiphy) ? nil : self.data[(NSUInteger) indexPath.row]];
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


- (void)didReceiveGIFS:(NSArray *)groups didReceiveHighQualityGIFS:(NSArray *)sendGroups {

	self.type = MMSearchTypeGiphy;
	self.data = [groups mutableCopy];
	self.higherQualityGif = [sendGroups mutableCopy];


	double delayInSeconds = 1.0;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
		[self.keyboardCollectionView reloadData];
	});
}


- (void)fetchingGIFSFailedWithError:(NSError *)error {
	NSLog(@"Error %@; %@", error, [error localizedDescription]);
}


- (void)loadEmptyCell {

	self.emptyCellView = [EmptyGIFCell new];
	self.emptyCellView.translatesAutoresizingMaskIntoConstraints = NO;
	self.emptyCellView.backgroundColor = [UIColor clearColor];
	[self addSubview:self.emptyCellView];
	NSDictionary *views = @{@"emptyCellView" : self.emptyCellView};
	NSDictionary *metrics = @{@"padding" : @(10)};

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[emptyCellView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[emptyCellView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
}

@end