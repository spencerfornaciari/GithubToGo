//
//  GitUser.m
//  GithubToGo
//
//  Created by Spencer Fornaciari on 1/28/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "GitUser.h"

@implementation GitUser

-(id)init
{
    self = [super init];
    
    return self;
}

-(void)downloadAvatar
{
    _isDownloading = TRUE;
    
    [_downloadQueue addOperationWithBlock:^{
        NSURL *avatarURL = [NSURL URLWithString:self.photoLocation];
        NSData *avatarData = [NSData dataWithContentsOfURL:avatarURL];
        self.photo = [UIImage imageWithData:avatarData];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadedImage" object:nil userInfo:@{@"user": self}];
        }];
    }];
    
}

@end