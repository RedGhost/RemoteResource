//
//  RemoteService.m
//  RemoteResource
//
//  Created by Mateusz Stankiewicz on 3/20/13.
//  Copyright (c) 2013 Mateusz Stankiewicz. All rights reserved.
//

#import "RemoteService.h"

static RemoteService * instance;

@implementation RemoteService

+ (void) initialize {
    instance = [[RemoteService alloc] init];
}

+(RemoteService*) instance {
    return instance;
}

- (void) executeAsynchronousRequestWithMethod:(Method)method andParameters:(NSDictionary*)params completionHandler:(ExecuteResponseHandler)handler {
    
}

- (NSObject*) executeSynchronousRequestWithMethod:(Method)method andParameters:(NSDictionary*)params andError:(NSError**)error {
    
}

@end
