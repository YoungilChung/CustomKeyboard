//
//  KeyboardViewController.m
//  MMKeyboard
//
//  Created by mm0030240 on 06/10/15.
//  Copyright © 2015 mm0030240. All rights reserved.
//

#import "KeyboardViewController.h"
#import "FLAnimatedImage.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface KeyboardViewController () <UIScrollViewDelegate>
{

    NSMutableArray *_picHolderArray;
    int _x;

}
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@property (nonatomic, strong) UIScrollView *keyboardBackground;
//@property (nonatomic, strong) FLAnimatedImageView *keyboardBackground;


@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
//    [super viewDidLoad];
//
    
    _x = 0;
    [super viewDidLoad];
    self.keyboardBackground.delegate = self;
    // Perform custom UI setup here
    self.keyboardBackground.backgroundColor = [UIColor blackColor];

    self.nextKeyboardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.nextKeyboardButton setTitle:NSLocalizedString(@"Next Keyboard", @"Title for 'Next Keyboard' button") forState:UIControlStateNormal];
    [self.nextKeyboardButton sizeToFit];
    self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.nextKeyboardButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.nextKeyboardButton];
    
    NSLayoutConstraint *nextKeyboardButtonLeftSideConstraint = [NSLayoutConstraint constraintWithItem:self.nextKeyboardButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    NSLayoutConstraint *nextKeyboardButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.nextKeyboardButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [self.view addConstraints:@[nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint]];
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    CGRect frame;
    
    if(UIDeviceOrientationIsLandscape(orientation))
        frame = CGRectMake(0, 0, 480, 162);
    else
        frame = CGRectMake(0, 0, 320, 216);
    
    self.keyboardBackground = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 400, 180)];
    
    
    
    _picHolderArray = [[NSMutableArray alloc]init];
    UIImage* backgroundImage =[[UIImage imageNamed:@"test"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(100, 0, 0, 0) ];
    UIGraphicsBeginImageContextWithOptions(self.keyboardBackground.bounds.size, NO, 0.0);
    [backgroundImage drawInRect:self.keyboardBackground.bounds];
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.keyboardBackground.backgroundColor = [UIColor blackColor];
    for (int i = 0; i < 20; i++) {


        FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(_x,0, 200 , 200 )];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;

        
        _x += imageView.frame.size.width + 10;
        [_picHolderArray addObject:imageView];
        [self.keyboardBackground addSubview:_picHolderArray[i]];


        ////
        //
        

        @try {
        FLAnimatedImage * __block animatedImage2 = nil;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
//            NSArray *urls = "http://raphaelschaad.com/static/nyan.gif";
//            for (NSURL *url in urls){
            NSURL *url2 = [NSURL URLWithString:@"http://raphaelschaad.com/static/nyan.gif"];
//            http://weknowyourdreams.com/images/duck/duck-05.jpg
//            NSData *data2 = [NSData dataWithContentsOfURL:url2];
            NSString *fileType = url2.pathExtension;
            
            
            dispatch_async(dispatch_get_main_queue(), ^{

            [SDWebImageDownloader.sharedDownloader downloadImageWithURL:url2
                                                                options:0
                                                               progress:^(NSInteger receivedSize, NSInteger expectedSize)
             {
                 // progression tracking code
             }
                                                              completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
             {
                 
                 
                 if (finished)
                 {
                 
                 if ([fileType  isEqual: @"gif"])
                 {
                     animatedImage2 = [FLAnimatedImage animatedImageWithGIFData:data];
                     imageView.animatedImage = animatedImage2;
                     [self.view addSubview:self.keyboardBackground];

                     // do something with image
                 }
                 else {
                     imageView.image = image;
                 }
                 }
             }];
            
            });


    });
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
        [imageView addGestureRecognizer:singleTap];
        [imageView setMultipleTouchEnabled:YES];
        [imageView setUserInteractionEnabled:YES];
      
        

    }
    @catch (NSException *exception) {
        NSLog(@"Exception :%@",exception.debugDescription);
    }
        
        
    self.keyboardBackground.autoresizesSubviews = YES;
    self.keyboardBackground.contentSize = CGSizeMake(_x, 180);
    
    
    }
}
- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    UIView *tappedView = [gesture.view hitTest:[gesture locationInView:gesture.view] withEvent:nil];
    NSLog(@"Touch event on view: %@",[tappedView class]);
}



- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];



}


#pragma mark - ScrollView Delegates
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int  _index = ((int)(scrollView.contentOffset.x)/320);
    NSLog(@"%d",_index);
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"HEEERE");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}

@end
