//
// Created by Tom Atterton on 18/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "ShareCollectionView.h"
#import "ShareViewController.h"
#import "KeyboardViewController.h"
#import "ShareCollectionFlowLayout.h"
#import "CoreDataStack.h"
#import "GIFEntity.h"
#import "MMKeyboardCollectionViewCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+emoji.h"


@interface ShareCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

// View
//@property(nonatomic, strong) KeyboardButtonView *buttonView;
@property(nonatomic, strong) ShareCollectionFlowLayout *collectionFlowLayout;
@property(nonatomic, strong) ShareViewController *presentingViewController;


// Variables
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, assign) MMSearchType type;
@property(nonatomic, assign) NSIndexPath *currentIndexPath;

@end

@implementation ShareCollectionView


- (instancetype)initWithPresentingViewController:(ShareViewController *)presentingViewController {
	self = [super init];

	if (self) {

//		self.type = MMSearchTypeAll;
		self.presentingViewController = presentingViewController;
//		self.lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
//		self.lpgr.minimumPressDuration = .5;
//		self.lpgr.allowableMovement = 100.0f;
//		self.lpgr.delaysTouchesBegan = YES;
//		self.lpgr.delegate = self;
//		self.lpgr.cancelsTouchesInView = NO;

		[self setup];
	}

	return self;
}


- (void)setup {

	[self setTranslatesAutoresizingMaskIntoConstraints:NO];


	self.collectionFlowLayout = [ShareCollectionFlowLayout new];
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
//	[self.collectionView addGestureRecognizer:self.lpgr];
	[self addSubview:self.collectionView];


	NSDictionary *metrics = @{};
	NSDictionary *views = @{
			@"collectionView" : self.collectionView,
	};

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|" options:metrics metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collectionView]-0-|" options:metrics metrics:metrics views:views]];

	[self loadGifs];


}


#pragma mark CollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

	if (!self.data.count > 0) {

		[self loadEmptyCell];
	}
	else {
		[self.emptyCellView removeFromSuperview];
		[self updateTitle:1 setAmount:self.data.count];
	}
	return self.data ? self.data.count : 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

	return CGSizeMake((CGFloat) (collectionView.frame.size.width), (CGFloat) (collectionView.frame.size.height));
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

//	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
//	tapGestureRecognizer.delegate = self;
//	tapGestureRecognizer.delaysTouchesBegan = YES;
//	[self.collectionView addGestureRecognizer:tapGestureRecognizer];


	MMKeyboardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MMKeyboardCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
	[cell setBackgroundColor:[UIColor clearColor]];

	[cell setData:self.data[(NSUInteger) indexPath.row]];

	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

		self.presentingViewController.gifURL = self.data[(NSUInteger) indexPath.row]; // TODO more efficient

}

#pragma mark - ScrollView Delegates

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

	CGFloat pageWidth = scrollView.frame.size.width;
	float fractionalPage = scrollView.contentOffset.x / pageWidth;
	NSUInteger page = (NSUInteger) lround(fractionalPage);

	if (self.data.count == 1) {
		[self updateTitle:page + 1 setAmount:self.data.count - 1];
	}
	else {
		[self updateTitle:page + 1 setAmount:self.data.count + 1];
	}
	for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
		self.currentIndexPath = [self.collectionView indexPathForCell:cell];
		self.presentingViewController.gifURL = self.data[(NSUInteger) self.currentIndexPath.row]; // TODO more efficient
	}

}

#pragma mark Actions

- (void)normalButtonPressed {

	self.presentingViewController.gifURL = self.data[(NSUInteger) self.currentIndexPath.row];
	self.presentingViewController.gifIndex = self.currentIndexPath;

}

- (void)awesomeButtonPressed {

	self.presentingViewController.gifURL = self.data[(NSUInteger) self.currentIndexPath.row];
	self.presentingViewController.gifIndex = self.currentIndexPath;

}

#pragma mark Methods

- (void)loadGifs {

	for (NSExtensionItem *extensionItem in self.presentingViewController.extensionContext.inputItems) {
		for (NSItemProvider *itemProvider in extensionItem.attachments) {
			NSString *urlType = (NSString *) kUTTypePropertyList;

			if ([itemProvider hasItemConformingToTypeIdentifier:urlType]) {
				[itemProvider loadItemForTypeIdentifier:urlType options:nil completionHandler:^(NSDictionary *item, NSError *error) {
					NSDictionary *urls = item.allValues[0];

					NSLog(@"%@", urls);
					self.data = [@[] mutableCopy];

					for (NSUInteger i = 0; i < urls.count; ++i) {
						NSString *urlString = urls[[NSString stringWithFormat:@"%lu", (unsigned long) i]];

						if ([self.data indexOfObject:urlString] == NSNotFound) {
							NSLog(@"%@", urlString);
							[self.data addObject:urlString];
						}
					};


					self.presentingViewController.gifCount = self.data.count;

					[self.data enumerateObjectsUsingBlock:^(NSString *urlString, NSUInteger _idx, BOOL *_stop) {
						dispatch_async(dispatch_get_main_queue(), ^{

							if (_idx == self.data.count - 1) {
//								self.collectionFlowLayout.itemSize = CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);


								if (self.data.count == 1) {
//									self.titleLabel.text = [NSString stringWithFormat:@"1 of %ld Gifs", (long) self.collectionAmount]; // TODO set title label
								}
//								self.titleLabel.text = [NSString stringWithFormat:@"1 of %ld Gifs", (long) self.collectionAmount - 1]; // TODO set title label
								if (!self.data.count > 0) {


								}
								[self.collectionView reloadData];

							}
						});

					}];

				}];


			}


		}
	}


}

- (void)updateTitle:(NSUInteger)page setAmount:(NSUInteger)amount {

	NSString *tempString = @"";

	if (amount > 0) {

		tempString = [NSString stringWithFormat:@"%u of %u Gifs", page, amount];

	}
	if (amount == 1) {
		tempString = [NSString stringWithFormat:@"%u of %u Gifs", 1, 1];

	}

	[self.presentingViewController.titleLabel setText:tempString];
}

- (void)loadEmptyCell {

	self.emptyCellView = [UIView new];
	self.emptyCellView.translatesAutoresizingMaskIntoConstraints = NO;
	self.emptyCellView.backgroundColor = [UIColor clearColor];
	[self addSubview:self.emptyCellView];

	UILabel *emptyLabel = [UILabel new];
	emptyLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[emptyLabel setText:@"No GIF's For You"];
	emptyLabel.numberOfLines = 0;
	[emptyLabel setTextAlignment:NSTextAlignmentCenter];
	[emptyLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18]];
	[emptyLabel setTextColor:[UIColor whiteColor]];
	[self.emptyCellView addSubview:emptyLabel];


	UIImageView *emojiView = [UIImageView new];
	emojiView.translatesAutoresizingMaskIntoConstraints = NO;
	[emojiView setImage:[UIImage imageWithEmoji:@"😭" withSize:60.0f]];
	emojiView.contentMode = UIViewContentModeScaleAspectFit;
	[self.emptyCellView addSubview:emojiView];

	NSDictionary *views = @{@"message" : emptyLabel, @"emptyCellView" : self.emptyCellView, @"emoji" : emojiView};
	NSDictionary *metrics = @{@"padding" : @(10)};

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[emptyCellView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[emptyCellView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	[self.emptyCellView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[message]-5-[emoji]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.emptyCellView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[message]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.emptyCellView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[emoji]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	[self.emptyCellView addConstraint:[NSLayoutConstraint constraintWithItem:emptyLabel attribute:NSLayoutAttributeCenterY
																   relatedBy:NSLayoutRelationEqual
																	  toItem:self.emptyCellView attribute:NSLayoutAttributeCenterY
																  multiplier:1.0 constant:-30]];
	[self.emptyCellView addConstraint:[NSLayoutConstraint constraintWithItem:emptyLabel attribute:NSLayoutAttributeCenterX
																   relatedBy:NSLayoutRelationEqual
																	  toItem:self.emptyCellView attribute:NSLayoutAttributeCenterX
																  multiplier:1.0 constant:0]];


}


@end