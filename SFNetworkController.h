//
//  SFNetworkController.h
//  GithubToGo
//
//  Created by Spencer Fornaciari on 1/27/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFNetworkController : NSObject

@property (strong, nonatomic) NSString *accessToken;

+ (SFNetworkController *)sharedController;

- (NSArray *)reposForSearchString:(NSString *)searchString;
- (NSArray *)usersForSearchString:(NSString *)searchString;
- (void)beginOAuthAccess;
- (BOOL)checkOAuthStatus;
- (void)handleCallbackURL:(NSURL *)url;
- (NSArray *)fetchUsersReposWithAccessToken:(NSString *)token;

@end
