//
//  DeviceModel.m
//  Q2_local
//
//  Created by Vecklink on 14-7-15.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "DeviceModel.h"

@implementation DeviceModel

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_nickName forKey:@"nickName"];
    [encoder encodeObject:_avatar forKey:@"avatar"];
    // [encoder encodeObject:_avatarUrl forKey:@"avatarUrl"];
    [encoder encodeObject:[NSNumber numberWithInt:_electricity] forKey:@"electricity"];
    
    [encoder encodeObject:_phoneNumber forKey:@"phoneNumber"];
    [encoder encodeObject:_devHeight forKey:@"deheight"];
    [encoder encodeObject:_devWeight forKey:@"deweight"];
    
    [encoder encodeObject: [NSNumber numberWithInteger:_devSex] forKey:@"desex"];
    [encoder encodeObject:_bindIMEI forKey:@"bindIMEI"];
    [encoder encodeObject:_bleMac forKey:@"bleMac"];
    [encoder encodeObject:_musicItem forKey:@"musicItem"];
    [encoder encodeObject:[NSNumber numberWithInt:_modeType] forKey:@"modeType"];         //情景模式
    [encoder encodeObject:[NSNumber numberWithInt:_locationType] forKey:@"locationType"]; //定位模式
    [encoder encodeObject:[NSNumber numberWithInt:_isAdmin] forKey:@"isAdmin"];           //管理员状态
    [encoder encodeObject:@(_isGpsOn) forKey:@"isGpsOn"];                                 //Gps开关状态
    
    [encoder encodeObject:[NSNumber numberWithDouble:_la] forKey:@"la"];
    [encoder encodeObject:[NSNumber numberWithDouble:_lo] forKey:@"lo"];
    [encoder encodeObject:[NSNumber numberWithInt:_positioningType] forKey:@"positioningType"];
    
    [encoder encodeObject:_remoteCare forKey:@"remoteCare"];
    [encoder encodeObject:_messageArr forKey:@"messageArr"];
    [encoder encodeObject:_setPhoneNumberArr forKey:@"setPhoneNumber"];
    [encoder encodeObject:_trustPhoneNumberArr forKey:@"trustPhoneNumber"];
    [encoder encodeObject:@(_online) forKey:@"online"];
    [encoder encodeObject:@(_isFallOff) forKey:@"isFallOff"];
    //Care
    [encoder encodeObject:[NSNumber numberWithInteger:_careInterval] forKey:@"careInterval"];
    [encoder encodeObject:[NSNumber numberWithInteger:_careDist] forKey:@"careDist"];
    [encoder encodeObject:_nowDist forKey:@"nowDist"];
    [encoder encodeObject:[NSNumber numberWithInt:_careType] forKey:@"careType"];
    
    //闹钟
    [encoder encodeObject:_repeatDate forKey:@"repeatDate"];
    [encoder encodeObject:_clockTime forKey:@"clockTime"];
    
    //记步数据
    [encoder encodeObject:[NSNumber numberWithInteger:_goalSteps] forKey:@"goalSteps"];
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        _nickName = [decoder decodeObjectForKey:@"nickName"];
        _avatar = [decoder decodeObjectForKey:@"avatar"];
        // _avatarUrl = [decoder decodeObjectForKey:@"avatarUrl"];
        _electricity = [[decoder decodeObjectForKey:@"electricity"] intValue];
        _online = [[decoder decodeObjectForKey:@"online"] boolValue];
        _isFallOff = [[decoder decodeObjectForKey:@"isFallOff"] boolValue];
        _phoneNumber = [decoder decodeObjectForKey:@"phoneNumber"];
        _bindIMEI = [decoder decodeObjectForKey:@"bindIMEI"];
        _bleMac = [decoder decodeObjectForKey:@"bleMac"];
        _musicItem = [decoder decodeObjectForKey:@"musicItem"];
        _devHeight = [decoder decodeObjectForKey:@"deheight"];
        _devWeight = [decoder decodeObjectForKey:@"deweight"];
        _devSex = [[decoder decodeObjectForKey:@"desex"] intValue];
        _modeType = [[decoder decodeObjectForKey:@"modeType"] intValue];
        _locationType = [[decoder decodeObjectForKey:@"locationType"] intValue];
        _isAdmin = [[decoder decodeObjectForKey:@"isAdmin"] intValue];
        _isGpsOn = [[decoder decodeObjectForKey:@"isGpsOn"] boolValue];
        
        if (_musicItem) {
            if ([_musicItem isKindOfClass:[NSDictionary class]]) {
                NSString *mp3Title = ((NSDictionary *)_musicItem)[@"title"];
                NSString *mp3Path = [[NSBundle mainBundle] pathForResource:mp3Title ofType:@"mp3"];
                _musicItem = [NSDictionary dictionaryWithObjectsAndKeys:mp3Title, @"title", mp3Path, @"mp3Path", nil];
            }
        } else {
            NSString *mp3Path = [[NSBundle mainBundle] pathForResource:@"music1" ofType:@"mp3"];
            _musicItem = [NSDictionary dictionaryWithObjectsAndKeys:@"music1", @"title", mp3Path, @"mp3Path", nil];
        }
        
        _la = [[decoder decodeObjectForKey:@"la"] doubleValue];
        _lo = [[decoder decodeObjectForKey:@"lo"] doubleValue];
        _positioningType = [[decoder decodeObjectForKey:@"positioningType"] intValue];
        
        _remoteCare = [decoder decodeObjectForKey:@"remoteCare"];
        _setPhoneNumberArr = [decoder decodeObjectForKey:@"setPhoneNumber"];
        if (_setPhoneNumberArr == nil)
        {
            _setPhoneNumberArr = [NSMutableArray array];
            
        }
        
        _trustPhoneNumberArr = [decoder decodeObjectForKey:@"trustPhoneNumber"];
        
        if (_trustPhoneNumberArr == nil)
        {
            _trustPhoneNumberArr = [NSMutableArray array];
            
        }
        
        //记步
        _careInterval = [[decoder decodeObjectForKey:@"goalSteps"] integerValue];
        
        
        //闹钟
        _clockTime = [decoder decodeObjectForKey:@"clockTime"];
        _repeatDate = [decoder decodeObjectForKey:@"repeatDate"];
        if (_repeatDate == nil)
        {
            _repeatDate = [NSMutableArray array];
            
        }
        
        
        
        //Care
        _careDist = [[decoder decodeObjectForKey:@"careDist"] intValue];
        _nowDist = [decoder decodeObjectForKey:@"nowDist"];
        _careType = [[decoder decodeObjectForKey:@"careType"] intValue];
        _careInterval = [[decoder decodeObjectForKey:@"careInterval"] integerValue];
        
        if (![[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"%@-nowDist", _bindIMEI]]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:[NSString stringWithFormat:@"%@-nowDist", _bindIMEI]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        //消息中心
        _messageArr = [decoder decodeObjectForKey:@"messageArr"];
        if (!_messageArr.count) {
            
            MessageModel *msg = [[MessageModel alloc] initWithContent:@"欢迎使用关爱APP，时刻关爱您的小孩"];
            [_messageArr addObject:msg];
        }
    }
    return  self;
}

-(instancetype)initWithName:(NSString *)name phone:(NSString *)phone imei:(NSString *)imei bleMac:(NSString *)bleMac withUrl:(NSString *)url{
    self = [super init];
    if (self) {
        
        //默认设置
        _nickName = name;
        _phoneNumber = phone;
        
        _bindIMEI = imei;
        _bleMac = bleMac;
        
        NSString *mp3Path = [[NSBundle mainBundle] pathForResource:@"music1" ofType:@"mp3"];
        _musicItem = [NSDictionary dictionaryWithObjectsAndKeys:@"music1", @"title", mp3Path, @"mp3Path", nil];
        //        if(![url isKindOfClass:[NSNull class]] && ![url isEqualToString:@""])
        //        {
        //            _avatar = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        //        } else {
        //            _avatar=UIImagePNGRepresentation([UIImage imageNamed:@"icon_default_head_3"]);
        //        }
        
        if([NSData dataWithContentsOfURL:[NSURL URLWithString:url]])
        {
            _avatar = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            
            DLog(@"*********%@",_avatar);
        } else {
            _avatar = UIImagePNGRepresentation([UIImage imageNamed:@"icon_default_head_3"]);
        }
        
        
        _avatarUrl=url;
        
        _isFallOff = NO;   //未脱落
        _online = NO;      //在线状态(不)
        _modeType = 0;     // 标准模式
        _locationType = 0; // 定位模式
        _isGpsOn = NO;     // GpS开关
        
        _electricity = 0;   //电量
        _careInterval = 15; //关爱间隔
        _careDist = 100;    //关爱距离
        _goalSteps = 0;     //记步目标数
        _la = -1;
        _lo = -1;
        
        _remoteCare = [NSMutableArray array];
        _messageArr = [NSMutableArray array];
        _repeatDate = [NSMutableArray array];
        _setPhoneNumberArr = [NSMutableArray array];
        _trustPhoneNumberArr = [NSMutableArray array];
        MessageModel *msg = [[MessageModel alloc] initWithContent:@"欢迎使用关爱APP，时刻关爱您的小孩"];
        [_messageArr addObject:msg];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:[NSString stringWithFormat:@"%@-nowDist", _bindIMEI]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return self;
}

-(void)setCareWithCareDist:(NSInteger)careDist type:(int)type {
    _careDist = (int)careDist;
    _careType = type;
}

-(void)addRemoteCare:(NSString *)str date:(NSDate *)date {
    [_remoteCare addObject:[NSDictionary dictionaryWithObjectsAndKeys:str, @"location", date, @"date", nil]];
}
-(void)addMessage:(NSString *)str date:(NSDate *)date {
    
}

@end
