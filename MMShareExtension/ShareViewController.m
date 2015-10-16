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

@interface ShareViewController ()<UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *urlHolderArray;
@property (nonatomic, strong) NSMutableArray *imageObjects;
@property (nonatomic, strong) UIView *lastView;
@property (nonatomic) NSInteger collectionAmount;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionFlowLayout;
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

	//	[self loadCollectionView];
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

	//	self.scrollView = [UIScrollView new];
	//	self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
	//	[self.scrollView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
	//	[self.scrollView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
	//	self.scrollView.delegate = self;
	//	self.scrollView.pagingEnabled = YES;
	//	self.scrollView.backgroundColor = [UIColor redColor];  // TODO
	//	[holder addSubview:self.scrollView];

	NSDictionary *views = @{@"holder" : holder, @"cancelBtn" : cancelButton, @"title" : titleLabel, @"postBtn" : postButton, @"collection" : self.collectionView};
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

	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[cancelBtn]-0-[collection]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[title]-0-[collection]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[postBtn]-0-[collection]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[cancelBtn(==postBtn)]-0-[title]-0-[postBtn(==cancelBtn)]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collection]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
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

- (void)updateViewConstraints
{
	[super updateViewConstraints];
}

#pragma mark - Actions

- (void)onCancelTapped:(UIButton *)sender
{
	[self.extensionContext cancelRequestWithError:[NSError new]];
}

- (void)onPostTapped:(UIButton *)sender
{
//    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] initWithImage:self.imageObjects[0]];
//
//
//
//    //Create an animation with pulsating effect
//    CABasicAnimation *theAnimation;
//
//    //within the animation we will adjust the "opacity"
//    //value of the layer
//    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
//    //animation lasts 0.4 seconds
//    theAnimation.duration=0.4;
//    //and it repeats forever
//    theAnimation.repeatCount= 1e100f;
//    //we want a reverse animation
//    theAnimation.autoreverses=YES;
//    //justify the opacity as you like (1=fully visible, 0=unvisible)
//    theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
//    theAnimation.toValue=[NSNumber numberWithFloat:0.1];
//
//    //Assign the animation to your UIImage layer and the
//    //animation will start immediately
//    [imageView.layer addAnimation:theAnimation forKey:@"animateOpacity"];
    
//    CAAnimation *ani = [CAAnimation animation];
//	CATransition *animation = [CATransition animation];
//	[animation setDuration:1];
//	[animation setType:kCATransitionPush];
//	[animation setSubtype:kCATransitionFromBottom];
//	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
//    animation.delegate = self;
//    [UIView animateWithDuration:1.0f // This can be changed.
//                     animations:^{
//                         CGRect frame = self.view.frame;
//                         frame.size.width += 100.0f; // This is just for the width, but you can change the origin and the height as well.
//                         self.view.frame = frame;
//                     }
//                     completion:^(BOOL finished){
//                     }];
//	[[self.view layer] addAnimation:animation forKey:@"SlideOutandInImagek"];
//	
//    [UIView animateWithDuration:0.5
//                          delay:0
//                        options:UIViewAnimationOptionBeginFromCurrentState
//                     animations:(void (^)(void)) ^{
//                         self.view.transform=CGAffineTransformMakeScale(1.2, 1.2);
//                     }
//                     completion:^(BOOL finished){
//                         self.view.transform=CGAffineTransformIdentity;
//                     }];
	


}
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
//    [self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
//    NSLog(@"derp");
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
								self.collectionFlowLayout.itemSize = CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
								self.collectionAmount = self.urlHolderArray.count;
								[self.collectionView reloadData];
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
	//	[self.scrollView addSubview:imageView];

	[self.imageObjects addObject:imageView];

	//		self.lastView = imageView;
	//	//
	//		NSDictionary *views = @{@"imageView" : imageView, @"scrollView" : self.collectionView};
	//		NSDictionary *metrics = @{@"padding" : @(10)};
	//
	//		[self.collectionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView(==scrollView)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	//
	//		if (lastView)
	//		{
	//			views = @{@"imageView" : imageView, @"scrollView" : self.scrollView, @"lastView" : lastView};
	//			[self.collectionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[lastView]-0-[imageView(==scrollView)]-(>=0)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	//		}
	//		else
	//		{
	//			[self.collectionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView(==scrollView)]-(>=0)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	//		}
}

#pragma mark - ScrollView Delegates

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//	CGFloat pageWidth = self.scrollView.frame.size.width;
//	float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
//	NSUInteger page = (NSUInteger)lround(fractionalPage);
//
//	[self loadGifForPage:page];
//	[self loadGifForPage:page + 1];
//	[self loadGifForPage:page - 1];
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
	[self loadGifForPage:indexPath.row];
	[self loadGifForPage:indexPath.row + 1];
	[self loadGifForPage:indexPath.row - 1];
	[cell setBackgroundView:self.imageObjects[indexPath.row]];
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%lu",indexPath.row);

}

// Returns the amount of sections in the collection view dependant on how many images there are in the array
- (NSUInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSUInteger)section
{
	return self.collectionAmount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
	//    FLAnimatedImageView *imageView = self.imageObjects[indexPath.row];
	//	[self loadGifForPage:indexPath.row];
	[cell setBackgroundView:self.imageObjects[indexPath.row]];
	return cell;
}

- (void)loadGifForPage:(NSUInteger)page
{
	if (page < self.urlHolderArray.count)
	{
		FLAnimatedImageView *imageView = self.imageObjects[page];

		[imageView downloadURLWithString:self.urlHolderArray[page] callback:^(FLAnimatedImage *image)
		{
			imageView.animatedImage = image;
		}];
	}
}

#pragma mark Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[self.collectionView setAlpha:0.0f];
	[self.collectionView.collectionViewLayout invalidateLayout];
	CGPoint currentOffset = [self.collectionView contentOffset];
	self.currentIndex = currentOffset.x / self.collectionView.frame.size.width;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return self.collectionView.frame.size;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
	[self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
	[UIView animateWithDuration:0.125f animations:^
	{
		[self.collectionView setAlpha:1.0f];
	}];
}
@end
