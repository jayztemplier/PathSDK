//
//  PathClient.m
//  PathSDK
//
//  Created by jeremy Templier on 12/08/2013.
//  Copyright (c) 2013 jeremy Templier. All rights reserved.
//

#import "PathClient.h"
#import "AFJSONRequestOperation.h"
#import "PStatusCode.h"

#define kClientID @"myclientid"
#define kSecretClientID @"secretClientID"

// Permissions : https://path.com/developers#permissions
#define kPermissionEmailRead @"email_read"
#define kPermissionMomentsWrite @"moments_write"
#define kPermissionFriendsRead @"friends_read"

@interface PathClient ()
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, assign) NSInteger userID;
@end


@implementation PathClient
+ (instancetype)sharedClient {
    static PathClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"https://partner.path.com"]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    return self;
}

#pragma mark - Authentication 
// https://path.com/developers#auth

- (void)grantApplicationRequestWithCompletion:(void (^)(BOOL applicationGranted, PStatusCode *status, NSError *error))completion
{
    NSString *path = @"/oauth2/authenticate";
    NSDictionary *params = @{
                             @"response_type": @"code",
                             @"client_id" : kClientID
                             };
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(YES,
                       [PStatusCode instanceWithCode:operation.response.statusCode],
                       nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(NO,
                       [PStatusCode instanceWithCode:operation.response.statusCode],
                       error);
        }
    }];
}

- (void)authenticateWithCode:(NSString *)code completion:(void (^)(BOOL authenticated, PStatusCode *status, NSError *error))completion
{
    NSString *path = @"/oauth2/access_token";
    NSDictionary *params = @{
                             @"grant_type": @"authorization_code",
                             @"client_id" : kClientID,
                             @"client_secret" : kSecretClientID,
                             @"code" : code
                             };
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            [self setAccessToken:responseObject[@"access_token"]];
            _userID = responseObject[@"userID"] ? [responseObject[@"userID"] integerValue] : 0;
        }

        if (completion) {
            completion(YES,
                       [PStatusCode instanceWithCode:operation.response.statusCode],
                       nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(NO,
                       [PStatusCode instanceWithCode:operation.response.statusCode],
                       error);
        }
    }];
}

- (void)setAccessToken:(NSString *)accessToken
{
    if (_accessToken && ![_accessToken isEqualToString:accessToken]) {
        _accessToken = accessToken ? [accessToken copy] : @"";
        [self setAuthorizationHeaderWithToken:[NSString stringWithFormat:@"Bearer %@", _accessToken]];
    }
}

#pragma mark - Users
// https://path.com/developers#get-user

- (void)getUserWithID:(NSInteger)userID completion:(void (^)(NSDictionary* userDictionary, PStatusCode *status, NSError *error))completion
{
    NSString *path = [NSString stringWithFormat:@"/1/user/%d",userID];
    [self getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *userDictionary = (responseObject && [responseObject isKindOfClass:[NSDictionary class]] ? responseObject[@"user"] : nil);
        if (completion) {
            completion(userDictionary,
                       [PStatusCode instanceWithCode:operation.response.statusCode],
                       nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil,
                       [PStatusCode instanceWithCode:operation.response.statusCode],
                       error);
        }
    }];
}


- (void)getFriendsOfUserWithID:(NSInteger)userID completion:(void (^)(NSArray* friendsArray, PStatusCode *status, NSError *error))completion
{
    NSString *path = [NSString stringWithFormat:@"/1/user/%d/friends",userID];
    [self getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *friendsArray = (responseObject && [responseObject isKindOfClass:[NSDictionary class]] ? responseObject[@"friends"] : nil);
        if (completion) {
            completion(friendsArray,
                       [PStatusCode instanceWithCode:operation.response.statusCode],
                       nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil,
                       [PStatusCode instanceWithCode:operation.response.statusCode],
                       error);
        }
    }];
}

@end
