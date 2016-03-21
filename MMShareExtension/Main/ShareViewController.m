//
//  ShareViewController.m
//  MMShareExtension
//
//  Created by mm0030240 on 06/10/15.
//  Copyright © 2015 mm0030240. All rights reserved.
//

#import "ShareViewController.h"
#import "FLAnimatedImage.h"
#import <CoreData/CoreData.h>
#import "CoreDataStack.h"
#import "GIFEntity.h"
#import "PopUpShareViewController.h"
#import "ShareCollectionView.h"
#import "MMKeyboardCollectionViewCell.h"

@interface ShareViewController () <UIViewControllerPreviewingDelegate>


// Views
@property(nonatomic, strong) PopUpShareViewController *popUpShareViewController;
@property(nonatomic, strong) FLAnimatedImageView *animatedImageView;
@property(nonatomic, strong) ShareCollectionView *shareCollectionView;


@end

@implementation ShareViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
	[super viewDidLoad];
	[self registerForPreviewingWithDelegate:(id) self sourceView:self.view]; // TODO


	self.holder = [UIView new];
	self.holder.translatesAutoresizingMaskIntoConstraints = NO;
	self.holder.backgroundColor = [UIColor blackColor];
	self.holder.layer.cornerRadius = 10;
	[self.view addSubview:self.holder];

	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
	cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
	[cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[cancelButton setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
	[cancelButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
	[cancelButton addTarget:self action:@selector(onCancelTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self.holder addSubview:cancelButton];

	self.titleLabel = [UILabel new];
	self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	self.titleLabel.textColor = [UIColor whiteColor];
	[self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
	[self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	self.titleLabel.textAlignment = NSTextAlignmentCenter;
	[self.holder addSubview:self.titleLabel];

	self.shareCollectionView = [[ShareCollectionView alloc] initWithPresentingViewController:self];
	self.shareCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.holder addSubview:self.shareCollectionView];


	self.normalButton = [UIButton buttonWithType:UIButtonTypeSystem];
	self.normalButton.translatesAutoresizingMaskIntoConstraints = NO;
	[self.normalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.normalButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[self.normalButton setTitle:@"Normal" forState:UIControlStateNormal];
	[self.normalButton addTarget:self action:@selector(normalButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self.holder addSubview:self.normalButton];

	self.awesomeButton = [UIButton buttonWithType:UIButtonTypeSystem];
	self.awesomeButton.translatesAutoresizingMaskIntoConstraints = NO;
	[self.awesomeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.awesomeButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[self.awesomeButton setTitle:@"Awesome!" forState:UIControlStateNormal];
	[self.awesomeButton addTarget:self action:@selector(onAwesomeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self.holder addSubview:self.awesomeButton];


	NSDictionary *views = @{@"holder" : self.holder, @"cancelBtn" : cancelButton, @"title" : self.titleLabel, @"collection" : self.shareCollectionView,
			@"shareBtn1" : self.normalButton, @"shareBtn2" : self.awesomeButton};
	NSDictionary *metrics = @{@"padding" : @(10)};


	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.holder attribute:NSLayoutAttributeCenterY
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view attribute:NSLayoutAttributeCenterY
														 multiplier:1.0 constant:0]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.holder attribute:NSLayoutAttributeCenterX
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view attribute:NSLayoutAttributeCenterX
														 multiplier:1.0 constant:0]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.holder attribute:NSLayoutAttributeHeight
														  relatedBy:NSLayoutRelationEqual
															 toItem:nil attribute:NSLayoutAttributeNotAnAttribute
														 multiplier:1.0 constant:300]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.holder attribute:NSLayoutAttributeWidth
														  relatedBy:NSLayoutRelationEqual
															 toItem:nil attribute:NSLayoutAttributeNotAnAttribute
														 multiplier:1.0 constant:300]];


	[self.holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[cancelBtn]-5-[collection]-5-[shareBtn1]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[title]-5-[collection]-5-[shareBtn1]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[cancelBtn]-5-[collection]-5-[shareBtn2]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[title]-5-[collection]-5-[shareBtn2]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[cancelBtn]-(>=0)-[title]-(>=0)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.holder addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterX
															relatedBy:NSLayoutRelationEqual
															   toItem:self.holder attribute:NSLayoutAttributeCenterX
														   multiplier:1.0 constant:0]];
	[self.holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[shareBtn1(==shareBtn2)]-0-[shareBtn2(==shareBtn1)]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[collection]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
}


#pragma mark - Actions

- (void)onCancelTapped:(UIButton *)sender {
	[self.extensionContext cancelRequestWithError:[NSError new]];
}


- (void)normalButtonTapped:(UIButton *)sender {
	[self animateViewWithType:@"Normal"];
}

- (void)onAwesomeButtonTapped:(UIButton *)sender {
	[self animateViewWithType:@"Awesome"];


}

#pragma mark Animation

- (void)animateViewWithType:(NSString *)type {


	UIView *holderTemp = [UIView new];
	holderTemp.translatesAutoresizingMaskIntoConstraints = NO;
	holderTemp.layer.cornerRadius = 10;
	holderTemp.backgroundColor = [UIColor blackColor];

	self.animatedImageView = [FLAnimatedImageView new];
	self.animatedImageView.translatesAutoresizingMaskIntoConstraints = NO;
	MMKeyboardCollectionViewCell *cell = (MMKeyboardCollectionViewCell *) [self.shareCollectionView.collectionView cellForItemAtIndexPath:self.shareCollectionView.currentIndexPath];
	[self.animatedImageView setContentMode:UIViewContentModeScaleToFill];
	[self.animatedImageView setAnimatedImage:cell.imageView.animatedImage];

	UILabel *label = [UILabel new];

	[label setText:type];
	[label setTextColor:[UIColor whiteColor]];
	label.translatesAutoresizingMaskIntoConstraints = NO;

	[self.view addSubview:holderTemp];
	[holderTemp addSubview:self.animatedImageView];
	[holderTemp addSubview:label];

	NSDictionary *views = @{@"animatedImageView" : self.animatedImageView, @"holder" : holderTemp, @"label" : label};
	NSDictionary *metrics = @{@"padding" : @(10) ,@"imageHeight": @(self.shareCollectionView.collectionView.frame.size.height)};

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

	[holderTemp addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[animatedImageView]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holderTemp addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX
														   relatedBy:NSLayoutRelationEqual
															  toItem:holderTemp attribute:NSLayoutAttributeCenterX
														  multiplier:1.0 constant:0]];
	[holderTemp addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=10)-[animatedImageView(imageHeight)]-5-[label]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

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

		[self.shareCollectionView.data removeObjectAtIndex:(NSUInteger) self.shareCollectionView.currentIndexPath.row];

	}                completion:^(BOOL finished) {

		CoreDataStack *coreData = [CoreDataStack defaultStack];
		GIFEntity *gifEntity = [NSEntityDescription insertNewObjectForEntityForName:@"GIFEntity" inManagedObjectContext:coreData.managedObjectContext];
		gifEntity.self.gifURL = self.shareCollectionView.gifURL;
		gifEntity.self.gifCategory = type;
		[coreData saveContext];

	}];

	[self.shareCollectionView.collectionView reloadData];
	[self.shareCollectionView currentIndexPathMethod];


}


#pragma mark Preview Context

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
// Method needed so that the user doesn't pop to another viewcontroller.

}

- (UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {

	self.popUpShareViewController = [PopUpShareViewController new];

	self.animatedImageView = [FLAnimatedImageView new];
	self.animatedImageView.translatesAutoresizingMaskIntoConstraints = NO;
	[self setData:self.shareCollectionView.gifURL];

	NSURL *url = [[NSURL alloc] initWithString:self.shareCollectionView.gifURL];
	self.popUpShareViewController.url = url;
	self.popUpShareViewController.view.backgroundColor = [UIColor blackColor];
	[self.popUpShareViewController.view addSubview:self.animatedImageView];

	NSDictionary *views = @{@"imageView" : self.animatedImageView};
	NSDictionary *metrics = @{@"padding" : @(10)};
	self.popUpShareViewController.view.backgroundColor = [UIColor clearColor];
	[self.popUpShareViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
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


@end