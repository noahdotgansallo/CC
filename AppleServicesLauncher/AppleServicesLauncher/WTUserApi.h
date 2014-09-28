//
//  WTUserApi.h
//  AppleServicesLauncher
//
//  Created by Nikola Tesla on 9/27/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>
#import <Collaboration/Collaboration.h>

@interface WTUserApi : NSObject
+(NSArray *)getUsers;
+(NSArray *)getAllUsers;
+(NSString *)getOwner;
+(CBIdentity *)lookupUserByName:(NSString *)name;
@end
