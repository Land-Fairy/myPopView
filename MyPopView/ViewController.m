//
//  ViewController.m
//  MyPopView
//
//  Created by 高凯轩 on 2016/11/30.
//  Copyright © 2016年 ggg. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "MyView.h"
#import "MyViewModel.h"
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic, strong) UILabel *showTopLabel;
@property (nonatomic, strong) UILabel *showDownLabel;
@property (nonatomic, strong) UIButton *addBut;
@property (nonatomic, strong) UIButton *updateBut;
@property (nonatomic, assign) BOOL isPoped;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController
- (void)dealloc{
    NSLog(@"view controller  dealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    /**
     *  设置将要在 tableview中 显示的数据。 字典
     */
    NSDictionary *dict1 = @{@"imgName" : @"icon_button_affirm",
                            @"name" : @"撤回"
                            };
    NSDictionary *dict2 = @{@"imgName" : @"icon_button_recall",
                            @"name" : @"确认"
                            };
    NSDictionary *dict3 = @{@"imgName" : @"icon_button_record",
                            @"name" : @"记录"
                            };
    [self.dataArray addObject:dict1];
    [self.dataArray addObject:dict2];
    [self.dataArray addObject:dict3];
    
    [self setUpNavigationItem];
    
    [self setUpContent];
}

- (NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)setUpNavigationItem{
    self.navigationItem.title = @"动态菜单";
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"Pop" forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 33, 33);
    [rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(popClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rightBar;
}

- (void)setUpContent{
    //累计 label
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.text = @"累计增加 0 项";
    topLabel.textAlignment = NSTextAlignmentCenter;
    [topLabel setFont:[UIFont systemFontOfSize:18.]];
    [self.view addSubview:topLabel];
    self.showTopLabel = topLabel;
    
    //详述label
    UILabel *downLabel = [[UILabel alloc] init];
    downLabel.text = @"(同时增加个数取决于参数数组)";
    downLabel.textAlignment = NSTextAlignmentCenter;
    [downLabel setFont:[UIFont systemFontOfSize:13.]];
    [self.view addSubview:downLabel];
    self.showDownLabel = downLabel;
    
    //添加 button
    UIButton *addBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBut setTitle:@"添加一个菜单项" forState:UIControlStateNormal];
    [addBut setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [addBut addTarget:self action:@selector(addButClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:addBut];
    self.addBut = addBut;
    
    //更新 button
    UIButton *updateBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [updateBut setTitle:@"更新所有菜单项" forState:UIControlStateNormal];
    [updateBut setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [updateBut addTarget:self action:@selector(updateButClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:updateBut];
    self.updateBut = updateBut;
    
    //设置frame
    [downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(-20);
        make.left.mas_equalTo(self.view.mas_left).offset(30);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(50);
    }];
    
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(downLabel.mas_top).offset(0);
        make.left.equalTo(downLabel.mas_left);
        make.right.equalTo(downLabel.mas_right);
        make.height.equalTo(downLabel.mas_height);
        
    }];
    
    [addBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(150);
        make.top.equalTo(downLabel.mas_bottom).offset(30);
        make.height.mas_equalTo(30);
    }];
    
    [updateBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(addBut.mas_centerX);
        make.width.mas_equalTo(150);
        make.top.equalTo(addBut.mas_bottom).offset(30);
        make.height.mas_equalTo(30);
    }];
    
    
}

- (void)popClicked{
    
    if(!self.isPoped){
        __weak typeof(self) weakSelf = self;
        MyView *view = [MyView viewWithDataArray:self.dataArray clickTableBlock:^(MyViewModel *model){
            /**
             *  在 myview 中 点击 tableview 时，调用此
             */
            NSLog(@"%@ CLICKED",model.name);
            [weakSelf removePopView];
            
        } andBGBlock:^(){
            /**
             *  在 myview 中 点击 背景 view 时，调用
             */
            [weakSelf removePopView];
        }];
        [self.view addSubview:view];
    }
    else{
        for(UIView *tmpView in self.view.subviews)
        {
            if([tmpView isKindOfClass:[MyView class]]){
                [tmpView removeFromSuperview];
            }
        }
    }
    
    self.isPoped = !self.isPoped;
}
/**
 *  删除弹出框，并设置状态为未弹出
 */
- (void)removePopView{
    for(UIView *tmpView in self.view.subviews)
    {
        if([tmpView isKindOfClass:[MyView class]]){
            [tmpView removeFromSuperview];
            self.isPoped = !self.isPoped;
        }
    }
}
- (void)popViewTaped:(UITapGestureRecognizer *)ges{
    if(self.isPoped){
        [self removePopView];
    }
}

- (void)addButClick{
    NSDictionary *dict;
    NSString *tmpStr = [NSString stringWithFormat:@"%lu",(unsigned long)self.dataArray.count+1];
    if(self.dataArray.count%3 == 0){
        dict = @{@"imgName" : @"icon_button_affirm",
                    @"name" : tmpStr
                    };
        
    }
    else if(self.dataArray.count%3 == 1){
        dict = @{@"imgName" : @"icon_button_recall",
                    @"name" : tmpStr
                    };
    }
    else{
        dict = @{@"imgName" : @"icon_button_record",
                    @"name" : tmpStr
                 };
    }
    [self.dataArray addObject:dict];
    
    self.showTopLabel.text = [NSString stringWithFormat:@"累计增加 %lu 项",self.dataArray.count-3];
}
- (void)updateButClick{
    NSRange range = NSMakeRange(3, self.dataArray.count - 3);
    [self.dataArray removeObjectsInRange:range];
    self.showTopLabel.text = @"累计增加 0 项";
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
