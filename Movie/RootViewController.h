//
//  RootViewController.h
//  Movie
//
//  Created by Yoon Lee on 3/14/14.
//  Copyright (c) 2014 Yoon Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "QueryManager.h"
#import "JMImageCache.h"

@interface RootViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,
                                                 UISearchBarDelegate>
{
    UITableView *contentsTableView;
    UISearchBar *searchQueryBar;
    
    NSMutableArray *contents;
}

@property(nonatomic, retain)UITableView *contentsTableView;
@property(nonatomic, retain)UISearchBar *searchQueryBar;
@property(nonatomic, retain)NSMutableArray *contents;

@end
