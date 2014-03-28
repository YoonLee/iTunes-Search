//
//  MoviePreViewController.m
//  Movie
//
//  Created by Yoon Lee on 3/15/14.
//  Copyright (c) 2014 Yoon Lee. All rights reserved.
//

#import "MoviePreViewController.h"

@implementation MoviePreViewController
@synthesize url;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self setAutomaticallyAdjustsScrollViewInsets:YES];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    [self.view setBackgroundColor:CWHITE()];
    
    MPMoviePlayerController *movieStreamClip = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [movieStreamClip setMovieSourceType:MPMovieSourceTypeStreaming];
    [movieStreamClip.view setFrame:CGRectMake(0, 0, 290, 250)];
    [movieStreamClip.view setCenter:CGPointMake(self.view.bounds.size.width/2, 160)];
    [movieStreamClip.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    [movieStreamClip setShouldAutoplay:YES];
    [movieStreamClip play];
    [self.view addSubview:movieStreamClip.view];
    [movieStreamClip release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [super dealloc];
}

@end
