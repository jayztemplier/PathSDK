//
//  PathClient.h
//  PathSDK
//
//  Created by jeremy Templier on 12/08/2013.
//  Copyright (c) 2013 jeremy Templier. All rights reserved.
//

#import "AFHTTPClient.h"

@interface PathClient : AFHTTPClient
+ (instancetype)sharedClient;
@end
