//
//  AppDelegate.h
//  Movie
//
//  Created by Yoon Lee on 3/14/14.
//  Copyright (c) 2014 Yoon Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIWindow *window;
    
    RootViewController *rootViewController;
}

@property(nonatomic, retain)UIWindow *window;
@property(nonatomic, retain)RootViewController *rootViewController;

@end
