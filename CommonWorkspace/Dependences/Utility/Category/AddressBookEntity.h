//
//  AddressBookEntity.h
//  iSing
//
//  Created by nannan liu on 13-7-1.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressBookEntity : NSObject
{
    NSString *name;
    NSMutableArray *telArray;
    NSInteger sectionNumber;
}
@property(retain, nonatomic)NSString *name;
@property(retain, nonatomic)NSMutableArray *telArray;
@property(assign, nonatomic)NSInteger sectionNumber;
@end

@interface AddressBookModel : NSObject
{
    NSString *name;
    NSMutableArray *email;
    NSMutableArray *tel;
    NSData *imageData;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *email;
@property (nonatomic, retain) NSMutableArray *tel;
@property (nonatomic, strong) NSData *imageData;

@end
