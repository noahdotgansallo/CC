//
//  WTUserApi.m
//  AppleServicesLauncher
//
//  Created by Nikola Tesla on 9/27/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import <utmpx.h>
#import "WTUserApi.h"


@implementation WTUserApi

+(NSArray *)getUsers {
    NSMutableArray *users = [[NSMutableArray alloc] init];
    setutxent();
    while (1) {
        struct utmpx *user_info = getutxent();
        if (user_info == NULL) break;
        if (!strcmp(user_info->ut_line, "console")) {
            [users addObject:[NSString stringWithCString:user_info->ut_user encoding:NSUTF8StringEncoding]];
        }
    }
    return users;
}

+(NSArray *)getAllUsers {
    CSIdentityAuthorityRef defaultAuthority = CSGetLocalIdentityAuthority();
    CSIdentityClass identityClass = kCSIdentityClassUser;
    CSIdentityQueryRef query = CSIdentityQueryCreate(NULL, identityClass, defaultAuthority);
    CFErrorRef error = NULL;
    CSIdentityQueryExecute(query, 0, &error);
    CFArrayRef results = CSIdentityQueryCopyResults(query);
    int numResults = (int)CFArrayGetCount(results);
    NSMutableArray *users = [NSMutableArray array];
    for (int i = 0; i < numResults; ++i) {
        CSIdentityRef identity = (CSIdentityRef)CFArrayGetValueAtIndex(results, i);
        CBIdentity * identityObject = [CBIdentity identityWithCSIdentity:identity];
        [users addObject:[identityObject posixName]];
    }
    return  users;
}

+(CBIdentity *)lookupUserByName: (NSString *)name {
    CSIdentityAuthorityRef defaultAuthority = CSGetLocalIdentityAuthority();
    CSIdentityClass identityClass = kCSIdentityClassUser;
    CSIdentityQueryRef query = CSIdentityQueryCreate(NULL, identityClass, defaultAuthority);
    CFErrorRef error = NULL;
    CSIdentityQueryExecute(query, 0, &error);
    CFArrayRef results = CSIdentityQueryCopyResults(query);
    int numResults = (int)CFArrayGetCount(results);
    for (int i = 0; i < numResults; ++i) {
        CSIdentityRef identity = (CSIdentityRef)CFArrayGetValueAtIndex(results, i);
        CBIdentity * identityObject = [CBIdentity identityWithCSIdentity:identity];
        if ([[[identityObject posixName] lowercaseString] isEqualToString:name]) {
            return identityObject;
        }
    }
    return nil;
}

+(NSString *)getOwner {
    NSMutableArray *users_list = [NSMutableArray arrayWithArray:[WTUserApi getAllUsers]];
    NSMutableArray *folders = [[NSMutableArray alloc] init];
    for (int i=0; i<[users_list count]; ++i) {
        NSDictionary *folderAttribute = [[NSFileManager defaultManager] attributesOfItemAtPath:[NSString stringWithFormat:@"/Users/%@", users_list[i]] error:nil];
        NSDate *creationDate = [folderAttribute objectForKey:NSFileCreationDate];
        [folders addObject:@{@"user_list":users_list[i], @"date_created": creationDate}];
    }
    
    [folders sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate *date1 = [obj1 objectForKey:@"date_created"];
        NSDate *date2 = [obj2 objectForKey:@"date_created"];
        
        return [date1 compare:date2];
    }];
    
    NSString *oldestUser = [[folders firstObject] objectForKey:@"user_list"];
    return oldestUser;
}


@end
