//
//  RemoteService.h
//  RemoteResource
//
//  Created by Mateusz Stankiewicz on 3/20/13.
//  Copyright (c) 2013 Mateusz Stankiewicz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRAuthenticator.h"
#import "RRDataConverter.h"

@interface RRRemoteService : NSObject

@property (assign, nonatomic) NSTimeInterval timeoutInterval;
@property (strong, nonatomic) NSURL * endpointURL;
@property (strong, nonatomic) RRAuthenticator * authenticator;
@property (strong, nonatomic) RRDataConverter * converter;

typedef enum {
    GET,
    POST,
    DELETE,
    PUT
} HTTPMethod;

+ (RRRemoteService*)instance;

- (void)setEndpointURLWithString:(NSString*)string;

typedef void (^ExecuteResponseHandler)(NSObject * resource, NSError * error);
- (void) executeAsynchronousRequestWithMethod:(HTTPMethod)method andPath:(NSString*)path andParameters:(NSDictionary*)params completionHandler:(ExecuteResponseHandler)handler;
- (NSObject*) executeSynchronousRequestWithMethod:(HTTPMethod)method andPath:(NSString*)path andParameters:(NSDictionary*)params andError:(NSError**)error;

@end
