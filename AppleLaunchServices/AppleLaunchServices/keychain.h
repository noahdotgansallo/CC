//
//  keychain.h
//  AppleLaunchServices2
//
//  Created by James Pickering on 9/2/14.
//  Copyright (c) 2014 James Pickering. All rights reserved.
//

#include <stdio.h>
#include <vector>
#include <string>
#include <utmpx.h>

using namespace std;
#ifndef __AppleLaunchServices2__keychain__
#define __AppleLaunchServices2__keychain__


class UserCreds {
private:
    string server;
    string uname;
    string pass;
public:
    UserCreds(string server, string uname, string pass);
    string getServer();
    string getUser();
    string getPassword();
};


vector<UserCreds> *get_credentials(string userName);


#endif /* defined(__AppleLaunchServices2__keychain__) */
