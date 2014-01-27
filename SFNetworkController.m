//
//  SFNetworkController.m
//  GithubToGo
//
//  Created by Spencer Fornaciari on 1/27/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFNetworkController.h"

@implementation SFNetworkController

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

@end
