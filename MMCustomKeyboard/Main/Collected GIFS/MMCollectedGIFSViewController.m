//
//  MMCollectedGIFSViewController.m
//  MMCustomKeyboard
//
//  Created by mm0030240 on 06/10/15.
//  Copyright © 2015 mm0030240. All rights reserved.
//

#import "MMCollectedGIFSViewController.h"
#import "FLAnimatedImage.h"
#import "CoreDataStack.h"
#import "GIFEntity.h"
#import "MMCollectionViewFlowLayout.h"
#import "MMPreviewViewController.h"
#import "MMGIFKeyboardCollectionViewCell.h"

@interface MMCollectedGIFSViewController () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate>

// Views
@property(strong, nonatomic) UICollectionView *collectionView;
@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
//@property(strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;

// Variables
@property(strong, nonatomic) FLAnimatedImage *image;
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, strong) NSMutableArray *data;
@property(nonatomic, assign) MMSearchType type;
@property(nonatomic, strong) NSMutableDictionary *gifHolder;


@end

@implementation MMCollectedGIFSViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self loadGifs];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadGifs) name:@"reloadGIFS" object:nil];

}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadGIFS" object:nil];

}


- (void)viewDidLoad {
	[super viewDidLoad];

	[self.fetchedResultsController performFetch:nil];
	self.type = MMSearchTypeAll;

	self.gifHolder = @{}.mutableCopy;

	self.flowLayout = [UICollectionViewFlowLayout new];
	self.flowLayout.minimumInteritemSpacing = 0;
	[self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

	self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.flowLayout];
	[self.collectionView registerClass:[MMGIFKeyboardCollectionViewCell class] forCellWithReuseIdentifier:[MMGIFKeyboardCollectionViewCell reuseIdentifier]];
	self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	self.collectionView.backgroundColor = [UIColor blackColor];
	[self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 60, 0)];
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	[self.view addSubview:self.collectionView];


	UIView *holder = [UIView new];
	holder.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:holder];

	UIButton *allButton = [UIButton buttonWithType:UIButtonTypeCustom];
	allButton.translatesAutoresizingMaskIntoConstraints = NO;
	[allButton setTitle:@"All" forState:UIControlStateNormal];
	[allButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[allButton setBackgroundColor:[UIColor lightGrayColor]];
	[allButton addTarget:self action:@selector(allButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	allButton.layer.cornerRadius = 10;
	[holder addSubview:allButton];

	UIButton *normalButton = [UIButton buttonWithType:UIButtonTypeCustom];
	normalButton.translatesAutoresizingMaskIntoConstraints = NO;
	[normalButton setTitle:@"Normal" forState:UIControlStateNormal];
	[normalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[normalButton setBackgroundColor:[UIColor lightGrayColor]];
	[normalButton addTarget:self action:@selector(normalButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	normalButton.layer.cornerRadius = 10;
	[holder addSubview:normalButton];

	UIButton *awesomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	awesomeButton.translatesAutoresizingMaskIntoConstraints = NO;
	[awesomeButton setTitle:@"Awesome" forState:UIControlStateNormal];
	[awesomeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[awesomeButton setBackgroundColor:[UIColor lightGrayColor]];
	[awesomeButton addTarget:self action:@selector(awesomeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	awesomeButton.layer.cornerRadius = 10;
	[holder addSubview:awesomeButton];

	id topGuide = self.topLayoutGuide;

	NSDictionary *views = @{@"collection" : self.collectionView, @"holder" : holder, @"allButton" : allButton, @"normalButton" : normalButton, @"awesomeButton" : awesomeButton};
	NSDictionary *metrics = @{@"padding" : @(10), @"topGuide": @((NSInteger)topGuide)};


	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collection]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[holder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[holder]-10-[collection]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[allButton(==awesomeButton)]-5-[normalButton(==allButton)]-5-[awesomeButton(allButton)]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[allButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[normalButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[awesomeButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
}


#pragma mark Actions

- (void)allButtonTapped:(UIButton *)sender {

	[self newType:MMSearchTypeAll];
}

- (void)normalButtonTapped:(UIButton *)sender {

	[self newType:MMSearchTypeNormal];
}

- (void)awesomeButtonTapped:(UIButton *)sender {

	[self newType:MMSearchTypeAwesome];
}


- (void)newType:(MMSearchType)type {

	if (type) {
		self.type = type;
		[self loadGifs];
	}
}

#pragma mark Methods

- (void)loadGifs {

	self.data = [@[] mutableCopy];

	[self.fetchedResultsController performFetch:nil];


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

	[self.collectionView reloadData];
}

#pragma mark Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

	return self.data ? self.data.count : 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

	return CGSizeMake((CGFloat) (self.view.frame.size.width / 3 - 4), (CGFloat) (self.view.frame.size.width / 3 - 4));
}

//- (UICollectionViewCell *)gifKeyboardView:(UICollectionView *)gifKeyboardView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//	MMGIFKeyboardCollectionViewCell *cell = [gifKeyboardView dequeueReusableCellWithReuseIdentifier:[MMGIFKeyboardCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
//	[cell setBackgroundColor:[UIColor clearColor]];
//
//	[cell setData:[self.data valueForKey:@"gifURL"][(NSUInteger) indexPath.row]];
//
//	return cell;
//
//}

- (MMGIFKeyboardCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

	MMGIFKeyboardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MMGIFKeyboardCollectionViewCell reuseIdentifier] forIndexPath:indexPath];

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


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {


	MMGIFKeyboardCollectionViewCell *cell = (MMGIFKeyboardCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
//	entity[indexPath.row];
	MMPreviewViewController *viewController = [[MMPreviewViewController alloc] initWithAnimatedImage:cell.imageView.animatedImage withGifEntity:self.data[(NSUInteger) indexPath.row]];
	viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
	[self presentViewController:viewController animated:YES completion:nil];

}

#pragma  mark - NSFetchedResultController

- (NSFetchRequest *)entryListFetchRequest {
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSLocalizedString(@"CoreData.Entity.Key", nil)];
	fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:NSLocalizedString(@"CoreData.URL.Key", nil) ascending:NO]]; // This will sort how the request is shown
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
	// Dispose of any resources that can be recreated.
}

@end
