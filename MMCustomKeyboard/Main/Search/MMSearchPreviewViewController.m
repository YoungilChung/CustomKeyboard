//
// Created by Tom Atterton on 11/05/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import <FLAnimatedImage/FLAnimatedImage.h>
#import "MMSearchPreviewViewController.h"
#import "UIImage+Vector.h"
#import "CoreDataStack.h"
#import "GIFEntity.h"
#import <MobileCoreServices/UTCoreTypes.h>


@interface MMSearchPreviewViewController ()

//Views
@property (nonatomic, strong) UIView *chooseCategoryView;
//Variables

@property (nonatomic, assign) FLAnimatedImage *animatedImage;
@property (nonatomic, assign) NSString *urlString;


@end

@implementation MMSearchPreviewViewController


- (instancetype)initWithAnimatedImage:(FLAnimatedImage *)animatedImage withURL:(NSString *)urlString
{
	self = [super init];

	if (self)
	{

		self.animatedImage = animatedImage;
		self.urlString = urlString;

		[self setup];
	}

	return self;

}

- (void)setup
{

	UIVisualEffect *blurEffect;
	blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
	UIVisualEffectView *visualEffectView;
	visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
	[visualEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.view addSubview:visualEffectView];

//	self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
	self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.2 blue:0.5 alpha:0.7];

	UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	closeButton.translatesAutoresizingMaskIntoConstraints = NO;
	[closeButton setImage:[UIImage imageWithPDFNamed:@"icon-close" withTintColor:[UIColor whiteColor] forHeight:20] forState:UIControlStateNormal];
	[closeButton setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
	[closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:closeButton];

	UIView *holderView = [UIView new];
	holderView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:holderView];

	FLAnimatedImageView *animatedImageView = [FLAnimatedImageView new];
	animatedImageView.translatesAutoresizingMaskIntoConstraints = NO;
	animatedImageView.clipsToBounds = YES;
	animatedImageView.animatedImage = self.animatedImage;
	[animatedImageView setContentCompressionResistancePriority:500 forAxis:UILayoutConstraintAxisHorizontal];
	[animatedImageView setContentCompressionResistancePriority:300 forAxis:UILayoutConstraintAxisVertical];
	animatedImageView.contentMode = UIViewContentModeScaleAspectFit;
	[holderView addSubview:animatedImageView];

//	UILabel *titleLabel = [UILabel new];
//	titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
//	titleLabel.textColor = [UIColor whiteColor];
//	titleLabel.textAlignment = NSTextAlignmentCenter;
//	titleLabel.numberOfLines = 0;
//	[titleLabel setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
//	[titleLabel setText:NSLocalizedString(@"PreviewViewController.Title.Label", nil)];
//	[titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-MediumItalic" size:21]];
//	[holderView addSubview:titleLabel];


	UIView *topHolderView = [UIView new];
	topHolderView.backgroundColor = [UIColor clearColor];
	topHolderView.clipsToBounds = YES;
	topHolderView.translatesAutoresizingMaskIntoConstraints = NO;
	[holderView addSubview:topHolderView];

	UIView *bottomHolderView = [UIView new];
	bottomHolderView.backgroundColor = [UIColor clearColor];
	bottomHolderView.translatesAutoresizingMaskIntoConstraints = NO;
	bottomHolderView.clipsToBounds = YES;
	[holderView addSubview:bottomHolderView];

	UILabel *shareLabel = [UILabel new];
	shareLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[shareLabel setText:@"Share this is GIF"];
	[shareLabel setTextAlignment:NSTextAlignmentCenter];
	[shareLabel setTextColor:[UIColor whiteColor]];
	[shareLabel setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
	[holderView addSubview:shareLabel];

	UILabel *saveGIFLabel = [UILabel new];
	saveGIFLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[saveGIFLabel setText:@"Save this GIF"];
	[saveGIFLabel setTextAlignment:NSTextAlignmentCenter];
	[saveGIFLabel setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
	[saveGIFLabel setTextColor:[UIColor whiteColor]];
	[holderView addSubview:saveGIFLabel];

	UILabel *copyGIFLabel = [UILabel new];
	copyGIFLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[copyGIFLabel setText:@"Copy this GIF"];
	[copyGIFLabel setTextAlignment:NSTextAlignmentCenter];
	[copyGIFLabel setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
	[copyGIFLabel setTextColor:[UIColor whiteColor]];
	[holderView addSubview:copyGIFLabel];

	UIButton *hipchatButton = [UIButton buttonWithType:UIButtonTypeCustom];
	hipchatButton.translatesAutoresizingMaskIntoConstraints = NO;
	[hipchatButton setImage:[UIImage imageNamed:@"newHipchat"] forState:UIControlStateNormal];
	[hipchatButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
	hipchatButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
	[hipchatButton addTarget:self action:@selector(onHipchatTapped:) forControlEvents:UIControlEventTouchUpInside];
	[topHolderView addSubview:hipchatButton];

	UIButton *whatsAppButton = [UIButton buttonWithType:UIButtonTypeCustom];
	whatsAppButton.translatesAutoresizingMaskIntoConstraints = NO;
	[whatsAppButton setImage:[UIImage imageNamed:@"newWhatsAppIcon"] forState:UIControlStateNormal];
	whatsAppButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
	[whatsAppButton addTarget:self action:@selector(onWhatsAppTapped:) forControlEvents:UIControlEventTouchUpInside];
	[topHolderView addSubview:whatsAppButton];

	UIButton *facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
	facebookButton.translatesAutoresizingMaskIntoConstraints = NO;
	[facebookButton setImage:[UIImage imageNamed:@"newFacebook"] forState:UIControlStateNormal];
	facebookButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
	[facebookButton addTarget:self action:@selector(onFacebookTapped:) forControlEvents:UIControlEventTouchUpInside];
	[topHolderView addSubview:facebookButton];


	UIButton *sendGifButton = [UIButton new];
	sendGifButton.translatesAutoresizingMaskIntoConstraints = NO;
	[sendGifButton setImage:[UIImage imageNamed:@"downloadIcon"] forState:UIControlStateNormal];
	sendGifButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
	[sendGifButton addTarget:self action:@selector(onGifTapped:) forControlEvents:UIControlEventTouchUpInside];
	[bottomHolderView addSubview:sendGifButton];

	UIButton *sendUrlButton = [UIButton new];
	[sendUrlButton setClipsToBounds:YES];
	sendUrlButton.translatesAutoresizingMaskIntoConstraints = NO;
	[sendUrlButton setImage:[UIImage imageNamed:@"copyFileIcon"] forState:UIControlStateNormal];
	sendUrlButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
	[sendUrlButton addTarget:self action:@selector(onUrlTapped:) forControlEvents:UIControlEventTouchUpInside];
	[bottomHolderView addSubview:sendUrlButton];


	NSDictionary *views = @{@"holder" : holderView, @"imageView" : animatedImageView,
			@"shareLabel" : shareLabel, @"saveLabel" : saveGIFLabel, @"copyLabel" : copyGIFLabel,
			@"topHolder" : topHolderView, @"bottomHolder" : bottomHolderView,
			@"facebookBtn" : facebookButton, @"hipchatBtn" : hipchatButton, @"whatsAppBtn" : whatsAppButton, @"saveGif" : sendGifButton, @"sendUrl" : sendUrlButton, @"close" : closeButton};
	NSDictionary *metrics = @{@"padding" : @(15), @"paddingTop" : @30.0f};

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-paddingTop-[close]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[close]-padding-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];


	NSLayoutConstraint *centerConstraint = [NSLayoutConstraint constraintWithItem:holderView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-30];
	[centerConstraint setPriority:890];
	[self.view addConstraint:centerConstraint];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:visualEffectView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:visualEffectView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:holderView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:holderView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10];
	[constraint setPriority:900];
	[self.view addConstraint:constraint];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:holderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:closeButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20]];

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-36-[holder]-36-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	[bottomHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[saveGif]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[bottomHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[sendUrl]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[bottomHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[saveGif(sendUrl)]-5-[sendUrl(saveGif)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	[topHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[facebookBtn]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[topHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[hipchatBtn]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[topHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[whatsAppBtn]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[topHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[facebookBtn(hipchatBtn)]-10-[whatsAppBtn(facebookBtn)]-10-[hipchatBtn(facebookBtn)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	[holderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[topHolder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bottomHolder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[shareLabel]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
//	[holderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[saveLabel]-5-[copyLabel]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holderView addConstraint:[NSLayoutConstraint constraintWithItem:saveGIFLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:sendGifButton attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
	[holderView addConstraint:[NSLayoutConstraint constraintWithItem:copyGIFLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:sendUrlButton attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
	[holderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView(230)]-(15)-[shareLabel]-5-[topHolder(>=50)]-10-[bottomHolder(topHolder)]-5-[saveLabel]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView(230)]-(15)-[shareLabel]-5-[topHolder(>=50)]-10-[bottomHolder(topHolder)]-5-[copyLabel]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

}

#pragma mark Actions


- (void)onFacebookTapped:(UIButton *)sender
{

	NSURL *url = [[NSURL alloc] initWithString:self.urlString];
	NSData *data = [NSData dataWithContentsOfURL:url];
	[[UIPasteboard generalPasteboard] setData:data forPasteboardType:(NSString *)kUTTypeGIF];

	NSURL *facebookURL = [NSURL URLWithString:@"fb-messenger://compose"];
	[self toApp:facebookURL];

}

- (void)onWhatsAppTapped:(UIButton *)sender
{

	NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@", self.urlString]];
	[self toApp:whatsappURL];
}

- (void)onHipchatTapped:(UIButton *)sender
{

	NSURL *url = [[NSURL alloc] initWithString:self.urlString];
	[[UIPasteboard generalPasteboard] setURL:url];

	NSURL *hipChatURL = [NSURL URLWithString:[NSString stringWithFormat:@"hipchat://send?text=%@", self.urlString]];
	[self toApp:hipChatURL];
}

- (void)onUrlTapped:(UIButton *)sender
{

	NSURL *url = [[NSURL alloc] initWithString:self.urlString];
	[[UIPasteboard generalPasteboard] setURL:url];
}


- (void)closeButtonPressed:(UIButton *)sender
{

	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Gif Save Method

- (void)onGifTapped:(UIButton *)sender
{


	self.chooseCategoryView = [UIView new];
	self.chooseCategoryView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.chooseCategoryView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];
	[self.view addSubview:self.chooseCategoryView];

	UILabel *titleLabel = [UILabel new];
	titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[titleLabel setText:@"Choose which category to save the GIF"];
	[titleLabel setTextColor:[UIColor whiteColor]];
	[titleLabel setTextAlignment:NSTextAlignmentCenter];
	[self.chooseCategoryView addSubview:titleLabel];

	UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	closeButton.translatesAutoresizingMaskIntoConstraints = NO;
	[closeButton setImage:[UIImage imageWithPDFNamed:@"icon-close" withTintColor:[UIColor whiteColor] forHeight:20] forState:UIControlStateNormal];
	closeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
	[closeButton addTarget:self action:@selector(onCloseTappedCategories:) forControlEvents:UIControlEventTouchUpInside];
	[self.chooseCategoryView addSubview:closeButton];

	UIView *holder = [UIView new];
	holder.translatesAutoresizingMaskIntoConstraints = NO;
	[holder setClipsToBounds:YES];
	holder.backgroundColor = [UIColor clearColor];
	[self.chooseCategoryView addSubview:holder];

	UIButton *foodButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[foodButton setClipsToBounds:YES];
	foodButton.translatesAutoresizingMaskIntoConstraints = NO;
	[foodButton setTitle:@"Normal" forState:UIControlStateNormal];
//	[foodButton setImage:[UIImage imageNamed:@"foodIcon"] forState:UIControlStateNormal];
//	[foodButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
	[foodButton addTarget:self action:@selector(foodButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[holder addSubview:foodButton];

	UIButton *awesomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[awesomeButton setClipsToBounds:YES];
	awesomeButton.translatesAutoresizingMaskIntoConstraints = NO;
	[awesomeButton setTitle:@"Awesome" forState:UIControlStateNormal];
//	[awesomeButton setImage:[UIImage imageNamed:@"awesomeIcon"] forState:UIControlStateNormal];
//	[awesomeButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
	[awesomeButton addTarget:self action:@selector(awesomeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[holder addSubview:awesomeButton];


	NSDictionary *views = @{@"chooseView" : self.chooseCategoryView, @"foodButton" : foodButton, @"awesomeButton" : awesomeButton, @"titleLabel" : titleLabel, @"close" : closeButton, @"holder" : holder};
	NSDictionary *metrics = @{};

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[chooseView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chooseView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];


	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[foodButton(250)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[awesomeButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[foodButton(==awesomeButton)]-10-[awesomeButton(foodButton)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	[self.chooseCategoryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(30)-[close]-20-[titleLabel]-(20)-[holder(250)]-(>=20)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.chooseCategoryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(30)-[close]-20-[titleLabel]-(20)-[holder(250)]-(>=20)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.chooseCategoryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[titleLabel]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.chooseCategoryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[holder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self.chooseCategoryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[close]-15-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

}


- (void)onCloseTappedCategories:(UIButton *)sender
{
	[self.chooseCategoryView removeFromSuperview];
}

- (void)awesomeButtonTapped:(UIButton *)sender
{
	dispatch_async(dispatch_get_main_queue(), ^
	{
		//Update UI
		CoreDataStack *coreData = [CoreDataStack defaultStack];
		GIFEntity *gifEntity = [NSEntityDescription insertNewObjectForEntityForName:@"GIFEntity" inManagedObjectContext:coreData.managedObjectContext];
		gifEntity.self.gifURL = self.urlString;
		gifEntity.self.gifCategory = @"Awesome";
		[coreData saveContext];
		[self onCloseTappedCategories:sender];

	});
}

- (void)foodButtonTapped:(UIButton *)sender
{
	dispatch_async(dispatch_get_main_queue(), ^
	{
		//Update UI
		CoreDataStack *coreData = [CoreDataStack defaultStack];
		GIFEntity *gifEntity = [NSEntityDescription insertNewObjectForEntityForName:@"GIFEntity" inManagedObjectContext:coreData.managedObjectContext];
		gifEntity.self.gifURL = self.urlString;
		gifEntity.self.gifCategory = @"Normal";
		[coreData saveContext];
		[self onCloseTappedCategories:sender];
	});
}


#pragma  mark Helper

- (void)toApp:(NSURL *)url
{
	UIResponder *responder = self;
	while ((responder = [responder nextResponder]) != nil)
	{
		//		if ([responder respondsToSelector:@selector(openURL)])
		if ([responder respondsToSelector:@selector(openURL:)])
		{
			[responder performSelector:@selector(openURL:) withObject:url];
		}
	}
}

@end