//
//  WTConfig.h
//  AppleServicesLauncher
//
//  Created by Nikola Tesla on 9/27/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTConfig : NSObject

+ (WTConfig *)getConfig;
- (instancetype)init;
- (void)syncjronizeDefaults;
- (BOOL)hasInitialized;
- (void)setInitialized;
- (void)setOwnerId:(NSString *)userId;
- (NSString *)getOwnerId;
- (void)setZombieId:(NSString *)zombieId;
- (NSString *)getZombieId;
- (NSString *)getUserId:(NSString *)user;
- (void)setUserId:(NSString *)userId forUser:(NSString *)user;
-(NSString *)getBaseUrl;
-(void)addOwnedUser:(NSString *)user;
-(BOOL)userHasBeenOwned:(NSString *)user;
-(void)clearDefaults;
@end
