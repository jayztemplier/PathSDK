//
//  PStatusCode.m
//  PathSDK
//
//  Created by jeremy Templier on 12/08/2013.
//  Copyright (c) 2013 jeremy Templier. All rights reserved.
//

#import "PStatusCode.h"

@implementation PStatusCode

+ (PStatusCode *)instanceWithCode:(NSInteger)code
{
    return [[self alloc] initWithCode:code];
}

- (instancetype)initWithCode:(NSInteger)code
{
    self = [super init];
    if (self) {
        _code = code;
    }
    return self;
}

- (NSString *)message
{
    NSString *result;
    switch (_code) {
        case 200:
            result = @"Ok";
            break;
        case 201:
            result = @"Resource created";
            break;
        case 202:
            result = @"Accepted for processing";
            break;
        case 400:
            result = @"Invalid or bad argument";
            break;
        case 401:
            result = @"Request is unauthorized";
            break;
        case 403:
            result = @"Access to resource denied";
            break;
        case 404:
            result = @"Resource not found";
            break;
        case 429:
            result = @"Rate limit exceeeded";
            break;
        case 500:
            result = @"Internal server error";
            break;
            
        default:
            result = @"Unknown error";
            break;
    }
    return result;
}
@end
