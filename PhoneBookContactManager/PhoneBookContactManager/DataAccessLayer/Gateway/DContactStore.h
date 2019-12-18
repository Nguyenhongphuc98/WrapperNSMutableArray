//
//  DContactStore.h
//  PhoneBookContactManager
//
//  Created by CPU11716 on 12/18/19.
//  Copyright © 2019 CPU11716. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DContactDTO.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^loadContactCompleteHandle)(NSMutableArray * _Nullable contactDTOArray, NSError *_Nullable error);

@interface DContactStore : NSObject

@property NSMutableArray *loadContactCompleteHandleArray;
@property dispatch_queue_t serialTaskqueue;
@property BOOL isLoadingContact;

+(instancetype) sharedInstance;

-(instancetype) init;

-(void) checkAuthorizeStatus:(void(^) (BOOL granted, NSError *error)) callBack;

-(void) loadContactWithCompleteHandle: (loadContactCompleteHandle) callback;

-(void) responseContactForCallback: (NSError * _Nullable) error contactDTOArray: (NSMutableArray * _Nullable) contacts;

@end

NS_ASSUME_NONNULL_END
