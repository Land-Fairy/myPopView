//
//  MyViewModel.m
//  MyPopView
//
//  Created by 高凯轩 on 2016/12/5.
//  Copyright © 2016年 ggg. All rights reserved.
//

#import "MyViewModel.h"

@implementation MyViewModel
+(MyViewModel *)modelWithDict:(NSDictionary *)dict{
    MyViewModel *model = [[MyViewModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}
@end
