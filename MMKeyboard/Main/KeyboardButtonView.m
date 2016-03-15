//
// Created by Tom Atterton on 15/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "KeyboardButtonView.h"
#import "MMKeyboardButton.h"
#import "UIImage+Vector.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface KeyboardButtonView ()

@end

@implementation KeyboardButtonView


- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	if (self) {

		self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];

		UIView *topHolderView = [UIView new];
		topHolderView.backgroundColor = [UIColor clearColor];
		topHolderView.clipsToBounds = YES;
		topHolderView.translatesAutoresizingMaskIntoConstraints = NO;
		topHolderView.clipsToBounds = YES;
		[self addSubview:topHolderView];

		UIView *bottomHolderView = [UIView new];
		bottomHolderView.backgroundColor = [UIColor clearColor];
		bottomHolderView.translatesAutoresizingMaskIntoConstraints = NO;
		bottomHolderView.clipsToBounds = YES;
		[self addSubview:bottomHolderView];


		MMKeyboardButton *hipchatButton = [MMKeyboardButton buttonWithType:UIButtonTypeCustom];
		hipchatButton.translatesAutoresizingMaskIntoConstraints = NO;
		[hipchatButton setImage:[UIImage imageNamed:@"newHipchat"] forState:UIControlStateNormal];
		[hipchatButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
		hipchatButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
		[hipchatButton addTarget:self action:@selector(onHipchatTapped:) forControlEvents:UIControlEventTouchUpInside];
		[topHolderView addSubview:hipchatButton];

		MMKeyboardButton *whatsAppButton = [MMKeyboardButton buttonWithType:UIButtonTypeCustom];
		whatsAppButton.translatesAutoresizingMaskIntoConstraints = NO;
		[whatsAppButton setImage:[UIImage imageNamed:@"newWhatsAppIcon"] forState:UIControlStateNormal];
		whatsAppButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
		[whatsAppButton addTarget:self action:@selector(onWhatsAppTapped:) forControlEvents:UIControlEventTouchUpInside];
		[topHolderView addSubview:whatsAppButton];

		MMKeyboardButton *facebookButton = [MMKeyboardButton buttonWithType:UIButtonTypeCustom];
		facebookButton.translatesAutoresizingMaskIntoConstraints = NO;
		[facebookButton setImage:[UIImage imageNamed:@"newFacebook"] forState:UIControlStateNormal];
		facebookButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
		[facebookButton addTarget:self action:@selector(onFacebookTapped:) forControlEvents:UIControlEventTouchUpInside];
		[topHolderView addSubview:facebookButton];

		UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
		deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
		[deleteButton setImage:[UIImage imageWithPDFNamed:@"icon-delete" withTintColor:[UIColor whiteColor] forHeight:frame.size.height / 2] forState:UIControlStateNormal];
		deleteButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
		[deleteButton addTarget:self action:@selector(onCloseTapped:) forControlEvents:UIControlEventTouchUpInside];
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
		sendUrlButton.translatesAutoresizingMaskIntoConstraints = NO;
		[sendUrlButton setImage:[UIImage imageNamed:@"copyFileIcon"] forState:UIControlStateNormal];
		sendUrlButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
		[sendUrlButton addTarget:self action:@selector(onUrlTapped:) forControlEvents:UIControlEventTouchUpInside];
		[bottomHolderView addSubview:sendUrlButton];

		NSDictionary *views = @{@"topHolder" : topHolderView, @"bottomHolder" : bottomHolderView, @"delete" : deleteButton, @"sendGif" : sendGifButton,
				@"sendUrl" : sendUrlButton, @"hipChatButton" : hipchatButton, @"facebookButton" : facebookButton, @"whatsAppButton" : whatsAppButton,
				@"close" : closeButton,
//			@"holder": holderView
		};
		NSDictionary *metrics = @{@"padding" : @(10)};


		[self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight
														 relatedBy:NSLayoutRelationEqual
															toItem:nil attribute:NSLayoutAttributeNotAnAttribute
														multiplier:1.0 constant:frame.size.height]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth
														 relatedBy:NSLayoutRelationEqual
															toItem:nil attribute:NSLayoutAttributeNotAnAttribute
														multiplier:1.0 constant:frame.size.width]];

		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[close]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[close]-padding-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[topHolder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bottomHolder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[topHolder(==bottomHolder)]-0-[bottomHolder(==topHolder)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

		[topHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[hipChatButton(==facebookButton)]-5-[whatsAppButton(==hipChatButton)]-5-[facebookButton(==hipChatButton)]-20-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[bottomHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[delete(==sendUrl)]-5-[sendGif(==delete)]-5-[sendUrl(==delete)]-20-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];


		[topHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[facebookButton]-20-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[topHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[hipChatButton]-20-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[topHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[whatsAppButton]-20-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

		[bottomHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[delete]-20-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[bottomHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[sendGif]-20-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];
		[bottomHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[sendUrl]-20-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views]];

	}
	return self;
}


#pragma mark Actions

- (void)onFacebookTapped:(UIButton *)sender {

	//	[self loadMessage:@"GIF Copied!"];
	NSURL *url = [[NSURL alloc] initWithString:self.gifUrl];
	NSData *data = [NSData dataWithContentsOfURL:url];
	[[UIPasteboard generalPasteboard] setData:data forPasteboardType:(NSString *) kUTTypeGIF];
	NSURL *facebookURL = [NSURL URLWithString:@"fb-messenger://compose"];
	//    NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"fb-messenger://share?ShareType.forward&attachment=%@", self.urlHolderArray[self.longPressIndex.row]]];
	[self toApp:facebookURL];
}

- (void)onWhatsAppTapped:(UIButton *)sender {
	NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@", self.gifUrl]];
	[self toApp:whatsappURL];
}

- (void)onHipchatTapped:(UIButton *)sender {
	//	[self loadMessage:@"URL Copied!"]; // TODO implement
	NSURL *url = [[NSURL alloc] initWithString:self.gifUrl];
	[[UIPasteboard generalPasteboard] setURL:url];

	NSURL *hipChatURL = [NSURL URLWithString:[NSString stringWithFormat:@"hipchat://send?text=%@", self.gifUrl]];
	[self toApp:hipChatURL];
}

- (void)onUrlTapped:(UIButton *)sender {
//	[self loadMessage:@"URL Copied!"]; // TODO implement
	NSURL *url = [[NSURL alloc] initWithString:self.gifUrl];
	[[UIPasteboard generalPasteboard] setURL:url];
	NSDictionary* userInfo = @{@"iconPressed": @"url saved"};
	[[NSNotificationCenter defaultCenter] postNotificationName:@"closeSubview" object:self userInfo:userInfo];
	self.hidden = YES;

//	}];

}

- (void)onGifTapped:(UIButton *)sender {
//	[self loadMessage:@"GIF Copied!"]; //TODO implement
	NSURL *url = [[NSURL alloc] initWithString:self.gifUrl];
	NSData *data = [NSData dataWithContentsOfURL:url];
	[[UIPasteboard generalPasteboard] setData:data forPasteboardType:(NSString *) kUTTypeGIF];
	NSDictionary* userInfo = @{@"iconPressed": @"gif saved"};
	[[NSNotificationCenter defaultCenter] postNotificationName:@"closeSubview" object:self userInfo:userInfo];
	self.hidden = YES;


//	}];

}

- (void)onCloseTapped:(UIButton *)sender {

//	[self removeFromSuperview];
	self.hidden = YES;

	NSDictionary* userInfo = @{@"iconPressed": @"closed"};
	[[NSNotificationCenter defaultCenter] postNotificationName:@"closeSubview" object:self userInfo:userInfo];

//	}];
}

- (void)toApp:(NSURL *)url {
	UIResponder *responder = self;
	while ((responder = [responder nextResponder]) != nil) {
		//		if ([responder respondsToSelector:@selector(openURL)])
		if ([responder respondsToSelector:@selector(openURL:)]) {
//			[self loadMessage:@"GIF saved to pasteboard!"]; // TODO implement
			[responder performSelector:@selector(openURL:) withObject:url];
		}
	}
}
@end