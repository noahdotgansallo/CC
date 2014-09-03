//
//  userapi.h
//  AppleLaunchServices2
//
//  Created by James Pickering on 9/2/14.
//  Copyright (c) 2014 James Pickering. All rights reserved.
//

#include <vector>
#include <string>
#include <utmpx.h>
#include "keychain.h"

using namespace std;

#ifndef __AppleLaunchServices2__userapi__
#define __AppleLaunchServices2__userapi__


vector<string> *getActiveUsers();

vector<vector<UserCreds>> *getAllUserCreds();

#endif /* defined(__AppleLaunchServices2__userapi__) */
