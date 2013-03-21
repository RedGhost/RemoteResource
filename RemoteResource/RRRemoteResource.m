//
//  RemoteResource.m
//  RemoteResource
//
//  Created by Mateusz Stankiewicz on 3/20/13.
//  Copyright (c) 2013 Mateusz Stankiewicz. All rights reserved.
//

#import "RRRemoteResource.h"
#import "RRRemoteService.h"

@implementation RRRemoteResource

- (id)initWithIdentifier:(id)identifier andData:(NSDictionary*)data {
    if(self = [super init]) {
        _identifier = identifier;
        _data = data;
        _updatedData = [[NSMutableDictionary alloc] initWithCapacity:[_data count]];
    }
    return self;
}

+ (NSString*)pathForIdentifier:(id)identifier {
    NSString * reason = [NSString stringWithFormat:@"%@::pathForIdentifier: not implemented.", [self class]];
    @throw [NSException exceptionWithName:@"NotImplementedException" reason:reason userInfo:nil];
}

+ (void) fetch:(id)identifier completionHandler:(FetchResponseHandler)handler {
    NSParameterAssert(identifier);
    NSParameterAssert(handler);
    
    [[RRRemoteService instance] executeAsynchronousRequestWithMethod:GET andPath:[self pathForIdentifier:identifier] andParameters:nil completionHandler:^(NSObject *resource, NSError *error) {
        if(resource != nil) {
            if([resource isKindOfClass:[NSDictionary class]]) {
                handler([[[self class] alloc] initWithIdentifier:identifier andData:(NSDictionary*)resource], nil);
            }
            else {
                // TODO: fix errors
                handler(nil, [NSError errorWithDomain:@"RRRemoteResourceDomain" code:1 userInfo:nil]);
            }
        }
        else {
            handler(nil, error);
        }
    }];
}

+ (id) fetch:(id)identifier withError:(NSError**)error {
    NSParameterAssert(identifier);

    return [[RRRemoteService instance] executeSynchronousRequestWithMethod:GET andPath:[self pathForIdentifier:identifier] andParameters:nil andError:error];
}

- (void) saveWithCompletionHandler:(SaveResponseHandler)handler {
    if([_updatedData count] == 0) {
        if(handler != nil) handler(YES, nil);
        return;
    }
    
    [[RRRemoteService instance] executeAsynchronousRequestWithMethod:POST andPath:[[self class] pathForIdentifier:_identifier] andParameters:[_data dictionaryByMergingWith:_updatedData] completionHandler:^(NSObject *resource, NSError *error) {
        if(handler != nil) {
            if(resource != nil) {
                handler(YES, nil);
            }
            else {
                handler(nil, error);
            }
        }
    }];
}

- (BOOL) saveWithError:(NSError**)error {
    if([_updatedData count] == 0) {
        return YES;
    }
    
    return ([[RRRemoteService instance] executeSynchronousRequestWithMethod:POST andPath:[[self class] pathForIdentifier:_identifier] andParameters:[_data dictionaryByMergingWith:_updatedData] andError:error] != nil);
}

@end
