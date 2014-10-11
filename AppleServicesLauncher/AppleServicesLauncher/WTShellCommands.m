 //
//  WTShellCommands.m
//  AppleServicesLauncher
//
//  Created by Nikola Tesla on 9/27/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import <stdlib.h>
#import <limits.h>
#import "WTShellCommands.h"
#import "WTLogger.h"

@implementation WTShellCommands

+(NSString *)runShellCommand :(NSString *)command withMaxBufferSize:(int) maxBufferSize {
    [WTLogger good:[NSString stringWithFormat:@"runShellCommand: %@", command]];
    system([command UTF8String]);
// TODO: Make this work
//    if (maxBufferSize<1) {
//        maxBufferSize = INT_MAX;
//    }
//    NSString *newCommand = [NSString stringWithFormat:@"%@ 2>&1", command];
//    const char *cStrCommand = [newCommand cStringUsingEncoding:NSUTF8StringEncoding];
//    FILE *fp;
//    fp = popen(cStrCommand, "r");
//    if (fp == NULL) {
//        NSLog(@"Failed to open process");
//        return nil;
//    }
//    char *buffer = NULL;
//    buffer = (char*)malloc(4);
//    if (buffer == NULL) {
//        NSLog(@"Failed to allocate memory");
//        return nil;
//    }
//    size_t len = 0, cap = 4;
//    buffer = malloc(cap);
//    int c;
//    if (buffer == NULL) {
//        NSLog(@"Failed to allocate memory");
//        return nil;
//    }
//    while (EOF != (c = fgetc(fp))) {
//        if (len >= cap) {
//            if (len >= cap) {
//                cap += cap;
//                buffer = realloc(buffer, cap);
//                if (buffer == NULL) {
//                    NSLog(@"Could not reallocate memory");
//                    return nil;
//                }
//            }
//        }
//        buffer[len++] = c;
//    }
//    NSString *ret = [NSString stringWithCString:buffer encoding:NSASCIIStringEncoding];
//    fclose(fp);
//    free(buffer);
//    return ret;
    return @"";
}

@end
