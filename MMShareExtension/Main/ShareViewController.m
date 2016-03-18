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
#import "ShareCollectionView.h"

@interface ShareViewController () <UIViewControllerPreviewingDelegate>


// Views
@property(nonatomic, strong) UICollectionViewFlowLayout *collectionFlowLayout;
@property(nonatomic, strong) PopUpShareViewController *popUpShareViewController;
@property(nonatomic, strong) FLAnimatedImageView *animatedImageView;

@property(nonatomic, strong) ShareCollectionView *collectionView;


// Variables
@property(nonatomic, strong) NSMutableArray *urlHolderArray;
@property(nonatomic, strong) NSMutableArray *imageObjects;
@property(nonatomic, strong) GIFEntity *gifEntity;


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
	[holder addSubview:self.titleLabel];

	//Collection View
	self.collectionView = [[ShareCollectionView alloc] initWithPresentingViewController:self];
	self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	[holder addSubview:self.collectionView];


	UIButton *normalButton = [UIButton buttonWithType:UIButtonTypeSystem];
	normalButton.translatesAutoresizingMaskIntoConstraints = NO;
	[normalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[normalButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[normalButton setTitle:@"Normal" forState:UIControlStateNormal];
	[normalButton addTarget:self action:@selector(normalButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[holder addSubview:normalButton];

	UIButton *awesomeButton = [UIButton buttonWithType:UIButtonTypeSystem];
	awesomeButton.translatesAutoresizingMaskIntoConstraints = NO;
	[awesomeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[awesomeButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[awesomeButton setTitle:@"Awesome!" forState:UIControlStateNormal];
	[awesomeButton addTarget:self action:@selector(onAwesomeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[holder addSubview:awesomeButton];


	NSDictionary *views = @{@"holder" : holder, @"cancelBtn" : cancelButton, @"title" : self.titleLabel, @"collection" : self.collectionView,
			@"shareBtn1" : normalButton, @"shareBtn2" : awesomeButton};
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


	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[cancelBtn]-5-[collection]-5-[shareBtn1]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[title]-5-[collection]-5-[shareBtn1]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[cancelBtn]-5-[collection]-5-[shareBtn2]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[title]-5-[collection]-5-[shareBtn2]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[cancelBtn]-(>=0)-[title]-(>=0)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holder addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterX
													   relatedBy:NSLayoutRelationEqual
														  toItem:holder attribute:NSLayoutAttributeCenterX
													  multiplier:1.0 constant:0]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[shareBtn1(==shareBtn2)]-0-[shareBtn2(==shareBtn1)]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[collection]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
}
//
//- (void)viewWillAppear:(BOOL)animated {
//	[super viewWillAppear:animated];
//
//	self.view.transform = CGAffineTransformMakeTranslation(0, self.view.frame.size.height);
//
//	[UIView animateWithDuration:0.25 animations:^{
//		self.view.transform = CGAffineTransformIdentity;
//	}];
//
////	[self gifLoader];
//}
//
//- (void)updateViewConstraints {
//	[super updateViewConstraints];
//}

#pragma mark - Actions

- (void)onCancelTapped:(UIButton *)sender {
	[self.extensionContext cancelRequestWithError:[NSError new]];
}

//}
//
- (void)normalButtonTapped:(UIButton *)sender {
	[self.collectionView normalButtonPressed];
	[self animateViewWithType:@"Normal"];
}

- (void)onAwesomeButtonTapped:(UIButton *)sender {
	[self.collectionView awesomeButtonPressed];
	[self animateViewWithType:@"Awesome"];


}
//
//- (void)onPostTapped:(UIButton *)sender {
//
//	CATransition *animation = [CATransition animation];
//	[animation setDuration:1];
//	[animation setType:kCATransitionPush];
//	[animation setSubtype:kCATransitionFromBottom];
//	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
//	animation.delegate = self;
//	[[self.collectionView layer] addAnimation:animation forKey:@"SlideOutandInImagek"];
//}

//- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
//	//    [self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
//	NSMutableArray *tempUrlArray = [NSMutableArray array];
//	NSMutableArray *tempImageArray = [NSMutableArray array];
//	[theAnimation isRemovedOnCompletion];
//	//	[tempUrlArray removeObjectAtIndex:0];
//	////    [self.imageObjects removeObjectAtIndex:self.currentImageIndex];
//	//    [tempImageArray removeObjectAtIndex:0];
//	////    [self.animatedImageView removeFromSuperview];
//	//	self.urlHolderArray = tempUrlArray;
//	//	self.imageObjects = tempImageArray;
//	//	[self.collectionView reloadData];
//
//}


#pragma mark Animation

- (void)animateViewWithType:(NSString *)type {


	UIView *holderTemp = [UIView new];
	holderTemp.translatesAutoresizingMaskIntoConstraints = NO;
	holderTemp.backgroundColor = [UIColor blackColor];

	self.animatedImageView = [FLAnimatedImageView new];
	self.animatedImageView.translatesAutoresizingMaskIntoConstraints = NO;
//	tempImage1.image = [UIImage imageNamed:@"greenTick.png"];
	UILabel *label = [UILabel new];
	[label setText:type];
	[label setTextColor:[UIColor whiteColor]];
	[label setFont:[UIFont systemFontOfSize:36]];
	label.translatesAutoresizingMaskIntoConstraints = NO;

	[self.animatedImageView downloadURLWithString:self.gifURL callback:^(FLAnimatedImage *image) {
		self.animatedImageView.animatedImage = image;
	}];
	[self.view addSubview:holderTemp];
	[holderTemp addSubview:self.animatedImageView];
	[holderTemp addSubview:label];

	NSDictionary *views = @{@"tempImage" : self.animatedImageView, @"holder" : holderTemp, @"label" : label};
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
		gifEntity.self.gifURL = self.gifURL;
		gifEntity.self.gifCategory = type;
		[coreData saveContext];

		[self.collectionView.data removeObjectAtIndex:(NSUInteger) self.gifIndex.row];

//		self.titleLabel.text = [NSString stringWithFormat:@"%lu of %ld Gifs", self.currentImageIndex + 1, (long) self.urlHolderArray.count - 1];

	}];
	[self.collectionView.collectionView reloadData];


}


#pragma mark Preview Context

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {

	[self presentViewController:viewControllerToCommit animated:true completion:nil];

}

- (UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {

	self.popUpShareViewController = [PopUpShareViewController new];

	self.animatedImageView = [FLAnimatedImageView new];
	self.animatedImageView.translatesAutoresizingMaskIntoConstraints = NO;
	[self setData:self.gifURL];
	//	animatedImageView = self.imageObjects[self.currentImageIndex];


	UIButton *closeButton = [UIButton new];
	[closeButton setTitle:@"Close" forState:UIControlStateNormal];
	closeButton.translatesAutoresizingMaskIntoConstraints = NO;
	[closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[closeButton addTarget:self action:@selector(onCloseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	//	[self.popUpShareViewController.view addSubview:closeButton];

	NSURL *url = [[NSURL alloc] initWithString:self.gifURL];
	self.popUpShareViewController.url = url;
	self.popUpShareViewController.view.backgroundColor = [UIColor blackColor];
	[self.popUpShareViewController.view addSubview:self.animatedImageView];

	NSDictionary *views = @{@"holder" : self.animatedImageView, @"closeButton" : closeButton};
	NSDictionary *metrics = @{@"padding" : @(10)};
	[self.popUpShareViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[holder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.popUpShareViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:self.animatedImageView attribute:NSLayoutAttributeCenterY
																				   relatedBy:NSLayoutRelationEqual
																					  toItem:self.popUpShareViewController.view attribute:NSLayoutAttributeCenterY
																				  multiplier:1.0 constant:0]];
	[self.popUpShareViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:self.animatedImageView attribute:NSLayoutAttributeHeight
																				   relatedBy:NSLayoutRelationEqual
																					  toItem:nil attribute:NSLayoutAttributeNotAnAttribute
																				  multiplier:1.0 constant:300]];

	previewingContext.sourceRect = self.animatedImageView.frame;
	return self.popUpShareViewController;
}

- (void)onCloseButtonPressed:(UIButton *)sender {
	[self.popUpShareViewController dismissViewControllerAnimated:self.accessibilityElementsHidden completion:^{
	}];
}


- (void)setData:(NSString *)urlString {

	self.animatedImageView.alpha = 0.f;

	dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue", NULL);
	dispatch_async(imageQueue, ^{
		NSURL *url = [NSURL URLWithString:urlString];
		FLAnimatedImage *imageObject = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:url]];

		dispatch_async(dispatch_get_main_queue(), ^{
			// Update the UI
			[self.animatedImageView setAnimatedImage:imageObject];
			self.animatedImageView.alpha = 1.f;
		});

	});
}

#pragma mark Rotation
//
//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//	[self.collectionView setAlpha:0.0f];
//	[self.collectionView.collectionViewLayout invalidateLayout];
//	CGPoint currentOffset = [self.collectionView contentOffset];
//	self.currentIndex = (NSInteger) (currentOffset.x / self.collectionView.frame.size.width);
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//	return self.collectionView.frame.size;
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