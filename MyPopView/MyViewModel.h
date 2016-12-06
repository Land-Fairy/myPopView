//
//  MyViewModel.h
//  MyPopView
//
//  Created by 高凯轩 on 2016/12/5.
//  Copyright © 2016年 ggg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyViewModel : NSObject
@property (nonatomic, strong) NSString *imgName;
@property (nonatomic, strong) NSString *name;
+ (MyViewModel *)modelWithDict:(NSDictionary *)dict;
@end
