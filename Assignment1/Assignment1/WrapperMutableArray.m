//
//  WrapperMutableArray.m
//  Assignment1
//
//  Created by CPU11716 on 12/9/19.
//  Copyright © 2019 CPU11716. All rights reserved.
//

#import "WrapperMutableArray.h"

@implementation WrapperMutableArray

-(instancetype) init{
    
    self=[super init];
    if(self){
        //init with concurrent queue for allow read in more than one thread
        myQueue=dispatch_queue_create("wrapper queue", DISPATCH_QUEUE_CONCURRENT);
        myArr=[[NSMutableArray alloc] init];
    }
    
    return self;
}

//========================================
-(id) objectAtIndex:(NSUInteger)index{
    
//    NSLog(@"pre get object %ld",index);
//    return [myArr objectAtIndex:index];

    
    id __block obj=nil;
    dispatch_sync(myQueue, ^{
        NSLog(@"pre get object %ld",index);
        obj= [self->myArr objectAtIndex:index];
    });

    return obj;
}

-(NSUInteger) count{
    NSUInteger __block c;
    
    dispatch_sync(myQueue, ^{
        c= [self->myArr count];
    });
    
    return c;
}


//========================================
-(void) addObject:(id)anObject{
//    NSLog(@"pre add object %@",anObject);
//    [myArr addObject:anObject];
//    NSLog(@"added object %@",anObject);
    
    
    dispatch_barrier_sync(myQueue, ^{
        NSLog(@"pre add object %@",anObject);
        [self->myArr addObject: anObject];
        NSLog(@"added object %@",anObject);
    });
}

-(void) removeObject:(id)anObject{
//    [myArr removeObject:anObject];
//    NSLog(@"remove object %@",anObject);
    
    dispatch_barrier_sync(myQueue, ^{
        NSLog(@"pre remove object %@",anObject);
        [self->myArr removeObject:anObject];
        NSLog(@"removed object %@",anObject);
        
    });
}

-(void) insertObject:(id)anObject atIndex:(NSUInteger)index{
//    [myArr insertObject:anObject atIndex:index];
//    NSLog(@"insert object at %ld",index);
    
    dispatch_barrier_sync(myQueue, ^{
        NSLog(@"pre insert object %@",anObject);
        [self->myArr insertObject:anObject atIndex:index];
        NSLog(@"inserted object %@",anObject);
        
    });
}

-(void) replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
//    [myArr replaceObjectAtIndex:index withObject:anObject];
//    NSLog(@"replace object at %@",anObject);
    
    
    dispatch_barrier_sync(myQueue, ^{
        NSLog(@"pre replace object at %@",anObject);
        [self->myArr replaceObjectAtIndex:index withObject:anObject];
        NSLog(@"replaced object at %@",anObject);
        
    });
}

@end
