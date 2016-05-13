//
// Created by Tom Atterton on 16/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMGIFKeyboardCollectionViewCell.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"

@interface MMGIFKeyboardCollectionViewCell ()

@property (nonatomic, strong) UIActivityIndicatorView *indicator;


@end
@implementation MMGIFKeyboardCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];

	if (self)
	{
		[self setup];
	}

	return self;
}

- (void)setup
{
	[self setTranslatesAutoresizingMaskIntoConstraints:NO];

	self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[self.indicator setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.indicator setTintColor:[UIColor whiteColor]];
	[self.indicator startAnimating];
	[self addSubview:self.indicator];

	self.imageView = [FLAnimatedImageView new];
	self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
	self.imageView.contentMode = UIViewContentModeScaleAspectFill;
	self.imageView.clipsToBounds = YES;
	self.imageView.backgroundColor = [UIColor blackColor];
	[self addSubview:self.imageView];

	NSDictionary *metrics = @{};
	NSDictionary *views = @{
			@"imageView" : self.imageView,
	};

	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.indicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.indicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:kNilOptions metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]-0-|" options:kNilOptions metrics:metrics views:views]];

}


- (void)setData:(NSString *)urlString {
	self.imageView.alpha = 0.f;

//	dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue", NULL);
//	dispatch_async(imageQueue, ^{
		NSURL *url = [NSURL URLWithString:urlString];
		FLAnimatedImage *imageObject = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:url]];

		dispatch_async(dispatch_get_main_queue(), ^{
			// Update the UI
			[self.imageView setAnimatedImage:imageObject];
			self.imageView.alpha = 1.f;
		});

//	});
}

+ (NSString *)reuseIdentifier {
	return @"Cell";
}


@end