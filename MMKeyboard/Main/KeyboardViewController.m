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
#import <MessageUI/MessageUI.h>

@interface KeyboardViewController () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate,
		UIViewControllerPreviewingDelegate, UIGestureRecognizerDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionFlowLayout;
@property (nonatomic, strong) UIView *holderView;
@property (nonatomic, strong) NSMutableArray *gifHolderArray;
@property (nonatomic, strong) NSMutableArray *urlHolderArray;
@property (nonatomic) NSUInteger numberOfGifs;
@property (nonatomic) NSString *searchKey;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSString *gifCategory;
@property (nonatomic, strong) NSIndexPath *longPressIndex;
@property (nonatomic, strong) UIButton *shareOneButton;
@property (nonatomic, strong) UIButton *shareTwoButton;
@property (nonatomic, strong) UIButton *allGifsButton;
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@property (nonatomic, strong) UIScrollView *keyboardBackground;
@property (nonatomic, strong) UILabel *messageText;
@property (nonatomic) CGSize collectionViewSize;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) UILongPressGestureRecognizer *lpgr;


@end

@implementation KeyboardViewController

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
	//	[keyboardImage addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[nxtKeyboardBtn]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	//	[keyboardImage addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[nxtKeyboardBtn]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];


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

- (void)onUrlTapped:(UIButton *)sender {
	[self loadMessage:@"URL Copied!"];
	NSURL *url = [[NSURL alloc] initWithString:self.urlHolderArray[self.longPressIndex.row]];
	[[UIPasteboard generalPasteboard] setURL:url];
	[self.holderView removeFromSuperview];
	[self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)onGifTapped:(UIButton *)sender {
	[self loadMessage:@"GIF Copied!"];
	NSURL *url = [[NSURL alloc] initWithString:self.urlHolderArray[self.longPressIndex.row]];
	NSData *data = [NSData dataWithContentsOfURL:url];
	[[UIPasteboard generalPasteboard] setData:data forPasteboardType:(NSString *) kUTTypeGIF];
	[self.holderView removeFromSuperview];
}

- (void)onMessengerTapped:(UIButton *)sender {
	//	[self loadMessage:@"URL Copied!"];
	NSURL *url = [[NSURL alloc] initWithString:self.urlHolderArray[self.longPressIndex.row]];
	[[UIPasteboard generalPasteboard] setURL:url];
	NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"hipchat://send?text=%@", self.urlHolderArray[self.longPressIndex.row]]];
	[self toApp:whatsappURL];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)onFacebookTapped:(UIButton *)sender {

	//	[self loadMessage:@"GIF Copied!"];
	NSURL *url = [[NSURL alloc] initWithString:self.urlHolderArray[self.longPressIndex.row]];
	NSData *data = [NSData dataWithContentsOfURL:url];
	[[UIPasteboard generalPasteboard] setData:data forPasteboardType:(NSString *) kUTTypeGIF];
	NSURL *facebookURL = [NSURL URLWithString:@"fb-messenger://compose"];
	//    NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"fb-messenger://share?ShareType.forward&attachment=%@", self.urlHolderArray[self.longPressIndex.row]]];
	[self toApp:facebookURL];
}

- (void)onWhatsAppTapped:(UIButton *)sender {
	NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@", self.urlHolderArray[self.longPressIndex.row]]];
	[self toApp:whatsappURL];
}

- (void)toApp:(NSURL *)url {
	UIResponder *responder = self;
	while ((responder = [responder nextResponder]) != nil) {
		//		if ([responder respondsToSelector:@selector(openURL)])
		if ([responder respondsToSelector:@selector(openURL:)] == YES) {
			[self loadMessage:@"GIF saved to pasteboard!"];
			[responder performSelector:@selector(openURL:) withObject:url];
		}
	}
}

- (void)onCloseTapped:(UIButton *)sender {
	[self.holderView removeFromSuperview];
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

	[UIView animateWithDuration:0.2f delay:1.5f options:0 animations:^{
		view.alpha = 0.0;

		//		tempImage.frame = CGRectMake(0,300, holderTemp.frame.size.width,holderTemp.frame.size.height);
		//		holderTemp.center = offs;
		//		CGFloat newCenterX = holderTemp.center.x + self.view.bounds.size.height;
		//		holderTemp.center = CGPointMake(holderTemp.center.x, newCenterX);
	}                completion:^(BOOL finished) {
		[view removeFromSuperview];
		//		[self loadGif];

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
			[self.collectionView.collectionViewLayout invalidateLayout];

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

			self.holderView = [UIView new];
			self.holderView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
			self.holderView.translatesAutoresizingMaskIntoConstraints = NO;
			[self.view addSubview:self.holderView];

			UIView *topHolderView = [UIView new];
			topHolderView.backgroundColor = [UIColor clearColor];
			topHolderView.translatesAutoresizingMaskIntoConstraints = NO;

			[self.holderView addSubview:topHolderView];

			UIView *bottomHolderView = [UIView new];
			bottomHolderView.backgroundColor = [UIColor clearColor];
			bottomHolderView.translatesAutoresizingMaskIntoConstraints = NO;

			[self.holderView addSubview:bottomHolderView];

			UIView *hipChatView = [UIView new];
			hipChatView.translatesAutoresizingMaskIntoConstraints = NO;
			[hipChatView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
			[topHolderView addSubview:hipChatView];

			UIImageView *hipchatImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hipchat-logo"]];
			hipchatImageView.translatesAutoresizingMaskIntoConstraints = NO;
			[hipchatImageView setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisVertical];
			hipchatImageView.contentMode = UIViewContentModeScaleAspectFit;
			[hipChatView addSubview:hipchatImageView];

			UILabel *hipChatLabel = [UILabel new];
			hipChatLabel.translatesAutoresizingMaskIntoConstraints = NO;
			[hipChatLabel setTextColor:[UIColor whiteColor]];
			[hipChatLabel setText:@"HipChat"];
			[hipChatView addSubview:hipChatLabel];

			UIButton *hipChatButton = [UIButton buttonWithType:UIButtonTypeCustom];
			hipChatButton.translatesAutoresizingMaskIntoConstraints = NO;
			[hipChatButton addTarget:self action:@selector(onMessengerTapped:) forControlEvents:UIControlEventTouchUpInside];
			[hipChatView addSubview:hipChatButton];

			UIView *facebookView = [UIView new];
			facebookView.translatesAutoresizingMaskIntoConstraints = NO;
			//			facebookView.layer.borderWidth = 2.0f;
			//			facebookView.layer.borderColor = [UIColor greenColor].CGColor;
			[facebookView setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisVertical];
			[facebookView setContentCompressionResistancePriority:0 forAxis:UILayoutConstraintAxisVertical];
			[topHolderView addSubview:facebookView];

			UIImageView *facebookImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unnamed"]];
			facebookImageView.translatesAutoresizingMaskIntoConstraints = NO;
			//			[facebookImageView setContentHuggingPriority:0 forAxis:UILayoutConstraintAxisVertical];
			[facebookImageView setContentCompressionResistancePriority:250 forAxis:UILayoutConstraintAxisVertical];
			facebookImageView.contentMode = UIViewContentModeScaleAspectFit;
			[facebookView addSubview:facebookImageView];

			UILabel *facebookLabel = [UILabel new];
			facebookLabel.translatesAutoresizingMaskIntoConstraints = NO;
			[facebookLabel setTextColor:[UIColor whiteColor]];
			//			[facebookLabel setContentCompressionResistancePriority:250 forAxis:UILayoutConstraintAxisVertical];
			[facebookLabel setText:@"Messenger"];
			[facebookView addSubview:facebookLabel];

			UIButton *facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
			facebookButton.translatesAutoresizingMaskIntoConstraints = NO;
			[facebookButton addTarget:self action:@selector(onFacebookTapped:) forControlEvents:UIControlEventTouchUpInside];
			[facebookView addSubview:facebookButton];

			UIView *whatsAppView = [UIView new];
			whatsAppView.translatesAutoresizingMaskIntoConstraints = NO;
			whatsAppView.translatesAutoresizingMaskIntoConstraints = NO;
			[whatsAppView setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisVertical];
			[whatsAppView setContentCompressionResistancePriority:0 forAxis:UILayoutConstraintAxisVertical];
			[topHolderView addSubview:whatsAppView];

			UIImageView *whatsAppImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"whatsapp_logo"]];
			whatsAppImageView.translatesAutoresizingMaskIntoConstraints = NO;
			[whatsAppImageView setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
			whatsAppImageView.contentMode = UIViewContentModeScaleAspectFit;
			[whatsAppView addSubview:whatsAppImageView];

			UILabel *whatsAppLabel = [UILabel new];
			whatsAppLabel.translatesAutoresizingMaskIntoConstraints = NO;
			[whatsAppLabel setTextColor:[UIColor whiteColor]];
			[whatsAppLabel setText:@"WhatsApp"];
			[whatsAppView addSubview:whatsAppLabel];

			UIButton *whatsAppButton = [UIButton buttonWithType:UIButtonTypeCustom];
			whatsAppButton.translatesAutoresizingMaskIntoConstraints = NO;
			[whatsAppButton addTarget:self action:@selector(onWhatsAppTapped:) forControlEvents:UIControlEventTouchUpInside];
			[whatsAppView addSubview:whatsAppButton];

			UIButton *closeViewButton = [UIButton new];
			closeViewButton.translatesAutoresizingMaskIntoConstraints = NO;
			[closeViewButton setTitle:@"Delete GIF" forState:UIControlStateNormal];
			[closeViewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
			[closeViewButton addTarget:self action:@selector(onCloseTapped:) forControlEvents:UIControlEventTouchUpInside];
			[bottomHolderView addSubview:closeViewButton];

			UIButton *sendGifButton = [UIButton new];
			sendGifButton.translatesAutoresizingMaskIntoConstraints = NO;
			[sendGifButton setTitle:@"Save GIF" forState:UIControlStateNormal];
			[sendGifButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
			[sendGifButton addTarget:self action:@selector(onGifTapped:) forControlEvents:UIControlEventTouchUpInside];
			[bottomHolderView addSubview:sendGifButton];

			UIButton *sendUrlButton = [UIButton new];
			sendUrlButton.translatesAutoresizingMaskIntoConstraints = NO;
			[sendUrlButton setTitle:@"Save URL" forState:UIControlStateNormal];
			[sendUrlButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
			[sendUrlButton addTarget:self action:@selector(onUrlTapped:) forControlEvents:UIControlEventTouchUpInside];
			[bottomHolderView addSubview:sendUrlButton];

			NSDictionary *views = @{@"holder" : self.holderView, @"topHolder" : topHolderView, @"bottomHolder" : bottomHolderView, @"close" : closeViewButton, @"sendGif" : sendGifButton,
					@"sendUrl" : sendUrlButton, @"facebookLabel" : facebookLabel, @"whatsAppLabel" : whatsAppLabel, @"hipChatLabel" : hipChatLabel, @"hipChat" : hipchatImageView,
					@"facebook" : facebookImageView, @"whatsApp" : whatsAppImageView, @"whatsAppView" : whatsAppView, @"hipChatView" : hipChatView, @"facebookView" : facebookView,
					@"hipChatButton" : hipChatButton, @"facebookButton" : facebookButton, @"whatsAppButton" : whatsAppButton
			};
			NSDictionary *metrics = @{@"padding" : @(10)};

			[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[holder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
			[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[holder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
			[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.holderView attribute:NSLayoutAttributeHeight
			                                                      relatedBy:NSLayoutRelationEqual
			                                                         toItem:self.view attribute:NSLayoutAttributeHeight
			                                                     multiplier:1.0 constant:0]];
			[self.holderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[topHolder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
			[self.holderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bottomHolder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
			[self.holderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[topHolder(==bottomHolder)]-0-[bottomHolder(==topHolder)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
			[topHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[hipChatView(==whatsAppView)]-5-[facebookView(==whatsAppView)]-5-[whatsAppView(==hipChatView)]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

			[whatsAppView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[whatsApp]-0-[whatsAppLabel]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
			[whatsAppView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[whatsApp]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

			[facebookView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[facebook]-0-[facebookLabel]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
			[facebookView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[facebook]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

			[hipChatView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[hipChat]-0-[hipChatLabel]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
			[hipChatView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[hipChat]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
			[hipChatView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[hipChatButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
			[hipChatView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[hipChatButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
			[facebookView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[facebookButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
			[facebookView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[facebookButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
			[whatsAppView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[whatsAppButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
			[whatsAppView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[whatsAppButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
			//			[hipChatView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[hipChatLabel]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
			//			[topHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[messenger]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
			//			[topHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[facebook]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
			//			[topHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[whatsApp]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
			//			NSLog(@"BottomHolder %f", bottomHolderView.frame.size.height);

			//			[topHolderView addConstraint:[NSLayoutConstraint constraintWithItem:hipchatImageView attribute:NSLayoutAttributeWidth
			//																	  relatedBy:NSLayoutRelationEqual
			//																		 toItem:hipchatImageView attribute:NSLayoutAttributeHeight
			//																	 multiplier:1.0 constant:0.0]];

			[topHolderView addConstraint:[NSLayoutConstraint constraintWithItem:hipChatView attribute:NSLayoutAttributeCenterY
			                                                          relatedBy:NSLayoutRelationEqual
			                                                             toItem:topHolderView attribute:NSLayoutAttributeCenterY
			                                                         multiplier:1.0 constant:10]];
			[topHolderView addConstraint:[NSLayoutConstraint constraintWithItem:hipchatImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:70]];

			[hipChatView addConstraint:[NSLayoutConstraint constraintWithItem:hipChatLabel
			                                                        attribute:NSLayoutAttributeCenterX
			                                                        relatedBy:NSLayoutRelationEqual
			                                                           toItem:hipchatImageView attribute:NSLayoutAttributeCenterX
			                                                       multiplier:1.0 constant:0]];

			[topHolderView addConstraint:[NSLayoutConstraint constraintWithItem:facebookView attribute:NSLayoutAttributeCenterY
			                                                          relatedBy:NSLayoutRelationEqual
			                                                             toItem:topHolderView attribute:NSLayoutAttributeCenterY
			                                                         multiplier:1.0 constant:10]];
			[topHolderView addConstraint:[NSLayoutConstraint constraintWithItem:facebookImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:70]];


			[facebookView addConstraint:[NSLayoutConstraint constraintWithItem:facebookLabel attribute:NSLayoutAttributeCenterX
			                                                         relatedBy:NSLayoutRelationEqual
			                                                            toItem:facebookImageView attribute:NSLayoutAttributeCenterX
			                                                        multiplier:1.0 constant:0]];
			[topHolderView addConstraint:[NSLayoutConstraint constraintWithItem:whatsAppView attribute:NSLayoutAttributeCenterY
			                                                          relatedBy:NSLayoutRelationEqual
			                                                             toItem:topHolderView attribute:NSLayoutAttributeCenterY
			                                                         multiplier:1.0 constant:10]];
			[topHolderView addConstraint:[NSLayoutConstraint constraintWithItem:whatsAppImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:70]];

			[whatsAppView addConstraint:[NSLayoutConstraint constraintWithItem:whatsAppLabel attribute:NSLayoutAttributeCenterX
			                                                         relatedBy:NSLayoutRelationEqual
			                                                            toItem:whatsAppImageView attribute:NSLayoutAttributeCenterX
			                                                        multiplier:1.0 constant:0]];

			[bottomHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[sendGif(==close)]-0-[sendUrl(==close)]-0-[close(==sendGif)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

			[bottomHolderView addConstraint:[NSLayoutConstraint constraintWithItem:sendGifButton attribute:NSLayoutAttributeCenterY
			                                                             relatedBy:NSLayoutRelationEqual
			                                                                toItem:bottomHolderView attribute:NSLayoutAttributeCenterY
			                                                            multiplier:1.0 constant:0]];

			[bottomHolderView addConstraint:[NSLayoutConstraint constraintWithItem:sendUrlButton attribute:NSLayoutAttributeCenterY
			                                                             relatedBy:NSLayoutRelationEqual
			                                                                toItem:bottomHolderView attribute:NSLayoutAttributeCenterY
			                                                            multiplier:1.0 constant:0]];

			[bottomHolderView addConstraint:[NSLayoutConstraint constraintWithItem:closeViewButton attribute:NSLayoutAttributeCenterY
			                                                             relatedBy:NSLayoutRelationEqual
			                                                                toItem:bottomHolderView attribute:NSLayoutAttributeCenterY
			                                                            multiplier:1.0 constant:0]];

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


//
//#pragma mark Rotation
//

//-(void)viewWillLayoutSubviews
//{
//
//
//    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
//        //DO Portrait
//        //		[self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
//        		self.collectionViewSize = CGSizeMake(self.collectionView.layer.frame.size.width / 2.015, self.collectionView.layer.frame.size.height / 2.015 );
//                [self.collectionView.collectionViewLayout invalidateLayout];
//    }else{
//        //DO Landscape
//        //		[self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
//        		self.collectionViewSize = CGSizeMake(self.collectionView.layer.frame.size.width / 4, self.collectionView.layer.frame.size.height);
//        //		[self.collectionView.collectionViewLayout invalidateLayout];
//        
//    }
//
//}
//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
////	self.collectionViewSize = CGSizeMake(self.collectionView.layer.frame.size.width , self.collectionView.layer.frame.size.height );
////    [self.collectionView.collectionViewLayout invalidateLayout];
//	if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
//		//DO Portrait
////		[self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
//		self.collectionViewSize = CGSizeMake(self.collectionView.layer.frame.size.width / 2.015, self.collectionView.layer.frame.size.height / 2.015);
//        [self.collectionView.collectionViewLayout invalidateLayout];
//	}else{
//		//DO Landscape
////		[self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
//		self.collectionViewSize = CGSizeMake(self.collectionView.layer.frame.size.width / 4.015, self.collectionView.layer.frame.size.height);
//		[self.collectionView.collectionViewLayout invalidateLayout];
//
//	}
//}
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
