//
//  MyView.h
//  MyPopView
//
//  Created by 高凯轩 on 2016/11/30.
//  Copyright © 2016年 ggg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyViewModel;
@interface MyView : UIView
+ (MyView *)viewWithDataArray:(NSMutableArray *)array clickTableBlock:(void(^)(MyViewModel*))clickBlock andBGBlock:(void(^)())bgBlock;
@end
