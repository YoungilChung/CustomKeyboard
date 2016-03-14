//
//  ShareViewController.m
//  MMShareExtension
//
//  Created by mm0030240 on 06/10/15.
//  Copyright © 2015 mm0030240. All rights reserved.
//

#import "ShareViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreData/CoreData.h>
#import "CoreDataStack.h"
#import "GIFEntity.h"
#import "PopUpShareViewController.h"

@interface ShareViewController () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionFlowLayout;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *urlHolderArray;
@property (nonatomic, strong) NSMutableArray *imageObjects;
@property (nonatomic, strong) PopUpShareViewController *popUpShareViewController;
@property (nonatomic) NSInteger collectionAmount;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSInteger currentImageIndex;
@property (nonatomic, strong) FLAnimatedImageView *animatedImageView;
@property (nonatomic, strong) GIFEntity *gifEntity;


@end

@implementation ShareViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
	[super viewDidLoad];
	[self registerForPreviewingWithDelegate:(id) self sourceView:self.view]; // TODO


	UIView *holder = [UIView new];
	holder.translatesAutoresizingMaskIntoConstraints = NO;
	holder.backgroundColor = [UIColor blackColor];
	holder.layer.cornerRadius = 10;
	[self.view addSubview:holder];

	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
	cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
	[cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[cancelButton setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
	[cancelButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
	[cancelButton addTarget:self action:@selector(onCancelTapped:) forControlEvents:UIControlEventTouchUpInside];
	[holder addSubview:cancelButton];

	self.titleLabel = [UILabel new];
	self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	self.titleLabel.textColor = [UIColor whiteColor];
	[self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
	[self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	self.titleLabel.textAlignment = NSTextAlignmentCenter;
	self.titleLabel.text = @"0";
	[holder addSubview:self.titleLabel];

	//Collection View
	self.collectionFlowLayout = [UICollectionViewFlowLayout new];
	[self.collectionFlowLayout setMinimumInteritemSpacing:0.0f];
	[self.collectionFlowLayout setMinimumLineSpacing:0.0f];
	[self.collectionFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
	self.collectionView = [[UICollectionView alloc] initWithFrame:holder.frame collectionViewLayout:self.collectionFlowLayout];
	self.collectionAmount = 0;
	[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
	self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	self.collectionView.pagingEnabled = YES;
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	[holder addSubview:self.collectionView];

	UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
	shareButton.translatesAutoresizingMaskIntoConstraints = NO;
	[shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[shareButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[shareButton setTitle:@"Normal" forState:UIControlStateNormal];
	[shareButton addTarget:self action:@selector(onShareOneTapped:) forControlEvents:UIControlEventTouchUpInside];
	[holder addSubview:shareButton];

	UIButton *shareButton2 = [UIButton buttonWithType:UIButtonTypeSystem];
	shareButton2.translatesAutoresizingMaskIntoConstraints = NO;
	[shareButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[shareButton2 setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[shareButton2 setTitle:@"Awesome!" forState:UIControlStateNormal];
	[shareButton2 addTarget:self action:@selector(onShareTwoTapped:) forControlEvents:UIControlEventTouchUpInside];
	[holder addSubview:shareButton2];

	self.spinner = [[UIActivityIndicatorView new] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	self.spinner.translatesAutoresizingMaskIntoConstraints = NO;
	[holder addSubview:self.spinner];

	NSDictionary *views = @{@"holder" : holder, @"cancelBtn" : cancelButton, @"title" : self.titleLabel, @"collection" : self.collectionView,
			@"shareBtn1" : shareButton, @"shareBtn2" : shareButton2, @"spinner" : self.spinner};
	NSDictionary *metrics = @{@"padding" : @(10)};

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-36-[holder]-36-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:holder attribute:NSLayoutAttributeCenterY
	                                                      relatedBy:NSLayoutRelationEqual
	                                                         toItem:self.view attribute:NSLayoutAttributeCenterY
	                                                     multiplier:1.0 constant:0]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:holder attribute:NSLayoutAttributeHeight
	                                                      relatedBy:NSLayoutRelationEqual
	                                                         toItem:nil attribute:NSLayoutAttributeNotAnAttribute
	                                                     multiplier:1.0 constant:300]];

	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-36-[spinner]-36-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	[holder addConstraint:[NSLayoutConstraint constraintWithItem:self.spinner attribute:NSLayoutAttributeCenterY
	                                                   relatedBy:NSLayoutRelationEqual
	                                                      toItem:holder attribute:NSLayoutAttributeCenterY
	                                                  multiplier:1.0 constant:0]];

	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[cancelBtn]-0-[collection]-0-[shareBtn1]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[title]-0-[collection]-0-[shareBtn1]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[cancelBtn]-0-[collection]-0-[shareBtn2]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[title]-0-[collection]-0-[shareBtn2]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[cancelBtn]-(>=0)-[title]-(>=0)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holder addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterX
	                                                   relatedBy:NSLayoutRelationEqual
	                                                      toItem:holder attribute:NSLayoutAttributeCenterX
	                                                  multiplier:1.0 constant:0]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[shareBtn1(==shareBtn2)]-0-[shareBtn2(==shareBtn1)]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[collection]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	self.view.transform = CGAffineTransformMakeTranslation(0, self.view.frame.size.height);

	[UIView animateWithDuration:0.25 animations:^{
		self.view.transform = CGAffineTransformIdentity;
	}];

	[self gifLoader];
}

- (void)updateViewConstraints {
	[super updateViewConstraints];
}

#pragma mark - Actions

- (void)onCancelTapped:(UIButton *)sender {
	[self.extensionContext cancelRequestWithError:[NSError new]];
}

- (void)onShareOneTapped:(UIButton *)sender {
	UIView *holderTemp = [UIView new];
	holderTemp.translatesAutoresizingMaskIntoConstraints = NO;
	holderTemp.backgroundColor = [UIColor blackColor];
	holderTemp.layer.cornerRadius = 10;
	FLAnimatedImageView *tempImage = [FLAnimatedImageView new];
	FLAnimatedImageView *tempImage1 = [FLAnimatedImageView new];
	tempImage1.translatesAutoresizingMaskIntoConstraints = NO;
	UILabel *label = [UILabel new];
	[label setText:@"Normal"];
	[label setTextColor:[UIColor whiteColor]];
	[label setFont:[UIFont systemFontOfSize:36]];
	label.translatesAutoresizingMaskIntoConstraints = NO;

	[tempImage1 downloadURLWithString:self.urlHolderArray[self.currentImageIndex] callback:^(FLAnimatedImage *image) {
		tempImage1.animatedImage = image;
	}];
	[self.view addSubview:holderTemp];
	[holderTemp addSubview:tempImage1];
	[holderTemp addSubview:label];

	NSDictionary *views = @{@"tempImage" : tempImage1, @"holder" : holderTemp, @"label" : label};
	NSDictionary *metrics = @{@"padding" : @(10)};

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-36-[holder]-36-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	NSLayoutConstraint *yConstraint = [NSLayoutConstraint constraintWithItem:holderTemp attribute:NSLayoutAttributeCenterY
	                                                               relatedBy:NSLayoutRelationEqual
	                                                                  toItem:self.view attribute:NSLayoutAttributeCenterY
	                                                              multiplier:1.0 constant:0];
	[self.view addConstraint:yConstraint];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:holderTemp attribute:NSLayoutAttributeHeight
	                                                      relatedBy:NSLayoutRelationEqual
	                                                         toItem:nil attribute:NSLayoutAttributeNotAnAttribute
	                                                     multiplier:1.0 constant:300]];

	[holderTemp addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[tempImage]-20-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holderTemp addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX
	                                                       relatedBy:NSLayoutRelationEqual
	                                                          toItem:holderTemp attribute:NSLayoutAttributeCenterX
	                                                      multiplier:1.0 constant:0]];
	[holderTemp addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[tempImage]-20-[label]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	[holderTemp layoutIfNeeded];

	[self.view removeConstraint:yConstraint];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:holderTemp attribute:NSLayoutAttributeTop
	                                                      relatedBy:NSLayoutRelationEqual
	                                                         toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:holderTemp attribute:NSLayoutAttributeWidth
	                                                      relatedBy:NSLayoutRelationLessThanOrEqual
	                                                         toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0]];

	[UIView animateWithDuration:1.0f delay:0.5f options:0 animations:^{

		holderTemp.alpha = 0.0;
		[holderTemp layoutIfNeeded];
	}                completion:^(BOOL finished) {
		[holderTemp removeFromSuperview];

		CoreDataStack *coreData = [CoreDataStack defaultStack];
		GIFEntity *gifEntity = [NSEntityDescription insertNewObjectForEntityForName:@"GIFEntity" inManagedObjectContext:coreData.managedObjectContext];
		gifEntity.self.gifURL = self.urlHolderArray[self.currentImageIndex];
		gifEntity.self.gifCategory = @"Normal";
		[coreData saveContext];
		[self.urlHolderArray removeObjectAtIndex:self.currentImageIndex];
		[self.imageObjects removeObjectAtIndex:self.currentImageIndex];
		self.collectionAmount = self.urlHolderArray.count;
		[self.collectionView reloadData];
		self.titleLabel.text = [NSString stringWithFormat:@"%lu of %ld Gifs", self.currentImageIndex + 1, (long) self.urlHolderArray.count - 1];
		[self loadGifForPage:self.currentImageIndex];
	}];
}

- (void)onShareTwoTapped:(UIButton *)sender {

	UIView *holderTemp = [UIView new];
	holderTemp.translatesAutoresizingMaskIntoConstraints = NO;
	holderTemp.backgroundColor = [UIColor blackColor];

	FLAnimatedImageView *tempImage = [FLAnimatedImageView new];
	FLAnimatedImageView *tempImage1 = [FLAnimatedImageView new];
	tempImage1.translatesAutoresizingMaskIntoConstraints = NO;
//	tempImage1.image = [UIImage imageNamed:@"greenTick.png"];
	UILabel *label = [UILabel new];
	[label setText:@"Awesome"];
	[label setTextColor:[UIColor whiteColor]];
	[label setFont:[UIFont systemFontOfSize:36]];
	label.translatesAutoresizingMaskIntoConstraints = NO;

	[tempImage1 downloadURLWithString:self.urlHolderArray[self.currentImageIndex] callback:^(FLAnimatedImage *image) {
		tempImage1.animatedImage = image;
	}];
	[self.view addSubview:holderTemp];
	[holderTemp addSubview:tempImage1];
	[holderTemp addSubview:label];

	NSDictionary *views = @{@"tempImage" : tempImage1, @"holder" : holderTemp, @"label" : label};
	NSDictionary *metrics = @{@"padding" : @(10)};

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-36-[holder]-36-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	NSLayoutConstraint *yConstraint = [NSLayoutConstraint constraintWithItem:holderTemp attribute:NSLayoutAttributeCenterY
	                                                               relatedBy:NSLayoutRelationEqual
	                                                                  toItem:self.view attribute:NSLayoutAttributeCenterY
	                                                              multiplier:1.0 constant:0];
	[self.view addConstraint:yConstraint];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:holderTemp attribute:NSLayoutAttributeHeight
	                                                      relatedBy:NSLayoutRelationEqual
	                                                         toItem:nil attribute:NSLayoutAttributeNotAnAttribute
	                                                     multiplier:1.0 constant:300]];

	[holderTemp addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[tempImage]-20-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holderTemp addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX
	                                                       relatedBy:NSLayoutRelationEqual
	                                                          toItem:holderTemp attribute:NSLayoutAttributeCenterX
	                                                      multiplier:1.0 constant:0]];
	[holderTemp addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[tempImage]-20-[label]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	[holderTemp layoutIfNeeded];

	[self.view removeConstraint:yConstraint];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:holderTemp attribute:NSLayoutAttributeTop
	                                                      relatedBy:NSLayoutRelationEqual
	                                                         toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:holderTemp attribute:NSLayoutAttributeWidth
	                                                      relatedBy:NSLayoutRelationLessThanOrEqual
	                                                         toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0]];
	[UIView animateWithDuration:1.0f delay:0.5 options:0 animations:^{
		holderTemp.alpha = 0.0;
		[holderTemp layoutIfNeeded];

	}                completion:^(BOOL finished) {

		CoreDataStack *coreData = [CoreDataStack defaultStack];
		GIFEntity *gifEntity = [NSEntityDescription insertNewObjectForEntityForName:@"GIFEntity" inManagedObjectContext:coreData.managedObjectContext];
		gifEntity.self.gifURL = self.urlHolderArray[self.currentImageIndex];
		gifEntity.self.gifCategory = @"Awesome";
		[coreData saveContext];
		[self.urlHolderArray removeObjectAtIndex:self.currentImageIndex];
		[self.imageObjects removeObjectAtIndex:self.currentImageIndex];
		self.collectionAmount = self.urlHolderArray.count;
		[self.collectionView reloadData];
		self.titleLabel.text = [NSString stringWithFormat:@"%lu of %ld Gifs", self.currentImageIndex + 1, (long) self.urlHolderArray.count - 1];
		[self loadGifForPage:self.currentImageIndex];
		[holderTemp removeFromSuperview];
	}];
}

- (void)onPostTapped:(UIButton *)sender {

	CATransition *animation = [CATransition animation];
	[animation setDuration:1];
	[animation setType:kCATransitionPush];
	[animation setSubtype:kCATransitionFromBottom];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
	animation.delegate = self;
	[[self.collectionView layer] addAnimation:animation forKey:@"SlideOutandInImagek"];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
	//    [self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
	NSMutableArray *tempUrlArray = [NSMutableArray array];
	NSMutableArray *tempImageArray = [NSMutableArray array];
	[theAnimation isRemovedOnCompletion];
	//	[tempUrlArray removeObjectAtIndex:0];
	////    [self.imageObjects removeObjectAtIndex:self.currentImageIndex];
	//    [tempImageArray removeObjectAtIndex:0];
	////    [self.animatedImageView removeFromSuperview];
	//	self.urlHolderArray = tempUrlArray;
	//	self.imageObjects = tempImageArray;
	//	[self.collectionView reloadData];

}

- (void)gifLoader {
	for (NSExtensionItem *extensionItem in self.extensionContext.inputItems) {
		for (NSItemProvider *itemProvider in extensionItem.attachments) {
			NSString *urlType = (NSString *) kUTTypePropertyList;

			if ([itemProvider hasItemConformingToTypeIdentifier:urlType]) {
				[itemProvider loadItemForTypeIdentifier:urlType options:nil completionHandler:^(NSDictionary *item, NSError *error) {
					NSDictionary *urls = item.allValues[0];

					NSMutableArray *tempOrderedUrls = [@[] mutableCopy];

					for (NSUInteger i = 0; i < urls.count; ++i) {
						NSString *urlString = urls[[NSString stringWithFormat:@"%lu", (unsigned long) i]];
						if ([tempOrderedUrls indexOfObject:urlString] == NSNotFound) {
							[tempOrderedUrls addObject:urlString];
						}
					};
					self.urlHolderArray = [tempOrderedUrls mutableCopy];

					self.imageObjects = [@[] mutableCopy];

					[self.urlHolderArray enumerateObjectsUsingBlock:^(NSString *urlString, NSUInteger _idx, BOOL *_stop) {
						dispatch_async(dispatch_get_main_queue(), ^{
							[self setupGifImageView];

							if (_idx == self.urlHolderArray.count - 1) {
								[self loadGifForPage:0];
								[self loadGifForPage:1];
								self.collectionFlowLayout.itemSize = CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
								self.collectionAmount = self.urlHolderArray.count;
								if (self.collectionAmount == 1) {
									self.titleLabel.text = [NSString stringWithFormat:@"1 of %ld Gifs", (long) self.collectionAmount];
								}
								self.titleLabel.text = [NSString stringWithFormat:@"1 of %ld Gifs", (long) self.collectionAmount - 1];
								[self.collectionView reloadData];
							}
						});
					}];
				}];
			}
		}
	}
}

- (void)setupGifImageView {
	FLAnimatedImageView *imageView = [FLAnimatedImageView new];
	imageView.translatesAutoresizingMaskIntoConstraints = NO;
	imageView.contentMode = UIViewContentModeScaleAspectFill;
	imageView.clipsToBounds = YES;
	imageView.backgroundColor = [UIColor blackColor];
	[self.imageObjects addObject:imageView];
}

#pragma mark - ScrollView Delegates

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	CGFloat pageWidth = scrollView.frame.size.width;
	float fractionalPage = scrollView.contentOffset.x / pageWidth;
	NSUInteger page = (NSUInteger) lround(fractionalPage);

	[self loadGifForPage:page];
	[self loadGifForPage:page + 1];
	[self loadGifForPage:page - 1];
	if (self.collectionAmount == 1) {
		self.titleLabel.text = [NSString stringWithFormat:@"%lu of %ld Gifs", page + 1, (long) self.collectionAmount + 1];
	}
	else {
		self.titleLabel.text = [NSString stringWithFormat:@"%lu of %ld Gifs", page + 1, (long) self.collectionAmount - 1];
	}
}

#pragma mark - CollectionView Delegates

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
	[cell setBackgroundView:self.imageObjects[(NSUInteger) indexPath.row]];
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

// Returns the amount of sections in the collection view dependant on how many images there are in the array
- (NSUInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSUInteger)section {
	return (NSUInteger) self.collectionAmount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
	//    FLAnimatedImageView *imageView = self.imageObjects[indexPath.row];
	//	[self loadGifForPage:indexPath.row];
	self.currentImageIndex = indexPath.row;

	[cell setBackgroundView:self.imageObjects[(NSUInteger) indexPath.row]];
	return cell;
}

- (void)loadGifForPage:(NSUInteger)page {

	if (page < self.urlHolderArray.count) {
		[self.spinner startAnimating];
		FLAnimatedImageView *imageView = self.imageObjects[page];

		[imageView downloadURLWithString:self.urlHolderArray[page] callback:^(FLAnimatedImage *image) {
			imageView.animatedImage = image;
			[self.spinner stopAnimating];
		}];
	}
}

#pragma mark Preview Context

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {

	//	if (viewControllerToCommit)
	//	{
	//		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewControllerToCommit];
	//
	//		[self presentViewController:navigationController
	//						   animated:YES
	//						 completion:^
	//						 {
	//						 }];
	[self presentViewController:viewControllerToCommit animated:true completion:nil];
	//						[self showViewController:viewControllerToCommit sender:self];
	//	}
	//	else
	//	{
	//		self.view.hidden = NO;
	//
	//		NSLog(@"Didn't Commit");
	//	}
}

- (UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
	NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:(location)];
	UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:(indexPath)];
	self.popUpShareViewController = [PopUpShareViewController new];
	FLAnimatedImageView *animatedImageView = [FLAnimatedImageView new];
	animatedImageView.translatesAutoresizingMaskIntoConstraints = NO;
	//	animatedImageView = self.imageObjects[self.currentImageIndex];
	[animatedImageView downloadURLWithString:self.urlHolderArray[(NSUInteger) self.currentImageIndex] callback:^(FLAnimatedImage *image) {
		animatedImageView.animatedImage = image;
	}];
	UIButton *closeButton = [UIButton new];
	[closeButton setTitle:@"Close" forState:UIControlStateNormal];
	closeButton.translatesAutoresizingMaskIntoConstraints = NO;
	[closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[closeButton addTarget:self action:@selector(onCloseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	//	[self.popUpShareViewController.view addSubview:closeButton];

	NSURL *url = [[NSURL alloc] initWithString:self.urlHolderArray[(NSUInteger) self.currentImageIndex]];
	self.popUpShareViewController.url = url;
	self.popUpShareViewController.view.backgroundColor = [UIColor blackColor];
	[self.popUpShareViewController.view addSubview:animatedImageView];

	NSDictionary *views = @{@"holder" : animatedImageView, @"closeButton" : closeButton};
	NSDictionary *metrics = @{@"padding" : @(10)};
	[self.popUpShareViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[holder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.popUpShareViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:animatedImageView attribute:NSLayoutAttributeCenterY
	                                                                               relatedBy:NSLayoutRelationEqual
	                                                                                  toItem:self.popUpShareViewController.view attribute:NSLayoutAttributeCenterY
	                                                                              multiplier:1.0 constant:0]];
	[self.popUpShareViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:animatedImageView attribute:NSLayoutAttributeHeight
	                                                                               relatedBy:NSLayoutRelationEqual
	                                                                                  toItem:nil attribute:NSLayoutAttributeNotAnAttribute
	                                                                              multiplier:1.0 constant:300]];

	previewingContext.sourceRect = animatedImageView.frame;
	return self.popUpShareViewController;
}

- (void)onCloseButtonPressed:(UIButton *)sender {
	[self.popUpShareViewController dismissViewControllerAnimated:self.accessibilityElementsHidden completion:^{
	}];
}

#pragma mark Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.collectionView setAlpha:0.0f];
	[self.collectionView.collectionViewLayout invalidateLayout];
	CGPoint currentOffset = [self.collectionView contentOffset];
	self.currentIndex = (NSInteger) (currentOffset.x / self.collectionView.frame.size.width);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return self.collectionView.frame.size;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
	[self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
	[UIView animateWithDuration:0.125f animations:^{
		[self.collectionView setAlpha:1.0f];
	}];
}
@end
