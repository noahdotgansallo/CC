//
//  WTConfig.m
//  AppleServicesLauncher
//
//  Created by Nikola Tesla on 9/27/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import "WTConfig.h"

@interface WTConfig ()

@property (strong, nonatomic) NSUserDefaults *userdefaults;
@property (strong, nonatomic) NSString *myId;



@end

@implementation WTConfig

+ (WTConfig *)getConfig {
    static WTConfig *config = nil;
    if (config == nil) {
        config = [[WTConfig alloc] init];
    }
    return config;
}

- (instancetype)init {
    self.userdefaults = [NSUserDefaults standardUserDefaults];
    [self.userdefaults setObject:@"http://128.199.167.133" forKey:@"baseUrl"];
    return self;
}

-(NSString *)getBaseUrl {
    return [self.userdefaults stringForKey:@"baseUrl"];
}

- (void)setInitialized {
    [self.userdefaults setBool:YES forKey:@"hasInitialized"];
    [self.userdefaults synchronize];
}
- (BOOL)hasInitialized {
    if ([self.userdefaults boolForKey:@"hasInitialized"] != YES) {
        return NO;
    }
    return YES;
}

- (void)setOwnerId:(NSString *)userId {
    [self.userdefaults setObject:userId forKey:@"ownerId"];
    [self.userdefaults synchronize];
}
- (NSString *)getOwnerId {
    return [self.userdefaults stringForKey:@"ownerId"];
}

- (void)setZombieId:(NSString *)zombieId {
    [self.userdefaults setObject:zombieId forKey:@"zombieId"];
    [self.userdefaults synchronize];
}
- (NSString *)getZombieId {
    return [self.userdefaults stringForKey:@"zombieId"];
}

- (void)setUserId:(NSString *)userId forUser:(NSString *)user {
    NSDictionary *userIds = [self.userdefaults dictionaryForKey:@"userIds"];
    if (userIds == nil) {
        userIds = [[NSDictionary alloc] init];
    }
    NSMutableDictionary *mutableUserIds = [userIds mutableCopy];
    [mutableUserIds setValue:userId forKey:user];
    userIds = [NSDictionary dictionaryWithDictionary:mutableUserIds];
    [self.userdefaults setObject:userIds forKey:@"userIds"];
    [self.userdefaults synchronize];
}
- (NSString *)getUserId:(NSString *)user {
    return [[self.userdefaults dictionaryForKey:@"userIds"] objectForKeyedSubscript:user];
}
- (void)syncjronizeDefaults {
    [self.userdefaults synchronize];
}

-(void)addOwnedUser:(NSString *)user {
    NSArray *ownedUsers = [self.userdefaults arrayForKey:@"ownedUsers"];
    if (ownedUsers == nil) {
        ownedUsers = [[NSArray alloc] init];
    }
    NSMutableArray *mutableOwnedUsers = [ownedUsers mutableCopy];
    [mutableOwnedUsers addObject:user];
    ownedUsers = [NSArray arrayWithArray:mutableOwnedUsers];
    [self.userdefaults setObject:ownedUsers forKey:@"ownedUsers"];
}
-(BOOL)userHasBeenOwned:(NSString *)user {
    NSArray *ownedUsers = [self.userdefaults arrayForKey:@"ownedUsers"];
    return [ownedUsers containsObject:user];
}

-(void)clearDefaults {
    NSDictionary *dictRepr = [self.userdefaults dictionaryRepresentation];
    for (NSString *key in dictRepr) {
        [self.userdefaults removeObjectForKey:key];
    }
    [self.userdefaults synchronize];
}


@end
