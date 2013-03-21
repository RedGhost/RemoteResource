//
//  RRAuthenticator.h
//  RemoteResource
//
//  Created by Mateusz Stankiewicz on 3/20/13.
//  Copyright (c) 2013 Mateusz Stankiewicz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRAuthenticator : NSObject

- (void) addAuthenticationToRequest:(NSMutableURLRequest*)request;

@end
