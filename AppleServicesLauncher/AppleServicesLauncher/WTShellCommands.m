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

@implementation WTShellCommands

+(NSString *)runShellCommand :(NSString *)command withMaxBufferSize:(int) maxBufferSize {
    if (maxBufferSize<1) {
        maxBufferSize = INT_MAX;
    }
    NSString *newCommand = [NSString stringWithFormat:@"%@ 2>&1", command];
    FILE *fp;
    const char *cStrCommand = [newCommand cStringUsingEncoding:NSUTF8StringEncoding];
    fp = popen(cStrCommand, "r");
    if (fp == NULL) {
        NSLog(@"Failed to open process");
        return nil;
    }
    char *buffer = NULL;
    buffer = (char*)malloc(4);
    while (!feof(fp)) {
        buffer = realloc(buffer, sizeof(buffer)+1);
        sprintf(buffer, "%s%c", buffer, fgetc(fp));
    }
    printf("printf: %s\n", buffer);
    //NSLog(@"nslog: %s\n", buffer);
    fclose(fp);
//    NSString *ret = [NSString stringWithCString:buffer encoding:NSASCIIStringEncoding];
//    free(buffer);
    char *buffer2 = "abc";
    NSString *ret = [NSString stringWithCString:buffer2 encoding:NSASCIIStringEncoding];
    return ret;
//    return buffer;
}

@end
