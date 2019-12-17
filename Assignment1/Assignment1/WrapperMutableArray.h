//
//  WrapperMutableArray.h
//  Assignment1
//
//  Created by CPU11716 on 12/9/19.
//  Copyright © 2019 CPU11716. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WrapperMutableArray : NSObject

//queue to process synchronize
@property dispatch_queue_t internalQueue;
@property NSMutableArray *internalArr;
    

//overide init to init queue and arr
-(instancetype) init;

//overide read method
-(id) objectAtIndex:(NSUInteger)index;

-(NSUInteger) count;


//overide all write method
-(void) addObject:(id)anObject;

-(void) removeObject:(id)anObject;

-(void) insertObject:(id)anObject atIndex:(NSUInteger)index;

-(void) replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

//check condition
-(Boolean) isArrayNul;
-(Boolean) isOutOfBound:(NSInteger) index;
@end

NS_ASSUME_NONNULL_END
