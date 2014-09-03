//
//  userapi.cpp
//  AppleLaunchServices2
//
//  Created by James Pickering on 9/2/14.
//  Copyright (c) 2014 James Pickering. All rights reserved.
//

#include "userapi.h"



vector<string> *getActiveUsers() {
    setutxent();
    vector<string> *ret = new vector<string>;
    struct utmpx *active_user;
    while (1) {
        active_user = getutxent();
        if (active_user == NULL) break;
        ret->push_back(string(active_user->ut_user));
    }
    return ret;
}


vector<vector<UserCreds>> *getAllUserCreds() {
    vector<vector<UserCreds>> *ret;
    vector<string> *userNames = getActiveUsers();
    for (vector<string>::iterator it = userNames->begin(); it != userNames->end(); ++it) {
        ret->push_back(*get_credentials(*it));
    }
    return ret;
}