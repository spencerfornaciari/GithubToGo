//
//  SFMasterViewController.h
//  GithubToGo
//
//  Created by Spencer Fornaciari on 1/27/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFDetailViewController;

@interface SFMasterViewController : UITableViewController

@property (strong, nonatomic) SFDetailViewController *detailViewController;

@end
