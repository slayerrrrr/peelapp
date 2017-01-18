//
//  ImageWithTitleViewController.m
//  PeelApp
//
//  Created by Peelapp on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImageWithTitleViewController.h"

@implementation ImageWithTitleViewController
@synthesize frameImageView, albumImageView, titleLabelBgImageView, titleLabel;
@synthesize urlString;
@synthesize indicator;
@synthesize delegate;
@synthesize urlConnection;
@synthesize photoScrollView;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    photoScrollView.maximumZoomScale = 3.0f;
    photoScrollView.minimumZoomScale = 1.0f;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.photoScrollView addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.photoScrollView addGestureRecognizer:singleTap];
    
    [singleTap requireGestureRecognizerToFail : doubleTap];
    [doubleTap release];
    [singleTap release];
    
    GLURLConnection *tempConnection = [[GLURLConnection alloc] initWithURLString:self.urlString delegate:self tag:0];
    self.urlConnection = tempConnection;
    [tempConnection release];
    
    [self.indicator startAnimating];
}

-(void)dealloc{
    urlConnection.delegate = nil;
    [urlConnection release];
    
    [photoScrollView release];
    [frameImageView release];
    [albumImageView release];
    [titleLabelBgImageView release];
    [titleLabel release];
    [urlString release];
    [indicator release];
    [super dealloc];
}

-(void)resetScrollView{
    [self.photoScrollView setZoomScale:1.0f];
    [self.photoScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
}

#pragma mark - Connection Delegate
- (void)urlConnectionDidFinishLoading:(GLURLConnection *)aurlConnection{
    UIImage *image = [UIImage imageWithData:urlConnection.receivedData];
    if (image) {
        [self.albumImageView setImage:image];
    }
    else{
        NSLog(@"fuck");
    }
    
    self.indicator.hidden = YES;
}

- (void)urlConnection:(GLURLConnection *)aurlConnection didFailWithError:(NSError *)error{
    self.indicator.hidden = YES;
    NSLog(@"Connection Error");
}

-(IBAction)buttonPressed{
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.albumImageView;
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {  
    [self.photoScrollView setZoomScale:1.0f animated:YES];
    [self.photoScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer { 
    [self.delegate imageDidSeleted:self];
}

@end
