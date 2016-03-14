//
//  PopUpViewController.m
//  MMCustomKeyboard
//
//  Created by mm0030240 on 22/10/15.
//  Copyright © 2015 mm0030240. All rights reserved.
//

#import "PopUpViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface PopUpViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *photo;

@end

@implementation PopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (NSArray<id<UIPreviewActionItem>> *)previewActionItems
{
    UIPreviewAction *shareGif = [UIPreviewAction actionWithTitle:@"Share Gif" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSData *data = [NSData dataWithContentsOfURL:self.url];
        [[UIPasteboard generalPasteboard] setData:data forPasteboardType:(NSString *)kUTTypeGIF];
    }];
    
    UIPreviewAction *shareUrl = [UIPreviewAction actionWithTitle:@"Share URL" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        [[UIPasteboard generalPasteboard] setURL:self.url];
    }];
    
    UIPreviewAction *deleteGif = [UIPreviewAction actionWithTitle:@"Delete Gif" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
    }];
    

    
    return @[shareGif , shareUrl, deleteGif];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
