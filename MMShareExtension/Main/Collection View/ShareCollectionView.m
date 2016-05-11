//
// Created by Tom Atterton on 18/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "ShareCollectionView.h"
#import "ShareViewController.h"
#import "ShareCollectionFlowLayout.h"
#import "CoreDataStack.h"
#import "GIFEntity.h"
#import "MMGIFKeyboardCollectionViewCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+emoji.h"
#import "FLAnimatedImage.h"


@interface ShareCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

// View
@property(nonatomic, strong) ShareCollectionFlowLayout *collectionFlowLayout;
@property(nonatomic, strong) ShareViewController *presentingViewController;
@property(nonatomic, assign) NSUInteger page;

@property(nonatomic, strong) NSMutableDictionary *gifHolder;

@end

@implementation ShareCollectionView


- (instancetype)initWithPresentingViewController:(ShareViewController *)presentingViewController {
	self = [super init];

	if (self) {

		self.presentingViewController = presentingViewController;

		[self setup];
	}

	return self;
}


- (void)setup {

	[self setTranslatesAutoresizingMaskIntoConstraints:NO];
	self.gifHolder = [@{} mutableCopy];
	self.page = 1;

	self.collectionFlowLayout = [ShareCollectionFlowLayout new];
	[self.collectionFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

	self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionFlowLayout];
	self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;

	self.collectionView.clipsToBounds = YES;
	[self.collectionView registerClass:[MMGIFKeyboardCollectionViewCell class] forCellWithReuseIdentifier:[MMGIFKeyboardCollectionViewCell reuseIdentifier]];
	self.collectionView.backgroundColor = [UIColor blackColor];
	[self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	[self addSubview:self.collectionView];


	NSDictionary *metrics = @{};
	NSDictionary *views = @{
			@"shareCollectionView" : self.collectionView,
	};

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[shareCollectionView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[shareCollectionView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	[self loadGifs];


}


#pragma mark CollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

	if (self.data.count <= 0) {

		[self loadEmptyCell];

		self.presentingViewController.titleLabel.hidden = YES;
		self.presentingViewController.normalButton.hidden = YES;
		self.presentingViewController.awesomeButton.hidden = YES;

	}
	else {
		[self.emptyCellView removeFromSuperview];

		[self updateTitle:self.page ? self.page : 1 setAmount:self.data.count == 1 ? 1 : self.data.count + 1];
		self.presentingViewController.titleLabel.hidden = NO;
		self.presentingViewController.normalButton.hidden = NO;
		self.presentingViewController.awesomeButton.hidden = NO;
	}
	return self.data ? self.data.count : 0;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

	return CGSizeMake((CGFloat) (collectionView.frame.size.width), (CGFloat) (collectionView.frame.size.height));
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

	MMGIFKeyboardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MMGIFKeyboardCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
	[cell setBackgroundColor:[UIColor clearColor]];

	[cell setData:self.data[(NSUInteger) indexPath.row]];

	return cell;
}

//- (MMGIFKeyboardCollectionViewCell *)gifKeyboardView:(UICollectionView *)gifKeyboardView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//	MMGIFKeyboardCollectionViewCell *cell = [gifKeyboardView dequeueReusableCellWithReuseIdentifier:[MMGIFKeyboardCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
//
//	[cell setBackgroundColor:[UIColor clearColor]];
//
//	NSUInteger item = (NSUInteger) indexPath.item;
//	FLAnimatedImage *image = self.gifHolder[self.data[item]];
//	cell.imageView.alpha = 0.f;
//
//	if (image) {
//
//		[cell.imageView setAnimatedImage:image];
//		cell.imageView.alpha = 1.f;
//		return cell;
//	}
//	[self loadGifItem:item callback:^(FLAnimatedImage *tempImage) {
//		[self.gifHolder setValue:tempImage forKey:self.data[item]];
//		cell.imageView.alpha = 1.f;
//
//		[cell.imageView setAnimatedImage:tempImage];
//	}];
//
//
//	return cell;
//}
//
//- (void)loadGifItem:(NSUInteger)item callback:(void (^)(FLAnimatedImage *image))callback {
//	if (item < self.data.count) {
//		NSURL *url = [[NSURL alloc] initWithString:self.data[item]];
//		NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//
//		[NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//			FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
//			callback(image);
//		}];
//	}
//}

#pragma mark - ScrollView Delegates

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

	CGFloat pageWidth = scrollView.frame.size.width;
	float fractionalPage = scrollView.contentOffset.x / pageWidth;
	self.page = (NSUInteger) lround(fractionalPage);

	if (self.data.count == 1) {
		[self updateTitle:self.page + 1 setAmount:self.data.count - 1];
	}
	else {
		[self updateTitle:self.page + 1 setAmount:self.data.count + 1];
	}

	[self currentIndexPathMethod];

}


- (void)currentIndexPathMethod {

	CGRect visibleRect = (CGRect) {.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
	CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
	if (!self.data.count == 0) {

		self.currentIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
		self.gifURL = self.data[(NSUInteger) [self.collectionView indexPathForItemAtPoint:visiblePoint].row];
	}

	if (!self.currentIndexPath || !self.gifURL) {
		NSLog(@"First Time Loading");


	}

}

#pragma mark Methods

- (void)loadGifs {

	for (NSExtensionItem *extensionItem in self.presentingViewController.extensionContext.inputItems) {
		for (NSItemProvider *itemProvider in extensionItem.attachments) {
			NSString *urlType = (NSString *) kUTTypePropertyList;

			if ([itemProvider hasItemConformingToTypeIdentifier:urlType]) {
				[itemProvider loadItemForTypeIdentifier:urlType options:nil completionHandler:^(NSDictionary *item, NSError *error) {
					NSDictionary *urls = item.allValues[0];

					self.data = [@[] mutableCopy];

					for (NSUInteger i = 0; i < urls.count; ++i) {
						NSString *urlString = urls[[NSString stringWithFormat:@"%lu", (unsigned long) i]];

						if ([self.data indexOfObject:urlString] == NSNotFound) {
							[self.data addObject:urlString];
						}
					};

					[self.data enumerateObjectsUsingBlock:^(NSString *urlString, NSUInteger _idx, BOOL *_stop) {
						dispatch_async(dispatch_get_main_queue(), ^{

							if (_idx == self.data.count - 1) {


								if (self.data.count == 1) {
								}
								if (!self.data.count > 0) {


								}
								[self.collectionView reloadData];
								[self currentIndexPathMethod];

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