//
//  SMyRepoTableViewController.h
//  GithubToGo
//
//  Created by Spencer Fornaciari on 2/12/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFNetworkController.h"

@interface SFMyRepoTableViewController : UITableViewController <SFNetworkControllerDelegate>

@property (strong, nonatomic) SFNetworkController *networkController;

@end