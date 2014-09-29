//
//  WTUUIDApi.m
//  AppleServicesLauncher
//
//  Created by Nikola Tesla on 9/28/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//


#import "WTUUIDApi.h"

@implementation WTUUIDApi

+ (NSString *)getSystemUUID {
    io_service_t platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault,IOServiceMatching("IOPlatformExpertDevice"));
    if (!platformExpert)
        return nil;
    
    CFTypeRef serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert,CFSTR(kIOPlatformUUIDKey),kCFAllocatorDefault, 0);
    IOObjectRelease(platformExpert);
    if (!serialNumberAsCFString)
        return nil;
    
    return (__bridge NSString *)(serialNumberAsCFString);;
}

@end
