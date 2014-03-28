//
//  DetailViewController.m
//  Movie
//
//  Created by Yoon Lee on 3/15/14.
//  Copyright (c) 2014 Yoon Lee. All rights reserved.
//

#import "DetailViewController.h"
#import "JMImageCache.h"
#import "MoviePreViewController.h"

enum {
    EXPOSE_FOR_PURCHASE = 0,
    PREVIEW_MOVIE,
}MovieMenuOptions;

@implementation DetailViewController
@synthesize content;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self setAutomaticallyAdjustsScrollViewInsets:YES];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    [self.view setBackgroundColor:CWHITE()];
    
    NSURL *url = [NSURL URLWithString:[[content objectForKey:@"artworkUrl100"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 101, 150)];
    [imageView setClipsToBounds:YES];
    [imageView setImageWithURL:url placeholder:[UIImage imageNamed:@"PlaceHolder.png"] completionBlock:^(UIImage *image){
        [imageView setImage:image];
    }];
    [self.view addSubview:imageView];
    [imageView release];
    
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width + 30, 25, 320 - imageView.frame.size.width - 50, 15)];
    [lbl1 setText:[content objectForKey:@"trackName"]];
    [lbl1 setBackgroundColor:CCLEAR()];
    [self.view addSubview:lbl1];
    [lbl1 release];
    
    // assign date from string using formatter
    NSString *originalDate = [content objectForKey:@"releaseDate"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-DD'T'HH:mm:ss'Z'"];
    NSDate *date = [dateFormatter dateFromString:originalDate];
    // converts the date format as we wish
    [dateFormatter setDateFormat:@"MM/DD/yyyy"];
    NSString *releaseDate = [dateFormatter stringFromDate:date];
    
    UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width + 30, 45, 320 - imageView.frame.size.width - 50, 13)];
    [lbl2 setText:releaseDate];
    [lbl2 setBackgroundColor:CCLEAR()];
    [lbl2 setTextColor:RGB(162, 162, 162)];
    [lbl2 setFont:[UIFont systemFontOfSize:13]];
    [self.view addSubview:lbl2];
    [lbl2 release];
    [dateFormatter release];
    
    UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width + 30, 65, 320 - imageView.frame.size.width - 50, 13)];
    NSString *price = [content objectForKey:@"collectionPrice"];
    if (price == NULL) {
        price = @"FREE";
    }
    else
        price = [NSString stringWithFormat:@"%@ %@", [content objectForKey:@"collectionPrice"], [content objectForKey:@"currency"]];
    
    [lbl3 setText:price];
    [lbl3 setBackgroundColor:CCLEAR()];
    [lbl3 setTextColor:RGB(71, 135, 251)];
    [lbl3 setFont:[UIFont systemFontOfSize:13]];
    [self.view addSubview:lbl3];
    [lbl3 release];
    
    UILabel *lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width + 30, 85, 320 - imageView.frame.size.width - 50, 13)];
    NSString *rating = [content objectForKey:@"contentAdvisoryRating"];
    [lbl4 setText:rating];
    [lbl4 setBackgroundColor:CCLEAR()];
    UIColor *color = RGB(162, 162, 162);
    if ([rating isEqualToString:@"R"]) {
        color = CDRED();
    }
    [lbl4 setTextColor:color];
    [lbl4 setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
    [self.view addSubview:lbl4];
    [lbl4 release];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, imageView.frame.size.height + 20, 320 - 15, 120)];
    [textView setText:[content objectForKey:@"longDescription"]];
    [textView setEditable:NO];
    [self.view addSubview:textView];
    [textView release];
    
    UITableView *category = [[UITableView alloc] initWithFrame:CGRectMake(0, textView.frame.origin.y + textView.frame.size.height + 20, self.view.bounds.size.width, 100) style:UITableViewStylePlain];
    [category setDelegate:self];
    [category setDataSource:self];
    [category setRowHeight:50.0f];
    [category setScrollEnabled:NO];
    [self.view addSubview:category];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const Movie_Detail_Identifier = @"MOVIE_DETAIL_IDENTIFIER";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Movie_Detail_Identifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Movie_Detail_Identifier] autorelease];
    }
    
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    
    switch (indexPath.row) {
        case EXPOSE_FOR_PURCHASE:
            [cell.textLabel setText:@"PURCHASE"];
            break;
        case PREVIEW_MOVIE:
            [cell.textLabel setText:@"PREVIEW"];
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case EXPOSE_FOR_PURCHASE:
            // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[content objectForKey:@"collectionViewUrl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[content objectForKey:@"trackViewUrl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            break;
        case PREVIEW_MOVIE: {
            MoviePreViewController *mpc = [[MoviePreViewController alloc] init];
            [mpc setUrl:[NSURL URLWithString:[[content objectForKey:@"previewUrl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            [self.navigationController pushViewController:mpc animated:YES];
            [mpc release];
            break;
        }
    }
}

#pragma mark UIViewController
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [super dealloc];
    
    [content release];
    content = nil;
}

@end