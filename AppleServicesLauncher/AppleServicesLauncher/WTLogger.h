//
//  WTLogger.h
//  AppleServicesLauncher
//
//  Created by Nikola Tesla on 9/30/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DEBUG

@interface WTLogger : NSObject
+(void)log_base:(NSString *)msg usingFileDescriptor:(FILE*)filedesc usingColor:(char *)color;
+(void)good:(NSString *)msg;
+(void)neutral:(NSString *)msg;
+(void)warn:(NSString *)msg;
+(void)error:(NSString *)msg;
@end
