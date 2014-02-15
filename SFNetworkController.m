//
//  SFNetworkController.m
//  GithubToGo
//
//  Created by Spencer Fornaciari on 1/27/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFNetworkController.h"

@implementation SFNetworkController

#define GITHUB_OAUTH_URL @"https://github.com/login/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@"
#define GITHUB_CLIENT_ID @"b74e07410fd1dedf6cc4"
#define GITHUB_SECRET_ID @"9401a3c8d1e80fc7e78aaeb43af271b32f0ae40e"
#define GITHUB_REDIRECT @"githubtogo://git_callback"
#define GITHUB_POST_URL @"https://github.com/login/oauth/access_token"

+ (SFNetworkController *)sharedController
{
    static dispatch_once_t pred;
    static SFNetworkController *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[SFNetworkController alloc] init];
    });
    return shared;
}

- (NSArray *)reposForSearchString:(NSString *)searchString
{
    //https://api.github.com/search/repositories?q=tetris+language:assembly&sort=stars&order=desc
    
    searchString = [NSString stringWithFormat:@"https://api.github.com/search/repositories?q=%@", searchString];
    NSURL *searchURL = [NSURL URLWithString:searchString];
    
    NSError *error;
    
    NSData *searchData = [NSData dataWithContentsOfURL:searchURL];
    NSDictionary *searchDictionary = [NSJSONSerialization JSONObjectWithData:searchData options:NSJSONReadingMutableContainers error:&error];
    
    return searchDictionary[@"items"];
}

- (NSArray *)usersForSearchString:(NSString *)searchString
{
    searchString = [NSString stringWithFormat:@"https://api.github.com/search/users?q=%@", searchString];
    NSURL *searchURL = [NSURL URLWithString:searchString];
    
    NSError *error;
    
    NSData *searchData = [NSData dataWithContentsOfURL:searchURL];
    NSDictionary *searchDictionary = [NSJSONSerialization JSONObjectWithData:searchData options:NSJSONReadingMutableContainers error:&error];
    
    return searchDictionary[@"items"];
}

- (void)beginOAuthAccess
{
    NSString *myURL = [NSString stringWithFormat:GITHUB_OAUTH_URL,GITHUB_CLIENT_ID, GITHUB_REDIRECT, @"user,repo"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:myURL]];
}

-(void)handleCallbackURL:(NSURL *)url
{
    NSString *code = [self convertURLToCode:url];
    
    NSString *post = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@&redirect_uri=%@", GITHUB_CLIENT_ID, GITHUB_SECRET_ID, code, GITHUB_REDIRECT];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:GITHUB_POST_URL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *error;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    self.accessToken = [self convertResponseIntoToken:responseData];
    NSLog(@"%@", self.accessToken);
    
    [self fetchUsersReposWithAccessToken:self.accessToken];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(NSArray *)fetchUsersReposWithAccessToken:(NSString *)token
{
    NSString *stringURL = [NSString stringWithFormat:@"https://api.github.com/user/repos?access_token=%@", token];
    
    NSURL *myURL = [NSURL URLWithString:stringURL];
    NSData *responseData = [NSData dataWithContentsOfURL:myURL];
    
    NSLog(@"%@", myURL);
    
    NSError *error;
    
    NSArray *repoArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    return repoArray;

}

-(NSString *)convertResponseIntoToken:(NSData *)data
{
    NSString *tokenResponse = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    NSArray *components = [tokenResponse componentsSeparatedByString:@"&"];
    NSString *access_token = [components firstObject];
    NSArray *components2 = [access_token componentsSeparatedByString:@"="];
    
    return [components2 lastObject];
}

-(NSString *)convertURLToCode:(NSURL *)url
{
    NSString *query = [url query];
    NSArray *components = [query componentsSeparatedByString:@"="];
    NSLog(@"%@", components);
    NSString *code = [components lastObject];
    return code;
}

-(BOOL)checkOAuthStatus
{
    NSString *myURL = [NSString stringWithFormat:@"https://api.github.com/applications/:%@/tokens/:%@", GITHUB_CLIENT_ID, [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]];
    
    NSLog(@"%@", myURL);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:myURL]];
    
    return TRUE;
}

-(void)createRepo:(NSString *)repoName withDescription:(NSString *)repoDescription
{
    NSError *JSONError;

    NSDictionary *newRepo = @{@"name": repoName,
                              @"description": repoDescription};
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:newRepo options:NSJSONWritingPrettyPrinted error:&JSONError];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.github.com/user/repos?access_token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]]]];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.github.com/user/repos"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"Token %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]]  forHTTPHeaderField:@"Authorization"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *error;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *stringResponse = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    
    NSLog(@"%@", stringResponse);
}

-(NSArray *)fetchUsersRepoContents:(NSString *)repoName;
{
    NSString *stringURL = [NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/contents?access_token=%@", @"spencerfornaciari", repoName, [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]];
    
    NSURL *myURL = [NSURL URLWithString:stringURL];
    NSData *responseData = [NSData dataWithContentsOfURL:myURL];
    
    NSLog(@"%@", myURL);
    
    NSError *error;
    
    NSArray *repoArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    return repoArray;
    
}

-(NSArray *)fetchUsersRepoContentsOfFolder:(NSString *)repoFolderName forRepo:(NSString *)repoName;
{
    NSString *stringURL = [NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/contents/%@?access_token=%@", @"spencerfornaciari", repoName, repoFolderName, [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]];
    
    NSURL *myURL = [NSURL URLWithString:stringURL];
    NSData *responseData = [NSData dataWithContentsOfURL:myURL];
    
    NSLog(@"%@", myURL);
    
    NSError *error;
    
    NSArray *repoArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    return repoArray;
    
}

-(void)createFileInRepo:(NSString *)repoName forUser:(NSString *)userName withFileName:(NSString *)fileName withContent:(NSString *)fileContent
{
    NSData *newData = [fileContent dataUsingEncoding:NSUTF8StringEncoding];
    
    // Get NSString from NSData object in Base64
    NSString *encodedString = [newData base64EncodedStringWithOptions:0];
    
    NSLog(@"%@ %@ %@", userName, repoName, fileName);
    
    NSError *JSONError;
    
    NSDictionary *newRepo = @{@"message": @"New File",
                              @"content": encodedString};
    
    NSString *name = @"spencerfornaciari";
    NSString *pathName = @"Path5";
    NSString *repo = @"Test-Repo";
    
    NSLog(@"%@ %@ %@", name, repo, pathName);
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:newRepo options:NSJSONWritingPrettyPrinted error:&JSONError];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]);
    ///repos/:owner/:repo/contents/:path
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/contents/%@", userName, repoName, fileName]]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:[NSString stringWithFormat:@"Token %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]]  forHTTPHeaderField:@"Authorization"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *error;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *stringResponse = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    
    NSLog(@"%@", stringResponse);
    
}

@end
