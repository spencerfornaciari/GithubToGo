//
//  SFNetworkController.h
//  GithubToGo
//
//  Created by Spencer Fornaciari on 1/27/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFNetworkControllerDelegate <NSObject>

-(void)reloadTableData;

@end

@interface SFNetworkController : NSObject

@property (strong, nonatomic) NSString *accessToken;

@property (nonatomic, unsafe_unretained) id<SFNetworkControllerDelegate>delegate;

+ (SFNetworkController *)sharedController;

- (NSArray *)reposForSearchString:(NSString *)searchString;
- (NSArray *)usersForSearchString:(NSString *)searchString;
- (void)beginOAuthAccess;
- (BOOL)checkOAuthStatus;
- (void)handleCallbackURL:(NSURL *)url;
- (NSArray *)fetchUsersReposWithAccessToken:(NSString *)token;
-(void)createRepo:(NSString *)repoName withDescription:(NSString *)repoDescription;
-(void)createFileInRepo:(NSString *)repoName forUser:(NSString *)userName withFileName:(NSString *)fileName withContent:(NSString *)fileContent;

@end
