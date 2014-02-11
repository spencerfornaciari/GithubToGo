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

-(void)downloadAvatar:(void (^)(UIImage *pic))callbackImage;
{
    _isDownloading = TRUE;
    
    [_downloadQueue addOperationWithBlock:^{
        NSURL *avatarURL = [NSURL URLWithString:self.photoLocation];
        NSData *avatarData = [NSData dataWithContentsOfURL:avatarURL];
        UIImage *avatarImage = [UIImage imageWithData:avatarData];
        
        callbackImage(avatarImage);
        
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadedImage" object:nil userInfo:@{@"user": self}];
//        }];
    }];
    
}

@end