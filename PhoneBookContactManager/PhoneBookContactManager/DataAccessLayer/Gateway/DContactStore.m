//
//  DContactStore.m
//  PhoneBookContactManager
//
//  Created by CPU11716 on 12/18/19.
//  Copyright © 2019 CPU11716. All rights reserved.
//

#import "DContactStore.h"

@implementation DContactStore

+(instancetype) sharedInstance{
    static DContactStore *sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        sharedInstance= [[DContactStore alloc] init];
    });
    
    return sharedInstance;
}

-(instancetype) init{
    self=[super init];
    
    if(self){
        _loadContactCompleteHandleArray = [[NSMutableArray alloc] init];
        _serialTaskqueue = dispatch_queue_create("main task queue", DISPATCH_QUEUE_SERIAL);
        _isLoadingContact = NO;
    }
    
    return self;
}

-(void) checkAuthorizeStatus:(void (^)(BOOL, NSError * _Nullable))callBack{
    
    CNEntityType entityType = CNEntityTypeContacts;
    CNAuthorizationStatus authorizationStatus=[CNContactStore authorizationStatusForEntityType:entityType];
    
    switch (authorizationStatus) {
        case CNAuthorizationStatusNotDetermined:
        {
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:entityType completionHandler:^(BOOL granted, NSError * _Nullable error) {
                callBack(granted,error);
            }];
            break;
        }
            
        case CNAuthorizationStatusAuthorized:
        {
            callBack(YES,nil);
            break;
        }
            
        case CNAuthorizationStatusDenied:
        {
            callBack(NO,nil);
            break;
        }
            
        case CNAuthorizationStatusRestricted:
        {
            callBack(NO,nil);
            break;
        }
            
        default:
            callBack(NO,nil);
            break;
    }
}

-(void) loadContactWithCompleteHandle:(loadContactCompleteHandle)callback{
    
    //block nil can make crash app
    if(callback==nil)
        return;
    
    dispatch_async(_serialTaskqueue, ^{
        
        //add block to array to transfer later
        [self.loadContactCompleteHandleArray addObject:callback];
        
        //don't load contact when have other thread is loading from device or transfer data to callbaclk
        if(self.isLoadingContact)
            return;
        
        self.isLoadingContact=YES;
        
        //loading on other thead to don't have wait to add block to completeHandle array
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            if([CNContactStore class])
            {
                CNContactStore *contactStore = [[CNContactStore alloc] init];
                NSArray *keysToFetch = @[CNContactIdentifierKey,
                                         CNContactFamilyNameKey, //ten
                                         CNContactMiddleNameKey, //ten dem
                                         CNContactGivenNameKey,  //ho
                                         CNContactPhoneNumbersKey,
                                         CNContactImageDataKey];
                
                CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
                fetchRequest.predicate = nil;
                NSError *errorFetchContact;
                
                NSMutableArray *contactArray =[[NSMutableArray alloc] init];
                BOOL resultEnumerate = [contactStore enumerateContactsWithFetchRequest:fetchRequest error:&errorFetchContact usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                    if(errorFetchContact == nil && contact != nil){
                        NSLog(@"givename: %@", contact.givenName);
//                        NSLog(@"identifi: %@", contact.identifier);
//                        NSLog(@"middleName: %@", contact.middleName);
//                        NSLog(@"namePrefix: %@", contact.familyName);
//                        NSLog(@"phones: %@", contact.phoneNumbers);
//                        NSLog(@"img: %@", contact.imageData);
                        
                        DContactDTO *contactDTO = [[DContactDTO alloc] initWithCNContact:contact];
                        [contactArray addObject:contactDTO];
                    }
                }];
                
                if(resultEnumerate==YES)
                    [self responseContactForCallback:nil contactDTOArray:contactArray];
                else
                    [self responseContactForCallback:errorFetchContact contactDTOArray:nil];
                
            }
        });
    });
}

-(void) responseContactForCallback:(NSError * _Nullable)error contactDTOArray:(NSMutableArray * _Nullable)contacts{
    
    //transfer on one queue (serial task queue) with addblock to make sure no block added when transfering
    dispatch_async(self.serialTaskqueue, ^{
        
        //using for transfer and avoid remove object needed when remove object from contacts (async)
        NSMutableArray * contactForTransferArray =[[NSMutableArray alloc] init];
        if(contacts!=nil){
            contactForTransferArray = [contacts copy];
        }
        
        for (loadContactCompleteHandle callback in self.loadContactCompleteHandleArray) {
            if(callback!=nil){
                NSLog(@"callback!= nill");
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    callback(contactForTransferArray,error);
                });
            }
            else
                NSLog(@"callback== nill");
        }
        
        //refesh data for next time
        [self.loadContactCompleteHandleArray removeAllObjects];
        self.isLoadingContact = NO;
    });
}
@end
