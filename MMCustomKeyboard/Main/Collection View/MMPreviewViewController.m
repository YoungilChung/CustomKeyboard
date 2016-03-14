//
// Created by Tom Atterton on 14/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMPreviewViewController.h"
#import "FLAnimatedImageView.h"
#import "CoreDataStack.h"
#import "GIFEntity.h"
#import "FLAnimatedImage.h"


@interface MMPreviewViewController ()
@property(nonatomic, assign) FLAnimatedImage *animatedImage;
@property(nonatomic, strong) GIFEntity *gifEntity;

@end

@implementation MMPreviewViewController

- (instancetype)initWithAnimatedImage:(FLAnimatedImage *)animatedImage withGifEntity:(GIFEntity *)gifEntity {

	self = [super init];

	if (self) {

		self.animatedImage = animatedImage;
		self.gifEntity = gifEntity;

		[self setup];
	}

	return self;
}


- (void)setup {

	UIVisualEffect *blurEffect;
	blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
	UIVisualEffectView *visualEffectView;
	visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
	[visualEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.view addSubview:visualEffectView];

	self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];

	NSLog(@"This is the entity%@", self.gifEntity);
	UIView *holderView = [UIView new];
	holderView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:holderView];

	FLAnimatedImageView *animatedImageView = [FLAnimatedImageView new];
	animatedImageView.translatesAutoresizingMaskIntoConstraints = NO;
	animatedImageView.clipsToBounds = YES;
	animatedImageView.animatedImage = self.animatedImage;
	[animatedImageView setContentCompressionResistancePriority:500 forAxis:UILayoutConstraintAxisHorizontal];
	animatedImageView.contentMode = UIViewContentModeScaleAspectFill;
	[holderView addSubview:animatedImageView];


	UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	closeButton.translatesAutoresizingMaskIntoConstraints = NO;
	[closeButton setImage:[UIImage imageNamed:@"CloseIcon"] forState:UIControlStateNormal];
	[closeButton setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
	[closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:closeButton];


	UIButton *normalButton = [UIButton buttonWithType:UIButtonTypeCustom];
	normalButton.translatesAutoresizingMaskIntoConstraints = NO;
	[normalButton setTitle:@"Normal" forState:UIControlStateNormal];
	normalButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
	[normalButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	normalButton.layer.cornerRadius = 10;
	[normalButton addTarget:self action:@selector(normalButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[holderView addSubview:normalButton];

	UIButton *awesomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	awesomeButton.translatesAutoresizingMaskIntoConstraints = NO;
	[awesomeButton setTitle:@"Awesome" forState:UIControlStateNormal];
	awesomeButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
	[awesomeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	awesomeButton.layer.cornerRadius = 10;
	[awesomeButton addTarget:self action:@selector(awesomeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[holderView addSubview:awesomeButton];

	UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
	deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
	[deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
	[deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	deleteButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
	deleteButton.layer.cornerRadius = 10;
	[deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[holderView addSubview:deleteButton];

	NSDictionary *views = @{@"holder" : holderView, @"imageView" : animatedImageView, @"normalBtn" : normalButton, @"awesomeBtn" : awesomeButton, @"deleteBtn" : deleteButton, @"close" : closeButton};
	NSDictionary *metrics = @{@"padding" : @(10), @"paddingTop" : @30.0f, @"imageWidth" : @(normalButton.intrinsicContentSize.width)};

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-paddingTop-[close]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[close]-padding-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:holderView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-30]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:holderView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:visualEffectView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:visualEffectView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-36-[holder]-36-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[normalBtn]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[awesomeBtn]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[deleteBtn]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView(==250)]-5-[normalBtn(==deleteBtn)]-5-[awesomeBtn(==normalBtn)]-5-[deleteBtn(==normalBtn)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

}


#pragma mark Actions

- (void)deleteButtonPressed:(UIButton *)sender {

	if (self.gifEntity) {
		//TODO are you sure you want to delete
		CoreDataStack *coreData = [CoreDataStack defaultStack];
		[[coreData managedObjectContext] deleteObject:self.gifEntity];
		[coreData saveContext];
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)awesomeButtonPressed:(UIButton *)sender {

	if (self.gifEntity) {
		[self addGifToNewCategory:@"Awesome"];
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)normalButtonPressed:(UIButton *)sender {

	if (self.gifEntity) {
		[self addGifToNewCategory:@"Normal"];
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)closeButtonPressed:(UIButton *)sender {

	[self dismissViewControllerAnimated:YES completion:nil];
}


- (void)addGifToNewCategory:(NSString *)category {

	CoreDataStack *coreData = [CoreDataStack defaultStack];
	GIFEntity *gifEntity = (GIFEntity *) [NSEntityDescription insertNewObjectForEntityForName:@"GIFEntity" inManagedObjectContext:coreData.managedObjectContext];
//		gifEntity.self.gifURL = self.holderArray[(NSUInteger) self.currentImageIndex];
	gifEntity.self.gifURL = self.gifEntity.gifURL;
	gifEntity.self.gifCategory = category;
	[[coreData managedObjectContext] deleteObject:self.gifEntity];
	[coreData saveContext];

}
@end