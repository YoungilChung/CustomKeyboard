//
//  MMViewController.m
//  MMCustomKeyboard
//
//  Created by mm0030240 on 06/10/15.
//  Copyright © 2015 mm0030240. All rights reserved.
//

#import "MMViewController.h"
#import "FLAnimatedImage.h"
#import "CoreDataStack.h"
#import "GIFEntity.h"
#import "MMCollectionViewFlowLayout.h"
#import "MMPreviewViewController.h"
#import "MMKeyboardCollectionViewCell.h"

@interface MMViewController () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate>

// Views
@property(strong, nonatomic) UICollectionView *collectionView;
//@property(nonatomic, strong) MMCollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property(strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;

// Variables
@property(strong, nonatomic) FLAnimatedImage *image;
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, strong) NSMutableArray *data;
@property(nonatomic, strong) NSMutableArray *entityArray;
@property(nonatomic, assign) MMSearchType type;

@end

@implementation MMViewController

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

	self.flowLayout = [UICollectionViewFlowLayout new];
	self.flowLayout.minimumInteritemSpacing = 0;
	[self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

	self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.flowLayout];
	[self.collectionView registerClass:[MMKeyboardCollectionViewCell class] forCellWithReuseIdentifier:[MMKeyboardCollectionViewCell reuseIdentifier]];
	self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	self.collectionView.backgroundColor = [UIColor blackColor];
	[self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 60, 0)];
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	[self.view addSubview:self.collectionView];

	NSDictionary *views = @{@"collection" : self.collectionView, @"topGuide" : self.topLayoutGuide};
	NSDictionary *metrics = @{@"padding" : @(10)};
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collection]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collection]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

}

#pragma mark Actions

- (IBAction)segmentController_Tapped:(UISegmentedControl *)sender {

	NSLog(@"%i", sender.selectedSegmentIndex);
	switch (sender.selectedSegmentIndex) {


		case 0: {

			[self newType:MMSearchTypeAll];
			break;

		}
		case 1: {
			[self newType:MMSearchTypeNormal];

			break;


		}
		case 2: {

			[self newType:MMSearchTypeAwesome];
			break;
		}

		default:
			break;
	}
}

- (void)newType:(MMSearchType)type {

	if (type) {
		NSLog(@"This is the %d", type);
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
//					[self.data addObject:entity.gifURL];
					[self.data addObject:entity];
					NSLog(@"%@", entity);
					break;
				}
				case MMSearchTypeNormal: {

					if ([entity.gifCategory isEqualToString:@"Normal"]) {
//						[self.data addObject:entity.gifURL];
						[self.data addObject:entity];
					}
					break;
				}
				case MMSearchTypeAwesome: {
					if ([entity.gifCategory isEqualToString:@"Awesome"]) {
//						[self.data addObject:entity.gifURL];
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

	NSLog(@"%u", self.data.count);
	return self.data ? self.data.count : 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

	return CGSizeMake((CGFloat) (self.view.frame.size.width / 3 - 4), (CGFloat) (self.view.frame.size.width / 3 - 4));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

	MMKeyboardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MMKeyboardCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
	[cell setBackgroundColor:[UIColor clearColor]];

	[cell setData:[self.data valueForKey:@"gifURL"][(NSUInteger) indexPath.row]];

	return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {


	NSUInteger item = (NSUInteger) indexPath.item;
	MMKeyboardCollectionViewCell *cell = (MMKeyboardCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
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
