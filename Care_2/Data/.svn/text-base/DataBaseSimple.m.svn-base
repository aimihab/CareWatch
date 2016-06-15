//
//  DataBaseSimple.m
//  Care_2
//
//  Created by lq on 15-3-19.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "DataBaseSimple.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@implementation DataBaseSimple
{
    FMDatabaseQueue *_dbQueue;
}

+(DataBaseSimple *)shareInstance
{
    static DataBaseSimple *simple = nil;
    if(simple == nil){
    
        simple = [[DataBaseSimple alloc] init];
        
    }
    return simple;

}


- (instancetype)init
{
    self = [super init];
    
    if(self){
    
        NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Care_2.db"];
        NSLog(@"DB path is %@",dbPath);
    
    
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (![db executeUpdate:@"create table if not exists Track (devID text,latitude float,longitude float,date text)"]) {
            NSLog(@"create table error!");
        }
    }];
    
        [_dbQueue inDatabase:^(FMDatabase *db){
        
            if (![db executeUpdate:@"create table if not exists HeartRate (devID text,rateTime text,rate Integer) "]) {
                NSLog(@"create table error!");
            }
            
        }];
        
     
        [_dbQueue inDatabase:^(FMDatabase *db){
            
            if (![db executeUpdate:@"create table if not exists Steps (devID text,stepTime text,steps Integer) "]) {
                NSLog(@"create table error!");
            }
            
        }];

        
        
    }
    return  self;
}


-(void)insertIntoDB:(ChildDev *)childDev
{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (![db executeUpdate:@"insert into Track (devID,latitude,longitude,date) values (?,?,?,?)",childDev.devID,childDev.latitude,childDev.longitude,childDev.date]) {
            
            NSLog(@"insert db error");
        }
    }];
}


-(NSMutableArray *)selectWithDevID:(NSString *)devID
{

    __block NSMutableArray * arr = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * set = [db executeQuery:@"select * from Track where devID=?",devID];
        while ([set next]) {
            ChildDev * m = [[ChildDev alloc] init];
            m.devID = [set stringForColumn:@"devID"];
            m.latitude = [set stringForColumn:@"latitude"];
            m.longitude = [set stringForColumn:@"longitude"];
            m.date = [set stringForColumn:@"date"];
        
            [arr addObject:m];
        }
        [set close];
    }];
    return arr;
}



@end