//
//  RootViewController.m
//  Movie
//
//  Created by Yoon Lee on 3/14/14.
//  Copyright (c) 2014 Yoon Lee. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "Reachability.h"

@implementation RootViewController
@synthesize contentsTableView;
@synthesize searchQueryBar;
@synthesize contents;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self setAutomaticallyAdjustsScrollViewInsets:YES];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    [self.view setBackgroundColor:CWHITE()];
    [self setTitle:@"iTunes Movie Search"];
    
    searchQueryBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    // for orientation support for future
    [self.searchQueryBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.searchQueryBar setPlaceholder:@"Search Movie Keyword"];
    [self.searchQueryBar setDelegate:self];
    [self.view addSubview:self.searchQueryBar];
    
    contentsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height-44) style:UITableViewStylePlain];
    // for orientation support for future
    [self.contentsTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.contentsTableView setDelegate:self];
    [self.contentsTableView setDataSource:self];
    [self.contentsTableView setRowHeight:60];
    [self.view addSubview:self.contentsTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestRecieved:) name:MOVIE_REQUEST_NOTIFICATION_RECEV object:nil];
    
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Tell the reachability that we DON'T want to be reachable on 3G/EDGE/CDMA
    reach.reachableOnWWAN = NO;
    
    // Here we set up a NSNotification observer. The Reachability that caused the notification
    // is passed in the object parameter
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    [reach startNotifier];
}

#pragma mark UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contents count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // pre-setting for cell
    NSDictionary *dict = [self.contents objectAtIndex:indexPath.row];
    [cell.textLabel setText:[dict objectForKey:@"trackName"]];
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    NSString *rating = [dict objectForKey:@"contentAdvisoryRating"];
    UIColor *color = RGB(162, 162, 162);
    if ([rating isEqualToString:@"R"]) {
        color = CDRED();
    }
    [cell.detailTextLabel setText:rating];
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
    [cell.detailTextLabel setTextColor:color];
    [cell.detailTextLabel setTextAlignment:NSTextAlignmentRight];
    
    NSURL *url = [NSURL URLWithString:[[dict objectForKey:@"artworkUrl100"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    UIImage *placeholder = [UIImage imageNamed:@"PlaceHolder.png"];
    [cell.imageView setImage:placeholder];
    [cell.imageView setClipsToBounds:YES];
    // beauty of async-GCD lazy load
    [cell.imageView setImageWithURL:url placeholder:[UIImage imageNamed:@"PlaceHolder.png"]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierMovie = @"CellIdentifierMovie";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierMovie];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierMovie];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = [self.contents objectAtIndex:indexPath.row];
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    [detailVC setTitle:[dict objectForKey:@"trackName"]];
    [detailVC setContent:dict];
    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
}

#pragma mark UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.searchQueryBar setShowsCancelButton:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchQueryBar setShowsCancelButton:NO];
    // more efficient than resignKeyboard
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self.searchQueryBar setShowsCancelButton:NO];
    // everytime new search comes along, we simply erase saved image cache
    [[JMImageCache sharedCache] removeAllObjects];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // preparing for the query
    [[QueryManager sharedQueryManager] makeMovieQuery:searchBar.text];
    // executes the query
    [[QueryManager sharedQueryManager] executeQuery];
}

#pragma mark QueryManager Notification
- (void)requestRecieved:(NSNotification *)notification
{
    NSDictionary *object = [notification object];
    [self setContents:[object objectForKey:@"results"]];
    // this will only prints in debug mode
    // pre-set by project macro
    DLog(@"%@", [self.contents description]);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if ([self.contents count])
        [self.contentsTableView reloadData];
    else {
        [self showAlert:@"Search" message:@"No Result"];
    }
}

#pragma mark ReachAbility
-(void)reachabilityChanged:(NSNotification*)notification
{
    Reachability * reach = [notification object];
    if (![reach isReachable]) {
        [self showAlert:@"Network" message:@"Low Signal"];
    }
}

// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle: title
                                       message: message
                                      delegate: nil
                             cancelButtonTitle: @"Confirm"
                             otherButtonTitles: nil];
    [alert show];
}

#pragma mark UIViewController
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // when view goes away, we remove the observer
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [super dealloc];
    
    [contentsTableView release];
    contentsTableView = nil;
    
    [searchQueryBar release];
    searchQueryBar = nil;
    
    [contents release];
    contents = nil;
}

@end
