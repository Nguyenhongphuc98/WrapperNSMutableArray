//
//  WrapperMutableArray.m
//  Assignment1
//
//  Created by CPU11716 on 12/9/19.
//  Copyright © 2019 CPU11716. All rights reserved.
//

#import "WrapperMutableArray.h"

@implementation WrapperMutableArray

@synthesize internalArr,internalQueue;

-(instancetype) init{
    
    self=[super init];
    
    if(self){
        //init with concurrent queue for allow read in more than one thread
        internalQueue = dispatch_queue_create("wrapper queue", DISPATCH_QUEUE_CONCURRENT);
        internalArr = [[NSMutableArray alloc] init];
    }
    
    return self;
}

//========================================
-(id) objectAtIndex:(NSUInteger)index{
    //check conditon
    if(self.isArrayNul)
    {
        NSLog(@"null exception: interal array is null from objectAtIndex:%ld method",index);
        return nil;
    }
    
    if([self isOutOfBound:index])
    {
        NSLog(@"out of bound exception: internal array size:%ld, your index:%ld",[self.internalArr count],index);
        return nil;
    }

    //get object
    id __block obj = nil;
    dispatch_sync(internalQueue, ^{
        NSLog(@"pre get object %ld",index);
        obj = [self->internalArr objectAtIndex:index];
    });

    return obj;
}

-(NSUInteger) count{
    
    //check conditon
    if(self.isArrayNul)
    {
        NSLog(@"null exception: interal array is null from count method");
        return 0;
    }
    
    NSUInteger __block c;
    dispatch_sync(internalQueue, ^{
        c= [self->internalArr count];
    });
    
    return c;
}


//========================================
-(void) addObject:(id)anObject{
    
    //check conditon
    if(self.isArrayNul)
    {
        NSLog(@"null exception: interal array is null from addObject method");
        return ;
    }
    
    if(anObject==nil)
    {
        NSLog(@"null exception: add null object to internal array");
        return ;
    }
    
    dispatch_barrier_sync(internalQueue, ^{
        NSLog(@"pre add object %@",anObject);
        [self->internalArr addObject: anObject];
        NSLog(@"added object %@",anObject);
    });
}

-(void) removeObject:(id)anObject{
    
    //check conditon
    if(self.isArrayNul)
    {
        NSLog(@"null exception: interal array is null from removeObject method");
        return ;
    }
    
    if(anObject==nil)
    {
        NSLog(@"null exception: remove null object to internal array");
        return ;
    }

    dispatch_barrier_sync(internalQueue, ^{
        NSLog(@"pre remove object %@",anObject);
        [self->internalArr removeObject:anObject];
        NSLog(@"removed object %@",anObject);
    });
}

-(void) insertObject:(id)anObject atIndex:(NSUInteger)index{
    
    //check conditon
    if(self.isArrayNul)
    {
        NSLog(@"null exception: interal array is null from insertObject atIndex:%ld method",index);
        return ;
    }
    
    if([self isOutOfBound:index])
    {
        NSLog(@"out of bound exception: internal array size:%ld, your index:%ld",[self.internalArr count],index);
        return ;
    }
    
    if(anObject==nil)
    {
        NSLog(@"null exception: insert null object to internal array");
        return ;
    }

    dispatch_barrier_sync(internalQueue, ^{
        NSLog(@"pre insert object %@",anObject);
        [self->internalArr insertObject:anObject atIndex:index];
        NSLog(@"inserted object %@",anObject);
    });
}

-(void) replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{

    //check conditon
    if(self.isArrayNul)
    {
        NSLog(@"null exception: interal array is null from replaceObject atIndex:%ld method",index);
        return ;
    }
    
    if([self isOutOfBound:index])
    {
        NSLog(@"out of bound exception: internal array size:%ld, your index:%ld",[self.internalArr count],index);
        return ;
    }
    
    if(anObject==nil)
    {
        NSLog(@"null exception: replace null object to internal array");
        return ;
    }
    
    dispatch_barrier_sync(internalQueue, ^{
        NSLog(@"pre replace object at %@",anObject);
        [self->internalArr replaceObjectAtIndex:index withObject:anObject];
        NSLog(@"replaced object at %@",anObject);
    });
}

//===================================
-(Boolean) isArrayNul{
    if(internalArr==nil)
        return YES;
    else
        return NO;
}

-(Boolean) isOutOfBound:(NSInteger)index{
    if(internalArr != nil && index < internalArr.count&&index>-1)
        return NO;
    return YES;
}

@end
