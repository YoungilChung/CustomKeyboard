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

@interface ShareViewController () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *urlHolderArray;
@property (nonatomic, strong) NSMutableArray *imageObjects;
@property (nonatomic, strong) UIView *lastView;

@end

@implementation ShareViewController

#pragma mark - Life cycle

- (void)viewDidLoad
{
	[super viewDidLoad];

	UIView *holder = [UIView new];
	holder.translatesAutoresizingMaskIntoConstraints = NO;
	holder.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:holder];

	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
	cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
	[cancelButton setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
	[cancelButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
	[cancelButton addTarget:self action:@selector(onCancelTapped:) forControlEvents:UIControlEventTouchUpInside];
	[holder addSubview:cancelButton];

	UILabel *titleLabel = [UILabel new];
	titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[titleLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
	[titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	titleLabel.textAlignment = NSTextAlignmentCenter;
	titleLabel.text = @"Title";
	[holder addSubview:titleLabel];

	UIButton *postButton = [UIButton buttonWithType:UIButtonTypeSystem];
	postButton.translatesAutoresizingMaskIntoConstraints = NO;
	[postButton setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
	[postButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[postButton setTitle:@"Post" forState:UIControlStateNormal];
	[postButton addTarget:self action:@selector(onPostTapped:) forControlEvents:UIControlEventTouchUpInside];
	[holder addSubview:postButton];

	//Collection View
	self.collectionView = [UICollectionView  new];
	self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	self.collectionView.delegate = self;

	self.scrollView = [UIScrollView new];
	self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.scrollView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
	[self.scrollView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
	self.scrollView.delegate = self;
	self.scrollView.pagingEnabled = YES;
	self.scrollView.backgroundColor = [UIColor redColor];  // TODO
	[holder addSubview:self.scrollView];

	NSDictionary *views = @{@"holder" : holder, @"cancelBtn" : cancelButton, @"title" : titleLabel, @"postBtn" : postButton, @"scroll" : self.scrollView};
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

	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[cancelBtn]-0-[scroll]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[title]-0-[scroll]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[postBtn]-0-[scroll]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[cancelBtn(==postBtn)]-0-[title]-0-[postBtn(==cancelBtn)]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[scroll]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	self.view.transform = CGAffineTransformMakeTranslation(0, self.view.frame.size.height);

	[UIView animateWithDuration:0.25 animations:^
	{
		self.view.transform = CGAffineTransformIdentity;
	}];

	[self gifLoader];
}

#pragma mark - Actions

- (void)onCancelTapped:(UIButton *)sender
{
	[self.extensionContext cancelRequestWithError:[NSError new]];
}

- (void)onPostTapped:(UIButton *)sender
{
	[self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
}

- (void)gifLoader
{
	for (NSExtensionItem *extensionItem in self.extensionContext.inputItems)
	{
		for (NSItemProvider *itemProvider in extensionItem.attachments)
		{
			NSString *urlType = (NSString *)kUTTypePropertyList;

			if ([itemProvider hasItemConformingToTypeIdentifier:urlType])
			{
				[itemProvider loadItemForTypeIdentifier:urlType options:nil completionHandler:^(NSDictionary *item, NSError *error)
				{
					NSDictionary *urls = item.allValues[0];

					NSMutableArray *tempOrderedUrls = [@[] mutableCopy];

					for (NSUInteger i = 0; i < urls.count; ++i)
					{
						NSString *urlString = urls[[NSString stringWithFormat:@"%lu", (unsigned long)i]];
						if ([tempOrderedUrls indexOfObject:urlString] == NSNotFound)
						{
							[tempOrderedUrls addObject:urlString];
						}
					};

					self.urlHolderArray = [tempOrderedUrls copy];

					self.imageObjects = [@[] mutableCopy];

					[self.urlHolderArray enumerateObjectsUsingBlock:^(NSString *urlString, NSUInteger _idx, BOOL *_stop)
					{
						dispatch_async(dispatch_get_main_queue(), ^
						{
							[self setupGifImageView];

							if (_idx == self.urlHolderArray.count - 1)
							{
								[self loadGifForPage:0];
								[self loadGifForPage:1];
							}
						});
					}];
				}];
			}
		}
	}
}

- (void)setupGifImageView
{
	UIView *lastView = self.lastView;
	FLAnimatedImageView *imageView = [FLAnimatedImageView new];
	imageView.translatesAutoresizingMaskIntoConstraints = NO;
	imageView.contentMode = UIViewContentModeScaleAspectFill;
	imageView.clipsToBounds = YES;
	imageView.backgroundColor = [UIColor blackColor];
	[self.scrollView addSubview:imageView];

	[self.imageObjects addObject:imageView];

	self.lastView = imageView;

	NSDictionary *views = @{@"imageView" : imageView, @"scrollView" : self.scrollView};
	NSDictionary *metrics = @{@"padding" : @(10)};

	[self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView(==scrollView)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	if (lastView)
	{
		views = @{@"imageView" : imageView, @"scrollView" : self.scrollView, @"lastView" : lastView};
		[self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[lastView]-0-[imageView(==scrollView)]-(>=0)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	}
	else
	{
		[self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView(==scrollView)]-(>=0)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	}
}

#pragma mark - ScrollView Delegates

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	CGFloat pageWidth = self.scrollView.frame.size.width;
	float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
	NSUInteger page = (NSUInteger)lround(fractionalPage);

	[self loadGifForPage:page];
	[self loadGifForPage:page + 1];
	[self loadGifForPage:page - 1];
}

// Returns the amount of sections in the collection view dependant on how many images there are in the array
- (NSUInteger)collectionView:(UICollectionView *)numberOfSectionsInCollectionView :(UICollectionView *)collectionView
{
	return self.urlHolderArray.count;
}

- (void)loadGifForPage:(NSUInteger)page
{
	if (page < self.urlHolderArray.count)
	{
		FLAnimatedImageView *imageView = self.imageObjects[page];
//		NSURL *url = [[NSURL alloc] initWithString:self.urlHolderArray[page]];

		[imageView downloadURLWithString:self.urlHolderArray[page] callback:^(FLAnimatedImage *image) {
             imageView.animatedImage = image;
        }];
    }
}


@end
