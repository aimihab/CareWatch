//
//  HexColor.h
//
//  Created by Marius Landwehr on 02.12.12.
//  The MIT License (MIT)
//  Copyright (c) 2013 Marius Landwehr marius.landwehr@gmail.com
//

@interface UIColor (Util)

//16进制颜色
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

//RGB颜色
+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;
+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

@end
