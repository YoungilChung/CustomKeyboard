//
//  ViewController.m
//  MMCustomKeyboard
//
//  Created by mm0030240 on 06/10/15.
//  Copyright © 2015 mm0030240. All rights reserved.
//

#import "ViewController.h"
#import "FLAnimatedImage.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet FLAnimatedImageView *GifImage;
@property (strong,nonatomic) FLAnimatedImage *image;
@property (strong, nonatomic) IBOutlet FLAnimatedImageView *gifImage;

@end

@implementation ViewController



-(void) viewWillAppear:(BOOL)animated
{

    [self loadGif];
    


}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.GifImage.userInteractionEnabled = true;

}

- (void)loadGif
{
    FLAnimatedImageView *extra = [[FLAnimatedImageView alloc] init];
    extra.contentMode = UIViewContentModeScaleAspectFill;
    extra.clipsToBounds = YES;
    //
    [self.GifImage addSubview:extra];
    ////
    extra.frame = CGRectMake(0.0, 0.0, 238, 123);
    //
    FLAnimatedImage * __block animatedImage2 = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url2 = [NSURL URLWithString:@"https://t.chzbgr.com/ThumbnailCache/contentCardAvatar/i.chzbgr.com/avatarstore/4709399/129387960678140011.gif"];
        NSData *data2 = [NSData dataWithContentsOfURL:url2];
        animatedImage2 = [FLAnimatedImage animatedImageWithGIFData:data2];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            extra.animatedImage = animatedImage2;
        
            self.image = animatedImage2;
        
        });
    
    });
    



}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == self.GifImage)
    {
        
        
        //add your code for image touch here
    }
    
}
- (IBAction)GifImage_Click:(id)sender
{



}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)shareButton_click:(id)sender {
    NSURL *url2 = [NSURL URLWithString:@"http://icons.iconarchive.com/icons/benjigarner/glassy-software/256/Azureus-icon.png"];
    NSData *data2 = [NSData dataWithContentsOfURL:url2];
//    NSArray *activityItems = @[[NSURL URLWithString:@"http://raphaelschaad.com/static/nyan.gif"], [FLAnimatedImage ];

    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.textView.text]
                                                                             applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
    
    
    
    
}

@end
