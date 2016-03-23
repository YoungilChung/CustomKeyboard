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
#import <FLAnimatedImage/FLAnimatedImageView.h>
#import <FLAnimatedImage/FLAnimatedImage.h>

@interface MMKeyboardCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate>

// View
@property(nonatomic, strong) KeyboardButtonView *buttonView;
@property(nonatomic, strong) MMKeyboardCollectionViewFlowLayout *collectionFlowLayout;
@property(nonatomic, strong) KeyboardViewController *presentingViewController;


// Variables
@property(nonatomic, strong) NSMutableArray *data;
@property(nonatomic, strong) NSMutableDictionary *gifHolder;
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

	self.gifHolder = @{}.mutableCopy;
	self.collectionFlowLayout = [MMKeyboardCollectionViewFlowLayout new];
	[self.collectionFlowLayout setMinimumInteritemSpacing:0];
	[self.collectionFlowLayout setMinimumLineSpacing:0];
	[self.collectionFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

	self.keyboardCollectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:self.collectionFlowLayout];

	self.keyboardCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.keyboardCollectionView registerClass:[MMKeyboardCollectionViewCell class] forCellWithReuseIdentifier:[MMKeyboardCollectionViewCell reuseIdentifier]];
	self.keyboardCollectionView.clipsToBounds;
//	self.keyboardCollectionView.pagingEnabled = YES;
	self.keyboardCollectionView.backgroundColor = [UIColor blackColor];
	[self.keyboardCollectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
	self.keyboardCollectionView.delegate = self;
	self.keyboardCollectionView.dataSource = self;
	[self.keyboardCollectionView addGestureRecognizer:self.lpgr];
	[self addSubview:self.keyboardCollectionView];


	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
	tapGestureRecognizer.delegate = self;
	tapGestureRecognizer.delaysTouchesBegan = YES;
	[self.keyboardCollectionView addGestureRecognizer:tapGestureRecognizer];

	self.isPortrait = YES;

	NSDictionary *metrics = @{};
	NSDictionary *views = @{
			@"shareCollectionView" : self.keyboardCollectionView,
	};

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[shareCollectionView]-0-|" options:metrics metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[shareCollectionView]-0-|" options:metrics metrics:metrics views:views]];

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
			}

		}];
	}

	[self.keyboardCollectionView reloadData];
//	[self.keyboardCollectionView.collectionViewLayout invalidateLayout];
//	[self.keyboardCollectionView layoutIfNeeded];
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

//	if (CGSizeEqualToSize(CGSizeZero, self.collectionViewSize)) {
//		return CGSizeZero;
//	}
//	else {
//		NSLog(@"frame%f", self.keyboardCollectionViewSize.height);
	return self.keyboardCollectionViewSize;
//	}

////	: CGSizeMake((CGFloat) (collectionView.frame.size.width / 4.015), (CGFloat) (collectionView.frame.size.height / 2.45)
	return CGSizeMake((CGFloat) (collectionView.frame.size.width / 2), (CGFloat) (collectionViewLayout.collectionViewContentSize.height / 4));
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
		[self.gifHolder setValue:tempImage forKey:[self.data valueForKey:@"gifURL"][item]];
		cell.imageView.alpha = 1.f;

		[cell.imageView setAnimatedImage:tempImage];
	}];

	[cell layoutIfNeeded];
	return cell;
}

- (void)loadGifItem:(NSUInteger)item callback:(void (^)(FLAnimatedImage *image))callback {
	if (item < self.data.count) {
		NSURL *url = [[NSURL alloc] initWithString:[self.data valueForKey:@"gifURL"][item]];
		NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

		[NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
			FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
			callback(image);
		}];
	}
}


#pragma mark Touch Gestures

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
	CGPoint p = [sender locationInView:self.keyboardCollectionView];
	NSIndexPath *indexPath = [self.keyboardCollectionView indexPathForItemAtPoint:p];

	self.gifURL = [self.data valueForKey:@"gifURL"][(NSUInteger) indexPath.row];
	[self.presentingViewController tappedGIF];
}


- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender {
	if ([sender isEqual:self.lpgr]) {

		if (sender.state == UIGestureRecognizerStateBegan) {

			CGPoint p = [sender locationInView:self.keyboardCollectionView];
			NSIndexPath *indexPath = [self.keyboardCollectionView indexPathForItemAtPoint:p];

			self.buttonView = [[KeyboardButtonView alloc] initWithFrame:self.frame WithEntity:self.data[(NSUInteger) indexPath.row]];
			self.buttonView.translatesAutoresizingMaskIntoConstraints = NO;
			[self addSubview:self.buttonView];


			NSDictionary *views = @{@"buttonView" : self.buttonView};

			[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[buttonView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
			[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[buttonView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

			[self.presentingViewController.menuHolder setHidden:YES];

			if (indexPath == nil) {
				NSLog(@"couldn't find index path");
			}
			else {

//				self.buttonView.gifUrl = [self.data valueForKey:@"gifURL"][(NSUInteger) indexPath.row];
				self.gifURL = [self.data valueForKey:@"gifURL"][(NSUInteger) indexPath.row];
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

//- (void)willRotateKeyboard:(UIInterfaceOrientation)toInterfaceOrientation {
//
//
//	self.isPortrait = !(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
//	[self.keyboardCollectionView.collectionViewLayout invalidateLayout];
//}

@end