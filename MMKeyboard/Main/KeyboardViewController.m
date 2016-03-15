//  KeyboardViewController.m
//  MMKeyboard
//
//  Created by mm0030240 on 06/10/15.
//  Copyright © 2015 mm0030240. All rights reserved.
//

#import "KeyboardViewController.h"
#import "FLAnimatedImage.h"
#import "GIFEntity.h"
#import "CoreDataStack.h"
#import "FLAnimatedImageView.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <FLAnimatedImage/FLAnimatedImageView.h>
#import "PopUpViewController.h"
#import "KeyboardButtonView.h"
#import <MessageUI/MessageUI.h>

@interface KeyboardViewController () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate,
		UIViewControllerPreviewingDelegate, UIGestureRecognizerDelegate, MFMessageComposeViewControllerDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UICollectionViewFlowLayout *collectionFlowLayout;
@property(nonatomic, strong) UIView *holderView;
@property(nonatomic, strong) NSMutableArray *gifHolderArray;
@property(nonatomic, strong) NSMutableArray *urlHolderArray;
@property(nonatomic) NSUInteger numberOfGifs;
@property(nonatomic) NSString *searchKey;
@property(nonatomic) NSInteger currentIndex;
@property(nonatomic) NSString *gifCategory;
@property(nonatomic, strong) NSIndexPath *longPressIndex;
@property(nonatomic, strong) UIButton *shareOneButton;
@property(nonatomic, strong) UIButton *shareTwoButton;
@property(nonatomic, strong) UIButton *allGifsButton;
@property(nonatomic, strong) UIButton *nextKeyboardButton;
@property(nonatomic, strong) UIScrollView *keyboardBackground;
@property(nonatomic, strong) UILabel *messageText;
@property(nonatomic) CGSize collectionViewSize;
@property(nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, strong) UILongPressGestureRecognizer *lpgr;
@property(nonatomic, strong) KeyboardButtonView *buttonView;


@end

@implementation KeyboardViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeSubview:) name:@"closeSubview" object:nil];

}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"closeSubview" object:nil];

}


- (void)viewDidLoad {
	[super viewDidLoad];

	self.view.clipsToBounds = YES;

	// Check 3D Touch
	[self check3Dtouch];
	[self.fetchedResultsController performFetch:nil];
	self.numberOfGifs = 0;
	self.searchKey = @"gifURL";
	self.keyboardBackground.delegate = self;
	self.view.backgroundColor = [UIColor blackColor];


	self.collectionFlowLayout = [UICollectionViewFlowLayout new];
	[self.collectionFlowLayout setMinimumInteritemSpacing:1.0f];
	[self.collectionFlowLayout setMinimumLineSpacing:1.0f];
	[self.collectionFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

	self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.collectionFlowLayout];
	[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
	self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	self.collectionView.pagingEnabled = YES;
	self.collectionView.backgroundColor = [UIColor blackColor];
	[self.nextKeyboardButton setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	[self.view addSubview:self.collectionView];

	UIImageView *keyboardImage = [UIImageView new];
	UIImage *image = [UIImage imageNamed:@"NextKeyboardIcon"];
	keyboardImage.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[keyboardImage setTintColor:[UIColor whiteColor]];
	keyboardImage.translatesAutoresizingMaskIntoConstraints = NO;
	[keyboardImage setContentMode:UIViewContentModeScaleAspectFit];
	[keyboardImage setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisVertical];
	[keyboardImage setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisHorizontal];
	[self.view addSubview:keyboardImage];

	self.nextKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
	[self.nextKeyboardButton setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisVertical];
	[self.nextKeyboardButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.nextKeyboardButton];

	self.allGifsButton = [UIButton buttonWithType:UIButtonTypeSystem];
	self.allGifsButton.translatesAutoresizingMaskIntoConstraints = NO;
	[self.allGifsButton setTitle:(@"All") forState:UIControlStateNormal];
	[self.allGifsButton addTarget:self action:@selector(onAllGifsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self.allGifsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.view addSubview:self.allGifsButton];

	self.shareOneButton = [UIButton buttonWithType:UIButtonTypeSystem];
	self.shareOneButton.translatesAutoresizingMaskIntoConstraints = NO;
	[self.shareOneButton setTitle:(@"Normal") forState:UIControlStateNormal];
	[self.shareOneButton addTarget:self action:@selector(onShareBtnOneTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self.shareOneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.view addSubview:self.shareOneButton];

	self.shareTwoButton = [UIButton buttonWithType:UIButtonTypeSystem];
	self.shareTwoButton.translatesAutoresizingMaskIntoConstraints = NO;
	[self.shareTwoButton setTitle:(@"Awesome") forState:UIControlStateNormal];
	[self.shareTwoButton addTarget:self action:@selector(onShareBtnTwoTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self.shareTwoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.view addSubview:self.shareTwoButton];

	UIImageView *backspaceImage = [UIImageView new];
	UIImage *backImage = [UIImage imageNamed:@"backspaceIcon.png"];
	backspaceImage.image = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[backspaceImage setTintColor:[UIColor whiteColor]];
	backspaceImage.translatesAutoresizingMaskIntoConstraints = NO;
	[backspaceImage setContentMode:UIViewContentModeScaleAspectFit];
	[backspaceImage setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisVertical];
	[backspaceImage setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisHorizontal];
	backspaceImage.clipsToBounds = YES;
	[self.view addSubview:backspaceImage];

	UIButton *backspaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
	backspaceButton.translatesAutoresizingMaskIntoConstraints = NO;
	[backspaceButton setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisVertical];
	[backspaceButton addTarget:self action:@selector(didTapToDelete:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:backspaceButton];

	NSDictionary *views = @{@"collection" : self.collectionView, @"nxtKeyboardBtn" : self.nextKeyboardButton, @"keyboardImage" : keyboardImage,
			@"allBtn" : self.allGifsButton, @"shareBtnOne" : self.shareOneButton, @"shareBtnTwo" : self.shareTwoButton, @"backspaceImage" : backspaceImage, @"backspaceButton" : backspaceButton};
	NSDictionary *metrics = @{@"padding" : @(10)};

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collection]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collection]-0-[shareBtnOne]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collection]-0-[shareBtnTwo]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collection]-5-[keyboardImage]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collection]-0-[allBtn]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collection]-0-[backspaceImage]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[keyboardImage(==backspaceImage)]-0-[allBtn(==shareBtnOne)]-0-[shareBtnOne(==allBtn)]-0-[shareBtnTwo(==allBtn)]-0-[backspaceImage(==50)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];


	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nextKeyboardButton attribute:NSLayoutAttributeCenterY
														  relatedBy:NSLayoutRelationEqual
															 toItem:keyboardImage
														  attribute:NSLayoutAttributeCenterY
														 multiplier:1.0 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nextKeyboardButton attribute:NSLayoutAttributeCenterX
														  relatedBy:NSLayoutRelationEqual
															 toItem:keyboardImage
														  attribute:NSLayoutAttributeCenterX
														 multiplier:1.0 constant:0]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:backspaceButton attribute:NSLayoutAttributeCenterY
														  relatedBy:NSLayoutRelationEqual
															 toItem:backspaceImage
														  attribute:NSLayoutAttributeCenterY
														 multiplier:1.0 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:backspaceButton attribute:NSLayoutAttributeCenterX
														  relatedBy:NSLayoutRelationEqual
															 toItem:backspaceImage
														  attribute:NSLayoutAttributeCenterX
														 multiplier:1.0 constant:0]];
}

- (void)didTapToDelete:(UIButton *)sender {
	[self.textDocumentProxy deleteBackward];
}

- (void)viewDidAppear:(BOOL)animated {
	[self loadGif];

	self.lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
	self.lpgr.minimumPressDuration = .5;
	self.lpgr.allowableMovement = 100.0f;
	self.lpgr.delaysTouchesBegan = YES;
	self.lpgr.delegate = self;
	self.lpgr.cancelsTouchesInView = NO;
	[self.collectionView addGestureRecognizer:self.lpgr];
}

#pragma mark  - Actions

- (void)onAllGifsButtonTapped:(UIButton *)sender {
	self.searchKey = @"gifURL";
	[self.fetchedResultsController performFetch:nil];
	[self loadGif];
}

- (void)onShareBtnTwoTapped:(UIButton *)sender {
	self.searchKey = @"gifCategory";
	self.gifCategory = @"Awesome";
	[self.fetchedResultsController performFetch:nil];
	[self loadGif];
}

- (void)onShareBtnOneTapped:(UIButton *)sender {
	self.searchKey = @"gifCategory";
	self.gifCategory = @"Normal";
	[self.fetchedResultsController performFetch:nil];
	[self loadGif];
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	[self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma  mark - Methods

- (void)loadMessage:(NSString *)textMessage {
	UIView *view = [UIView new];
	view.backgroundColor = [UIColor blackColor];
	view.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:view];

	self.messageText = [UILabel new];
	[self.messageText setText:textMessage];
	[self.messageText setTextColor:[UIColor whiteColor]];
	self.messageText.translatesAutoresizingMaskIntoConstraints = NO;
	[view addSubview:self.messageText];

	NSDictionary *views = @{@"message" : self.messageText, @"view" : view};
	NSDictionary *metrics = @{@"padding" : @(10)};

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[view addConstraint:[NSLayoutConstraint constraintWithItem:self.messageText attribute:NSLayoutAttributeCenterY
													 relatedBy:NSLayoutRelationEqual
														toItem:view attribute:NSLayoutAttributeCenterY
													multiplier:1.0 constant:0]];
	[view addConstraint:[NSLayoutConstraint constraintWithItem:self.messageText attribute:NSLayoutAttributeCenterX
													 relatedBy:NSLayoutRelationEqual
														toItem:view attribute:NSLayoutAttributeCenterX
													multiplier:1.0 constant:0]];

	[UIView animateWithDuration:0.02f delay:1.5f options:0 animations:^{
		view.alpha = 0.0;


	}                completion:^(BOOL finished) {
		[view removeFromSuperview];

	}];
}

- (void)loadGif {

	self.collectionView.scrollEnabled = YES;
	self.gifHolderArray = [@[] mutableCopy];
	self.urlHolderArray = [@[] mutableCopy];
	self.numberOfGifs = 0;

	NSArray *tempArray = [[self.fetchedResultsController fetchedObjects] valueForKey:@"gifCategory"];

	if (tempArray.count == 0) {
		NSLog(@"Empty");
	}
	else {

		if ([self.searchKey isEqualToString:@"gifCategory"]) {
			[self.fetchedResultsController.fetchedObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				if ([self.gifCategory isEqualToString:@"Normal"]) {
					if ([[obj valueForKey:@"gifCategory"] isEqualToString:@"Normal"]) {
						[self.urlHolderArray addObject:[obj valueForKey:@"gifURL"]];
					}
				}
				if ([self.gifCategory isEqualToString:@"Awesome"]) {
					if ([[obj valueForKey:@"gifCategory"] isEqualToString:@"Awesome"]) {
						[self.urlHolderArray addObject:[obj valueForKey:@"gifURL"]];
					}
				}
			}];
			[self loadGify];
		}
		else {
			tempArray = [[self.fetchedResultsController fetchedObjects] valueForKey:@"gifURL"];
			self.urlHolderArray = [tempArray mutableCopy];
			[self loadGify];
		}
	}
}

- (void)loadGify {
	[self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
	//	self.collectionFlowLayout.itemSize = CGSizeMake(self.collectionView.layer.frame.size.width / 2.015, self.collectionView.layer.frame.size.height / 2.015);
	if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)) {
		//DO Portrait
		self.collectionViewSize = CGSizeMake(self.collectionView.layer.frame.size.width / 2.015, self.collectionView.layer.frame.size.height / 2.015);
	}
	else {
		//DO Landscape
		self.collectionViewSize = CGSizeMake(self.collectionView.layer.frame.size.width / 4.015, self.collectionView.layer.frame.size.height);
	}

	for (int i = 0; i < self.urlHolderArray.count; ++i) {

		[self setupGifImageView];
	}
	[self.urlHolderArray enumerateObjectsUsingBlock:^(NSString *urlString, NSUInteger _idx, BOOL *_stop) {
		dispatch_async(dispatch_get_main_queue(), ^{

			self.numberOfGifs = self.urlHolderArray.count;
			[self.collectionView reloadData];
//			[self.collectionView.collectionViewLayout invalidateLayout];

			if (_idx == self.urlHolderArray.count - 1) {

				[self loadGifPage:0];
				[self loadGifPage:1];
				[self loadGifPage:2];
				[self loadGifPage:3];
			}
		});
	}];
}

- (void)setupGifImageView {
	FLAnimatedImageView *imageView = [FLAnimatedImageView new];
	imageView.translatesAutoresizingMaskIntoConstraints = NO;
	imageView.contentMode = UIViewContentModeScaleToFill;
	imageView.clipsToBounds = YES;
	imageView.backgroundColor = [UIColor blackColor];
	[self.gifHolderArray addObject:imageView];
}

- (void)loadGifPage:(NSUInteger)page {
	if (page < self.urlHolderArray.count) {

		FLAnimatedImageView *imageView = self.gifHolderArray[page];
		UIActivityIndicatorView *activityIndicatorTemp = [[UIActivityIndicatorView new] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[imageView addSubview:activityIndicatorTemp];
		activityIndicatorTemp.center = imageView.center;
		[activityIndicatorTemp startAnimating];

		[imageView downloadURLWithString:self.urlHolderArray[page] callback:^(FLAnimatedImage *image) {
			[activityIndicatorTemp stopAnimating];
			imageView.animatedImage = image;
		}];
	}
}
//	- (void)loadGifPage:(NSUInteger)page
//{
//	if (page < self.urlHolderArray.count)
//	{
////		__block UIActivityIndicatorView *activityIndicatorTemp = [[UIActivityIndicatorView new] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//		FLAnimatedImageView *animatedImageView = self.gifHolderArray[page];
////		CGPoint centerImageView = imageView.center;
////		[animatedImageView addSubview:activityIndicatorTemp];
////		activityIndicatorTemp.center = imageView.center;
////		[activityIndicatorTemp startAnimating];
//
//		[animatedImageView downloadURLString:self.urlHolderArray[page] callback:^(FLAnimatedImageView *imageView)
//		{
////			[activityIndicatorTemp stopAnimating];
//			animatedImageView.animatedImage = imageView.animatedImage;
//		}];
//	}
//}

#pragma mark - CollectionView Delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.numberOfGifs;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return self.collectionViewSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
	tapGestureRecognizer.delegate = self;
	tapGestureRecognizer.delaysTouchesBegan = YES;
	[self.collectionView addGestureRecognizer:tapGestureRecognizer];

	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];//    FLAnimatedImageView *imageView = self.imageObjects[indexPath.row];

	[cell setBackgroundView:self.gifHolderArray[indexPath.row]];
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark Touch Gestures

- (void)check3Dtouch {
	// register for 3D Touch (if available)
	if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {

		[self registerForPreviewingWithDelegate:(id) self sourceView:self.view];
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
	NSString *gifUrl = [NSString stringWithFormat:@"%@", self.urlHolderArray[indexPath.row]];
	NSURL *url = [[NSURL alloc] initWithString:self.urlHolderArray[indexPath.row]];
	NSData *data = [NSData dataWithContentsOfURL:url];
	[[UIPasteboard generalPasteboard] setData:data forPasteboardType:(NSString *) kUTTypeGIF];
	[self.textDocumentProxy insertText:gifUrl];
	[self loadMessage:@"URL Copied!"];

}

- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender {
	if ([sender isEqual:self.lpgr]) {

		if (sender.state == UIGestureRecognizerStateBegan) {

			self.buttonView = [[KeyboardButtonView alloc] initWithFrame:self.view.frame];
			self.buttonView.translatesAutoresizingMaskIntoConstraints = NO;
			[self.view addSubview:self.buttonView];

			self.buttonView.gifUrl = self.urlHolderArray[(NSUInteger) self.longPressIndex.row];

			NSDictionary *views = @{@"buttonView" : self.buttonView};

			[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[buttonView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
			[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[buttonView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

//
			CGPoint p = [sender locationInView:self.collectionView];

			NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
			if (indexPath == nil) {
				NSLog(@"couldn't find index path");
			}
			else {

				self.longPressIndex = indexPath;
			}
		}

	}
}

#pragma mark ScrollView

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	CGFloat pageWidth = scrollView.frame.size.width;
	float fractionalPage = scrollView.contentOffset.x / pageWidth;
	NSUInteger page = (NSUInteger) lround(fractionalPage);
	NSUInteger pageNumber = page * 4;

	for (NSInteger i = 0; i < 8; ++i) {

		[self loadGifPage:pageNumber + i];
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

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated
}

- (void)closeSubview:(NSNotification *)notification {
	NSDictionary* userInfo = notification.userInfo;

	[self loadMessage:userInfo[@"iconPressed"]];
//	[self.collectionView.collectionViewLayout invalidateLayout];

//    [self.buttonView removeFromSuperview];

}

#pragma mark rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.collectionView setAlpha:0.0f];
	[self.collectionView.collectionViewLayout invalidateLayout];
	CGPoint currentOffset = [self.collectionView contentOffset];
	self.currentIndex = currentOffset.x / self.collectionView.frame.size.width;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
	[self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
	[UIView animateWithDuration:0.125f animations:^{
		[self.collectionView setAlpha:1.0f];
	}];
}
@end
