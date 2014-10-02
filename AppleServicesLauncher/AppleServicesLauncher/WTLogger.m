//
//  WTLogger.m
//  AppleServicesLauncher
//
//  Created by Nikola Tesla on 9/30/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import "WTLogger.h"
#import <stdio.h>

#define RED "\x1b[31m"
#define GREEN "\x1b[32m"
#define YELLOW "\x1b[33m"
#define BLUE "\x1b[34m"
#define PINK "\x1b[35m"
#define TURQUOISE "\x1b[36m"
#define WHITE "\x1b[37m"
#define RESET "\x1b[39m"
/*
 Change these to change which color different warnings are
*/
#define BAD RED
#define WARNING YELLOW
#define NEUTRAL GREEN
#define GOOD BLUE
/*
 </loglevels>
 */
@implementation WTLogger
#ifdef DEBUG
+(void)log_base:(NSString *)msg usingFileDescriptor:(FILE*)filedesc usingColor:(char *)color {
    fprintf(filedesc, "%s%s%s", color, [msg cStringUsingEncoding:NSUTF8StringEncoding], RESET);
}
+(void)good:(NSString *)msg {
    [WTLogger log_base:msg usingFileDescriptor:stdout usingColor:GOOD];
}
+(void)neutral:(NSString *)msg {
    [WTLogger log_base:msg usingFileDescriptor:stdout usingColor:NEUTRAL];
}
+(void)warn:(NSString *)msg {
    [WTLogger log_base:msg usingFileDescriptor:stderr usingColor:WARNING];
}
+(void)error:(NSString *)msg {
    [WTLogger log_base:msg usingFileDescriptor:stderr usingColor:BAD];
}
#else
+(void)log_base:(NSString *)msg usingFileDescriptor:(FILE*)filedesc usingColor:(char *)color {}
+(void)good:(NSString *)msg {}
+(void)neutral:(NSString *)msg {}
+(void)warn:(NSString *)msg {}
+(void)error:(NSString *)msg {}
#endif

@end
