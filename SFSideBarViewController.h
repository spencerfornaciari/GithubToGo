//
//  SFBarMenuTableViewController.h
//  GithubToGo
//
//  Created by Spencer Fornaciari on 1/28/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFDetailViewController.h"

@interface SFSideBarViewController : UITableViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) SFDetailViewController *detailViewController;

@end
