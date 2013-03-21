//
//  RRAuthenticator.m
//  RemoteResource
//
//  Created by Mateusz Stankiewicz on 3/20/13.
//  Copyright (c) 2013 Mateusz Stankiewicz. All rights reserved.
//

#import "RRAuthenticator.h"

@implementation RRAuthenticator

- (void) addAuthenticationToRequest:(NSMutableURLRequest*)request {
    NSString * reason = [NSString stringWithFormat:@"%@::addAuthenticationToRequest: not implemented.", [self class]];
    @throw [NSException exceptionWithName:@"NotImplementedException" reason:reason userInfo:nil];
}

@end
