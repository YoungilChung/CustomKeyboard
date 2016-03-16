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

@interface MMKeyboardCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate>

// View
@property(nonatomic, strong) KeyboardButtonView *buttonView;
@property(nonatomic, strong) UICollectionView *collectionView;

// Variables
@property(nonatomic, strong) NSMutableArray *data;
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic) MMSearchType type;
@property (nonatomic, strong) NSIndexPath *longPressIndex;



//
@property(nonatomic, strong) UILongPressGestureRecognizer *lpgr;


@end


@implementation MMKeyboardCollectionView


- (instancetype)initWithFrame:(CGRect)frame {


	self = [super initWithFrame:frame];

	if (self) {

//		self.presentingViewController = presentingViewController;
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


	UICollectionViewFlowLayout *collectionFlowLayout = [UICollectionViewFlowLayout new];
	[collectionFlowLayout setMinimumInteritemSpacing:1.0f];
	[collectionFlowLayout setMinimumLineSpacing:1.0f];
	[collectionFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];


	self.collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:collectionFlowLayout];
	self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	self.collectionView.clipsToBounds = YES;
	[self.collectionView registerClass:[MMKeyboardCollectionViewCell class] forCellWithReuseIdentifier:[MMKeyboardCollectionViewCell reuseIdentifier]];
	self.collectionView.pagingEnabled = YES;  // TODO do we need paging
	self.collectionView.backgroundColor = [UIColor blackColor];
	[self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	[self.collectionView addGestureRecognizer:self.lpgr]; // TODO
	[self addSubview:self.collectionView];


	NSDictionary *metrics = @{};
	NSDictionary *views = @{
			@"collectionView" : self.collectionView,
	};


	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|" options:metrics metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collectionView]-0-|" options:metrics metrics:metrics views:views]];

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
	return self.data ? self.data.count: 0;
}


//
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

	return CGSizeMake((CGFloat) (collectionViewLayout.collectionView.frame.size.width / 2.015), (CGFloat) (collectionView.frame.size.width / 4.115));
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark Touch Gestures

- (void)check3Dtouch {
	// register for 3D Touch (if available)
	if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {

//		[self registerForPreviewingWithDelegate:(id) self sourceView:self.view];
		NSLog(@"3D Touch is available! Hurra!");

		// no need for our alternative anymore
		//		self.lpgr.enabled = NO;
	}
	else {
		// handle a 3D Touch alternative (long gesture recognizer)
		self.lpgr.enabled = YES;
	}
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
	CGPoint p = [sender locationInView:self.collectionView];
	NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];

//	NSString *gifUrl = [NSString stringWithFormat:@"%@", self.urlHolderArray[indexPath.row]];
//	NSURL *url = [[NSURL alloc] initWithString:self.urlHolderArray[indexPath.row]];
//
//	NSData *data = [NSData dataWithContentsOfURL:url];
//	[[UIPasteboard generalPasteboard] setData:data forPasteboardType:(NSString *) kUTTypeGIF];
//	[self.textDocumentProxy insertText:gifUrl];
//	[self loadMessage:@"URL Copied!"];

}


- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender {
	if ([sender isEqual:self.lpgr]) {

		if (sender.state == UIGestureRecognizerStateBegan) {

			self.buttonView = [[KeyboardButtonView alloc] initWithFrame:self.frame];
			self.buttonView.translatesAutoresizingMaskIntoConstraints = NO;
			[self addSubview:self.buttonView];

			self.buttonView.gifUrl = self.data[(NSUInteger) self.longPressIndex.row];

			NSDictionary *views = @{@"buttonView" : self.buttonView};

			[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[buttonView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
			[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[buttonView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];


			CGPoint p = [sender locationInView:self.collectionView];

			NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
			if (indexPath == nil) {
				NSLog(@"couldn't find index path");
			}
			else {

				self.longPressIndex = indexPath; //TODO doesn't update the url bla bla bla
			}
		}

	}
}


#pragma  mark - NSFetchedResultController

- (NSFetchRequest *)entryListFetchRequest {
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"GIFEntity"];
	fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"gifCategory" ascending:NO]]; // This will sort how the request is shown
	//    NSLog(fetchRequest.sortDescriptors);
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


#pragma mark rotation TODO
//
//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//	[self.collectionView setAlpha:0.0f];
//	[self.collectionView.collectionViewLayout invalidateLayout];
//	CGPoint currentOffset = [self.collectionView contentOffset];
//	self.currentIndex = currentOffset.x / self.collectionView.frame.size.width;
//}
//
//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//	NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
//	[self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
//	[UIView animateWithDuration:0.125f animations:^{
//		[self.collectionView setAlpha:1.0f];
//	}];
//}


@end