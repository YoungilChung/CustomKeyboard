//
// Created by Tom Atterton on 14/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMPreviewViewController.h"
#import "FLAnimatedImageView.h"
#import "CoreDataStack.h"
#import "GIFEntity.h"
#import "FLAnimatedImage.h"
#import "UIImage+Vector.h"

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


	UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	closeButton.translatesAutoresizingMaskIntoConstraints = NO;
	[closeButton setImage:[UIImage imageWithPDFNamed:@"icon-close" withTintColor:[UIColor whiteColor] forHeight:20] forState:UIControlStateNormal];
	[closeButton setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
	[closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:closeButton];

	UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
	deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
	[deleteButton setImage:[UIImage imageWithPDFNamed:@"icon-delete" withTintColor:[UIColor whiteColor] forHeight:25] forState:UIControlStateNormal];
	[deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[deleteButton setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
	[self.view addSubview:deleteButton];



	UIView *holderView = [UIView new];
	holderView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:holderView];

	FLAnimatedImageView *animatedImageView = [FLAnimatedImageView new];
	animatedImageView.translatesAutoresizingMaskIntoConstraints = NO;
	animatedImageView.clipsToBounds = YES;
	animatedImageView.animatedImage = self.animatedImage;
	[animatedImageView setContentCompressionResistancePriority:500 forAxis:UILayoutConstraintAxisHorizontal];
	[animatedImageView setContentCompressionResistancePriority:300 forAxis:UILayoutConstraintAxisVertical];
	animatedImageView.contentMode = UIViewContentModeScaleAspectFill;
	[holderView addSubview:animatedImageView];

	UILabel *titleLabel = [UILabel new];
	titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.textAlignment = NSTextAlignmentCenter;
	titleLabel.numberOfLines = 0;
	[titleLabel setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
	[titleLabel setText:NSLocalizedString(@"PreviewViewController.Title.Label", nil)];
	[titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-MediumItalic" size:21]];
	[holderView addSubview:titleLabel];

	UIButton *normalButton = [UIButton buttonWithType:UIButtonTypeCustom];
	normalButton.translatesAutoresizingMaskIntoConstraints = NO;
	[normalButton setTitle:@"Normal" forState:UIControlStateNormal];
	normalButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
	[normalButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[normalButton setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];

	normalButton.layer.cornerRadius = 10;
	[normalButton addTarget:self action:@selector(normalButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[holderView addSubview:normalButton];

	UIButton *awesomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	awesomeButton.translatesAutoresizingMaskIntoConstraints = NO;
	[awesomeButton setTitle:@"Awesome" forState:UIControlStateNormal];
	awesomeButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
	[awesomeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[awesomeButton setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
	awesomeButton.layer.cornerRadius = 10;
	[awesomeButton addTarget:self action:@selector(awesomeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[holderView addSubview:awesomeButton];


	NSDictionary *views = @{@"holder" : holderView, @"imageView" : animatedImageView, @"normalBtn" : normalButton, @"awesomeBtn" : awesomeButton, @"deleteBtn" : deleteButton, @"close" : closeButton, @"title": titleLabel};
	NSDictionary *metrics = @{@"padding" : @(15), @"paddingTop" : @30.0f, @"imageWidth" : @(normalButton.intrinsicContentSize.width)};

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-paddingTop-[close]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-paddingTop-[deleteBtn]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[deleteBtn]-(>=0)-[close]-padding-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];


	NSLayoutConstraint *centerConstraint = [NSLayoutConstraint constraintWithItem:holderView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-30];
	[centerConstraint setPriority:890];
	[self.view addConstraint:centerConstraint];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:holderView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:visualEffectView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:visualEffectView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:holderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:closeButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-36-[holder]-36-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[normalBtn]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[awesomeBtn]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[title]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView(==250)]-10-[title]-15-[normalBtn(==awesomeBtn)]-5-[awesomeBtn(==normalBtn)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

}


#pragma mark Actions

- (void)deleteButtonPressed:(UIButton *)sender {


	UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"You sure you wanna delete this pretty gif?" preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
	{

	}]];
	[alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
	{
		if (self.gifEntity) {
			//TODO are you sure you want to delete
			CoreDataStack *coreData = [CoreDataStack defaultStack];
			[[coreData managedObjectContext] deleteObject:self.gifEntity];
			[coreData saveContext];
		}
		[self dismissViewControllerAnimated:YES completion:^{

			[[NSNotificationCenter defaultCenter] postNotificationName:@"reloadGIFS" object:nil];

		}];
	}]];
	[self presentViewController:alert animated:YES completion:nil];


}

- (void)awesomeButtonPressed:(UIButton *)sender {

	if (self.gifEntity) {
		[self addGifToNewCategory:@"Awesome"];
	}
	[self dismissViewControllerAnimated:YES completion:^{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"reloadGIFS" object:nil];

	}];
}

- (void)normalButtonPressed:(UIButton *)sender {

	if (self.gifEntity) {
		[self addGifToNewCategory:@"Normal"];
	}
	[self dismissViewControllerAnimated:YES completion:^{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"reloadGIFS" object:nil];

	}];
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