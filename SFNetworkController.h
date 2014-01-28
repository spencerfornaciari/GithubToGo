//
//  SFNetworkController.h
//  GithubToGo
//
//  Created by Spencer Fornaciari on 1/27/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFNetworkController : NSObject

+ (SFNetworkController *)sharedController;

- (NSArray *)reposForSearchString:(NSString *)searchString;
- (NSArray *)usersForSearchString:(NSString *)searchString;


@end
