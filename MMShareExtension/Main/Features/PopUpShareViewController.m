//
//  PopUpShareViewController.m
//  MMCustomKeyboard
//
//  Created by mm0030240 on 23/10/15.
//  Copyright © 2015 mm0030240. All rights reserved.
//

#import "PopUpShareViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface PopUpShareViewController ()

@end

@implementation PopUpShareViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]
																		   initWithTarget:self action:@selector(userSwiped:)];

	swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;

	[self.view addGestureRecognizer:swipeRecognizer];
	// Do any additional setup after loading the view.
}

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems
{
	UIPreviewAction *shareGif = [UIPreviewAction actionWithTitle:@"Copy GIF" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction *_Nonnull action, UIViewController *_Nonnull previewViewController)
	{
		NSData *data = [NSData dataWithContentsOfURL:self.url];
		[[UIPasteboard generalPasteboard] setData:data forPasteboardType:(NSString *)kUTTypeGIF];
	}];

	UIPreviewAction *shareUrl = [UIPreviewAction actionWithTitle:@"Copy URL" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction *_Nonnull action, UIViewController *_Nonnull previewViewController)
	{
		[[UIPasteboard generalPasteboard] setURL:self.url];
	}];

	UIPreviewAction *deleteGif = [UIPreviewAction actionWithTitle:@"Delete Gif" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction *_Nonnull action, UIViewController *_Nonnull previewViewController)
	{

	}];

	return @[shareGif, shareUrl, deleteGif];
}

//Action method
- (void)userSwiped:(UIGestureRecognizer *)sender
{
	NSLog(@"did come here");
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}



@end
