//
// Created by Tom Atterton on 15/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMKeyboardButtonView.h"
#import "UIImage+Vector.h"
#import "GIFEntity.h"
#import "CoreDataStack.h"
#import "FLAnimatedImageView.h"
#import <MobileCoreServices/UTCoreTypes.h>


@interface MMKeyboardButtonView ()
// Variables
@property(nonatomic, strong) NSDictionary *userInfo;
@property(nonatomic, strong) GIFEntity *entity;
@property(nonatomic, assign) CGRect keyboardFrame;
@end

@implementation MMKeyboardButtonView


- (instancetype)initWithFrame:(CGRect)frame WithEntity:(GIFEntity *)entity {
	self = [super init];
	if (self) {

		self.entity = entity;
		self.keyboardFrame = frame;
		[self setup];
	}
	return self;
}

- (void)setup {

	self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
	self.userInfo = @{};

	UIView *animatedImageViewHolder = [UIView new];
	animatedImageViewHolder.translatesAutoresizingMaskIntoConstraints = NO;
	animatedImageViewHolder.clipsToBounds = YES;
	[self addSubview:animatedImageViewHolder];

	self.animatedImageView = [FLAnimatedImageView new];
	self.animatedImageView.translatesAutoresizingMaskIntoConstraints = NO;
	self.animatedImageView.clipsToBounds = YES;
	[self.animatedImageView setContentCompressionResistancePriority:600 forAxis:UILayoutConstraintAxisVertical];
	self.animatedImageView.contentMode = UIViewContentModeScaleAspectFit;
	[animatedImageViewHolder addSubview:self.animatedImageView];

	UIView *scrollViewHolder = [UIView new];
	scrollViewHolder.translatesAutoresizingMaskIntoConstraints = NO;
	scrollViewHolder.clipsToBounds = YES;
	[self addSubview:scrollViewHolder];

	UIScrollView *buttonScrollView = [UIScrollView new];
	buttonScrollView.translatesAutoresizingMaskIntoConstraints = NO;
	[buttonScrollView showsHorizontalScrollIndicator];
	[scrollViewHolder addSubview:buttonScrollView];


	UIView *topHolderView = [UIView new];
	topHolderView.backgroundColor = [UIColor clearColor];
	topHolderView.clipsToBounds = YES;
	topHolderView.translatesAutoresizingMaskIntoConstraints = NO;
	[buttonScrollView addSubview:topHolderView];

	UIView *bottomHolderView = [UIView new];
	bottomHolderView.backgroundColor = [UIColor clearColor];
	bottomHolderView.translatesAutoresizingMaskIntoConstraints = NO;
	bottomHolderView.clipsToBounds = YES;
	[buttonScrollView addSubview:bottomHolderView];


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

	UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
	deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
	[deleteButton setImage:[UIImage imageWithPDFNamed:@"icon-delete" withTintColor:[UIColor whiteColor] forHeight:(self.keyboardFrame.size.height) / 3] forState:UIControlStateNormal];
	deleteButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
	[deleteButton addTarget:self action:@selector(onDeleteTapped:) forControlEvents:UIControlEventTouchUpInside];
	[bottomHolderView addSubview:deleteButton];

	UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	closeButton.translatesAutoresizingMaskIntoConstraints = NO;
	[closeButton setImage:[UIImage imageWithPDFNamed:@"icon-close" withTintColor:[UIColor whiteColor] forHeight:20] forState:UIControlStateNormal];
	closeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
	[closeButton addTarget:self action:@selector(onCloseTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:closeButton];

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

	NSDictionary *views = @{@"topHolder" : topHolderView, @"bottomHolder" : bottomHolderView, @"delete" : deleteButton, @"sendGif" : sendGifButton,
			@"sendUrl" : sendUrlButton, @"hipChatButton" : hipchatButton, @"facebookButton" : facebookButton, @"whatsAppButton" : whatsAppButton,
			@"close" : closeButton, @"animatedImageView" : self.animatedImageView, @"scrollView" : buttonScrollView, @"scrollViewHolder" : scrollViewHolder,
			@"animatedImageHolder" : animatedImageViewHolder,
	};

	NSDictionary *metrics = @{@"padding" : @(10), @"scrollViewHeight" : @(self.keyboardFrame.size.height / 3), @"pictureHeight" : @(self.keyboardFrame.size.height / 1.5)};


	[self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight
													 relatedBy:NSLayoutRelationEqual
														toItem:nil attribute:NSLayoutAttributeNotAnAttribute
													multiplier:1.0 constant:(self.keyboardFrame.size.height)]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth
													 relatedBy:NSLayoutRelationEqual
														toItem:nil attribute:NSLayoutAttributeNotAnAttribute
													multiplier:1.0 constant:self.keyboardFrame.size.width]];

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[close]-padding-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[animatedImageHolder]-40-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[scrollViewHolder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[close]-5-[animatedImageHolder(pictureHeight@500)]-0-[scrollViewHolder(scrollViewHeight)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	[animatedImageViewHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[animatedImageView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[animatedImageViewHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[animatedImageView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];


	[self addConstraint:[NSLayoutConstraint constraintWithItem:topHolderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:(CGFloat) (-self.keyboardFrame.size.width / 4.5)]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:bottomHolderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:(CGFloat) (-self.keyboardFrame.size.width / 4.5)]];

	[buttonScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[topHolder]-0-[bottomHolder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[buttonScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[topHolder(scrollViewHeight)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[buttonScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bottomHolder(scrollViewHeight)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];


	[scrollViewHolder addConstraint:[NSLayoutConstraint constraintWithItem:scrollViewHolder attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:buttonScrollView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
	[scrollViewHolder addConstraint:[NSLayoutConstraint constraintWithItem:scrollViewHolder attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:buttonScrollView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
	[scrollViewHolder addConstraint:[NSLayoutConstraint constraintWithItem:scrollViewHolder attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:buttonScrollView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
	[scrollViewHolder addConstraint:[NSLayoutConstraint constraintWithItem:scrollViewHolder attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:buttonScrollView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
	[scrollViewHolder addConstraint:[NSLayoutConstraint constraintWithItem:scrollViewHolder attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:buttonScrollView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];


	[topHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[hipChatButton(==facebookButton)]-5-[whatsAppButton(==hipChatButton)]-5-[facebookButton(==hipChatButton)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[bottomHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[sendGif(==delete)]-5-[sendUrl(==sendGif)]-5-[delete(==sendGif)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];


	[topHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[facebookButton]-15-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[topHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[hipChatButton]-15-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[topHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[whatsAppButton]-15-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];


	[bottomHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[delete]-15-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[bottomHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[sendGif]-15-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
	[bottomHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[sendUrl]-15-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

//	self.gifUrl = [self.entity valueForKeyPath:@"gifURL"];

}


#pragma mark Actions

- (void)onFacebookTapped:(UIButton *)sender {

	NSURL *url = [[NSURL alloc] initWithString:self.gifUrl];
	NSData *data = [NSData dataWithContentsOfURL:url];
	[[UIPasteboard generalPasteboard] setData:data forPasteboardType:(NSString *) kUTTypeGIF];

	NSURL *facebookURL = [NSURL URLWithString:@"fb-messenger://compose"];
	[self toApp:facebookURL];

}

- (void)onWhatsAppTapped:(UIButton *)sender {
	NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@", self.gifUrl]];
	[self toApp:whatsappURL];
}

- (void)onHipchatTapped:(UIButton *)sender {
	NSURL *url = [[NSURL alloc] initWithString:self.gifUrl];
	[[UIPasteboard generalPasteboard] setURL:url];

	NSURL *hipChatURL = [NSURL URLWithString:[NSString stringWithFormat:@"hipchat://send?text=%@", self.gifUrl]];
	[self toApp:hipChatURL];
}

- (void)onUrlTapped:(UIButton *)sender {
	NSURL *url = [[NSURL alloc] initWithString:self.gifUrl];
	[[UIPasteboard generalPasteboard] setURL:url];

	self.userInfo = @{@"iconPressed" : @"url saved"};
	[[NSNotificationCenter defaultCenter] postNotificationName:@"closeSubview" object:self userInfo:self.userInfo];

	self.hidden = YES;

}

- (void)onGifTapped:(UIButton *)sender {

	if (self.entity) {


		NSURL *url = [[NSURL alloc] initWithString:self.gifUrl];
		NSData *data = [NSData dataWithContentsOfURL:url];
		[[UIPasteboard generalPasteboard] setData:data forPasteboardType:(NSString *) kUTTypeGIF];
		self.userInfo = @{@"iconPressed" : @"gif copied"};
		[[NSNotificationCenter defaultCenter] postNotificationName:@"closeSubview" object:self userInfo:self.userInfo];
	}
	else {

		dispatch_async(dispatch_get_main_queue(), ^{
			//Update UI
			CoreDataStack *coreData = [CoreDataStack defaultStack];
			GIFEntity *gifEntity = [NSEntityDescription insertNewObjectForEntityForName:@"GIFEntity" inManagedObjectContext:coreData.managedObjectContext];
			gifEntity.self.gifURL = self.gifUrl;
			gifEntity.self.gifCategory = @"Awesome";
			[coreData saveContext];

		});

		self.userInfo = @{@"iconPressed" : @"gif saved"};
		[[NSNotificationCenter defaultCenter] postNotificationName:@"closeSubview" object:self userInfo:self.userInfo];
		self.hidden = YES;
	}


}

- (void)onCloseTapped:(UIButton *)sender {
	self.userInfo = @{@"iconPressed" : @"closed"};
	[[NSNotificationCenter defaultCenter] postNotificationName:@"closeSubview" object:self userInfo:self.userInfo];
	[self setHidden:YES];
}

- (void)onDeleteTapped:(UIButton *)sender {

	if (self.entity) {
		[self setHidden:YES];
		CoreDataStack *coreData = [CoreDataStack defaultStack];
		[[coreData managedObjectContext] deleteObject:self.entity];
		[coreData saveContext];
		self.userInfo = @{@"iconPressed" : @"deleted"};
		[[NSNotificationCenter defaultCenter] postNotificationName:@"closeSubview" object:self userInfo:self.userInfo];
	}
}


- (void)toApp:(NSURL *)url {
	UIResponder *responder = self;
	while ((responder = [responder nextResponder]) != nil) {
		//		if ([responder respondsToSelector:@selector(openURL)])
		if ([responder respondsToSelector:@selector(openURL:)]) {
			[responder performSelector:@selector(openURL:) withObject:url];
			self.userInfo = @{@"iconPressed" : @"messengers"};
			[[NSNotificationCenter defaultCenter] postNotificationName:@"closeSubview" object:self userInfo:self.userInfo];

		}
	}
}


@end