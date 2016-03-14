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

@interface MMViewController () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate>

@property(strong, nonatomic) FLAnimatedImage *image;
@property(strong, nonatomic) UICollectionView *collectionView;
@property(strong, nonatomic) UICollectionViewFlowLayout *collectionFlowLayout;
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, strong) NSMutableDictionary *gifHolder;
@property(nonatomic, strong) NSMutableArray *holderArray;
@property(nonatomic, strong) NSMutableArray *allUrlHolderArray;
@property(nonatomic, strong) NSMutableArray *normalUrlHolderArray;
@property(nonatomic, strong) NSMutableArray *awesomeUrlHolderArray;
@property(nonatomic, strong) UIView *holderView;
@property(nonatomic, strong) UIView *tempHolderView;
@property(strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property(nonatomic) NSString *gifCategory;
@property(nonatomic) NSString *searchKey;
@property(nonatomic) NSInteger currentImageIndex;
@property(nonatomic) NSInteger collectionAmount;
@property(nonatomic) NSIndexPath *currentImageIndexPath;
@property(nonatomic, strong) GIFEntity *tempEntity;
@property(nonatomic, strong) MMCollectionViewFlowLayout *flowLayout;

@end

@implementation MMViewController

- (void)viewWillAppear:(BOOL)animated {
	[self loadGif];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.gifHolder = [@{} mutableCopy];

	// Do any additional setup after loading the view, typically from a nib.
	[self.fetchedResultsController performFetch:nil];
	self.gifCategory = @"All";

	self.flowLayout = [MMCollectionViewFlowLayout new];
	[self.flowLayout setMinimumInteritemSpacing:0];
	[self.flowLayout setMinimumLineSpacing:0];
	self.flowLayout.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

	self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
	[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
	self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	self.collectionView.backgroundColor = [UIColor blackColor];
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	[self.view addSubview:self.collectionView];

	NSDictionary *views = @{@"collection" : self.collectionView, @"topGuide" : self.topLayoutGuide};
	NSDictionary *metrics = @{@"padding" : @(10)};
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collection]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collection]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

}

#pragma mark Actions

- (IBAction)segmentController_Tapped:(id)sender {

	switch (self.segmentControl.selectedSegmentIndex) {
		case 0:
			//All
			self.gifCategory = @"All";
			self.searchKey = @"gifURL";
			[self.fetchedResultsController performFetch:nil];
			[self loadGif];
			break;
		case 1:
			//Normal
			self.gifCategory = @"Normal";
			self.searchKey = @"gifCategory";
			[self.fetchedResultsController performFetch:nil];
			[self loadGif];
			break;
		case 2:
			//Awesome
			self.gifCategory = @"Awesome";
			self.searchKey = @"gifCategory";
			[self.fetchedResultsController performFetch:nil];
			[self loadGif];
			break;

		default:
			break;
	}
}


#pragma mark Methods

- (void)loadGif {
	[self.fetchedResultsController performFetch:nil];
	//	self.collectionView.scrollEnabled = YES;
	self.holderArray = [@[] mutableCopy];
	NSArray *tempArray = [[self.fetchedResultsController fetchedObjects] valueForKey:@"gifCategory"];

	if (tempArray.count == 0) {
		NSLog(@"Empty");
	}
	else {
		if ([self.searchKey isEqualToString:@"gifCategory"]) {
			[self.fetchedResultsController.fetchedObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				if ([self.gifCategory isEqualToString:@"Normal"]) {
					if ([[obj valueForKey:@"gifCategory"] isEqualToString:@"Normal"]) {
						//						[self.urlHolderArray addObject:[obj valueForKey:@"gifURL"]];
						[self.holderArray addObject:[obj valueForKey:@"gifURL"]];
						//						self.holderArray = self.normalUrlHolderArray;
					}
				}
				if ([self.gifCategory isEqualToString:@"Awesome"]) {
					if ([[obj valueForKey:@"gifCategory"] isEqualToString:@"Awesome"]) {
						//						[self.urlHolderArray addObject:[obj valueForKey:@"gifURL"]];
						[self.holderArray addObject:[obj valueForKey:@"gifURL"]];
						//						self.holderArray = self.awesomeUrlHolderArray;
					}
				}
			}];
		}
		else {
			tempArray = [[self.fetchedResultsController fetchedObjects] valueForKey:@"gifURL"];
			self.allUrlHolderArray = [tempArray mutableCopy];
			self.holderArray = self.allUrlHolderArray;
		}
	}

	[self.collectionView reloadData];
	[self.collectionView.collectionViewLayout invalidateLayout];
}

- (FLAnimatedImageView *)setupGifImageView {
	FLAnimatedImageView *imageView = [FLAnimatedImageView new];
	imageView.translatesAutoresizingMaskIntoConstraints = NO;
	imageView.contentMode = UIViewContentModeScaleAspectFill;
	imageView.clipsToBounds = YES;
	imageView.backgroundColor = [UIColor blackColor];
	return imageView;
}

- (void)loadGifItem:(NSUInteger)item callback:(void (^)(FLAnimatedImage *image))callback {
	if (item < self.holderArray.count) {
		NSURL *url = [[NSURL alloc] initWithString:self.holderArray[item]];
		NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

		[NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
			FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
			callback(image);
		}];
	}
}

#pragma mark Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

	return self.holderArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return CGSizeMake(self.collectionView.layer.frame.size.width / 3, self.collectionView.layer.frame.size.width / 3);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
	FLAnimatedImageView *imageView = [self setupGifImageView];
	[cell setBackgroundView:imageView];
	NSUInteger item = (NSUInteger) indexPath.item;
	FLAnimatedImage *image = self.gifHolder[self.holderArray[item]];

	if (image) {
		[((FLAnimatedImageView *) cell.backgroundView) setAnimatedImage:image];
		return cell;
	}
	[self loadGifItem:item callback:^(FLAnimatedImage *tempImage) {
		[self.gifHolder setValue:tempImage forKey:self.holderArray[item]];

		[((FLAnimatedImageView *) cell.backgroundView) setAnimatedImage:tempImage];
	}];

	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

	NSUInteger item = (NSUInteger) indexPath.item;

	[self.fetchedResultsController.fetchedObjects enumerateObjectsUsingBlock:^(GIFEntity *obj, NSUInteger idx, BOOL *stop) {
		if ([[obj valueForKey:@"gifURL"] isEqualToString:self.holderArray[item]]) {
			MMPreviewViewController *viewController = [[MMPreviewViewController alloc] initWithAnimatedImage:(FLAnimatedImage *)self.gifHolder[self.holderArray[item]] withGifEntity:obj];
			viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
			[self presentViewController:viewController animated:YES completion:nil];
		}
	}];

}

#pragma  mark - NSFetchedResultController

- (NSFetchRequest *)entryListFetchRequest {
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"GIFEntity"];
	fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"gifURL" ascending:NO]]; // This will sort how the request is shown
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
