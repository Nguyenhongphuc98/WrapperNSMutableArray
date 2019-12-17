//
//  main.m
//  Assignment1
//
//  Created by CPU11716 on 12/9/19.
//  Copyright © 2019 CPU11716. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "WrapperMutableArray.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        
        dispatch_queue_t q=dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
        WrapperMutableArray * arr=[[WrapperMutableArray alloc] init];
       
        //TEST WRITE METHOD
        for (int i=0; i<10; i++) {
            dispatch_async(q, ^{
                NSString *obj =[NSString stringWithFormat:@"object %i",i];
                [arr addObject:obj];
            });
        }


        sleep(5);
        NSLog(@"complete!");
        
    }
    return 0;
}
