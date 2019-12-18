//
//  ViewController.m
//  PhoneBookContactManager
//
//  Created by CPU11716 on 12/18/19.
//  Copyright © 2019 CPU11716. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    DContactStore *t=[DContactStore sharedInstance];
    [t checkAuthorizeStatus:^(BOOL granted, NSError * _Nonnull error) {
        if(granted)
        {
            NSLog(@"granted");
            for(int i=0;i<5;i++){
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    //NSMutableArray *arr;
                    [t loadContactWithCompleteHandle:^(NSMutableArray * _Nullable arr, NSError * _Nullable error) {
                        if(error)
                            NSLog(@"%@",[error description]);
                        else
                            for (DContactDTO *contact in arr) {
                                NSLog(@"%i - %@",i,[contact description]);
                                
                            }
                    }];
                });
            }
        }
        
        else
            NSLog(@"denie");
    }];
}


@end
