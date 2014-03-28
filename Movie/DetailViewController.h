//
//  DetailViewController.h
//  Movie
//
//  Created by Yoon Lee on 3/15/14.
//  Copyright (c) 2014 Yoon Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSDictionary *content;
    UITableView *category;
}

@property(nonatomic, retain)UITableView *category;
@property(nonatomic, retain)NSDictionary *content;

@end
