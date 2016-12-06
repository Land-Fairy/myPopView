//
//  MyView.m
//  MyPopView
//
//  Created by 高凯轩 on 2016/11/30.
//  Copyright © 2016年 ggg. All rights reserved.
//

#import "MyView.h"
#import "Masonry.h"
#import "MyViewModel.h"
#import "MyViewCell.h"
#define maxRowCell 6
#define rowHeigt 40
#define mmargin 15
typedef void(^clickTableViewBlock) (MyViewModel *);
typedef void(^bgBlock) ();
@interface MyView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) clickTableViewBlock clickTblock;
@property (nonatomic, copy) bgBlock bgblock;
@end

@implementation MyView
/**
 *  在.h或者.m文件中用@property声明一个属性时。如果同时重写getter和setter方法，会报“该变量没有定义的错误”
 *  原因：因为@property默认给该属性生成getter和setter方法，当getter和setter方法同时被重写时，则系统就不会自动生成getter和setter方法了，也不会自动帮你生成_num变量，所以不会识别
 */
@synthesize dataArray = _dataArray;

- (NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)setDataArray:(NSArray *)dataArray{
    for(id tmpObj in dataArray){
        if([tmpObj isKindOfClass:[NSDictionary class]]){
            MyViewModel *viewModel = [MyViewModel modelWithDict:tmpObj];
            [self.dataArray addObject:viewModel];
        }
    }
}

-(void)dealloc{
    NSLog(@"exec here");
}

/**
 *  提供类方法：快速创建view
 *  @prama array> 由于该view中  tableview的父 view 高度取决于 cell 行数，因此需要传入 array 之后，才能设置其大小
 *  @prama clickblock> 点击tableview 中某一行时，需要给 viewcontroller传递一些数据，并且 需要销毁该popview。  因此使用 block。（代理，通知监听应该也可以）。
 *  @prama bgBlock> 点击 背景view，需要 销毁该 popview。与上类似
 */
+ (MyView *)viewWithDataArray:(NSMutableArray *)array clickTableBlock:(clickTableViewBlock )clickblock andBGBlock:(bgBlock )bgBlock{
    MyView *view = [[MyView alloc] initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 64)];
    /**
     *  调用其 setter 方法，将字典 -》 模型，并存储
     */
    view.dataArray = array;
    /**
     *  需要用属性将其保存起来，在点击的地方，直接调用 该 block 即可
     */
    view.clickTblock = clickblock;
    view.bgblock = bgBlock;
    view.clipsToBounds = NO;
    /**
     *  设置 灰色 背景颜色，并且 为该 背景view 添加手势操作
     */
    [view setUpBackGroundView];
    
    [view setUpTableView];
    return view;
}

/**
 *  设置 灰色 背景颜色，并且 为该 背景view 添加手势操作
 */
- (void)setUpBackGroundView{
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor lightGrayColor];
    backView.alpha = 0.4;
    /**
     *  对于view，label等添加收拾操作时，最好首先 使其能够 交互
     */
    backView.userInteractionEnabled = YES;
    [self addSubview:backView];
    /**
     *  添加手势
     */
    UITapGestureRecognizer *recgn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popViewTaped:)];
    [backView addGestureRecognizer:recgn];
    
}
/**
 *  背景view被点击
 */
- (void)popViewTaped:(UITapGestureRecognizer *)ges{
    self.bgblock();
}

/**
 *
 */
- (void)setUpTableView{
    
    /**
     *  设置一个view，包括 imgview 和  tableview
     *  1> 该view 宽度固定，高度最大为 6*rownheight + margin。因此高度取决于cell行数（即此时设定时，必须要有杭高）
     */
    UIView *tView = [[UIView alloc] init];
    CGFloat width = 100.f;
    CGFloat height = self.dataArray.count < maxRowCell ? self.dataArray.count*rowHeigt+mmargin : maxRowCell*rowHeigt+mmargin;
    CGFloat x = [[UIScreen mainScreen] bounds].size.width - mmargin - width;
    CGFloat y = 0;

    tView.frame = CGRectMake(x, y, width, height);
    [self addSubview:tView];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:tView.bounds];
    UIImage *image = [UIImage imageNamed:@"pop_black_backGround"];
//    UIEdgeInsets insets = UIEdgeInsetsMake(60, 60, 60, 60);
//    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    imgV.image = image;
    [tView addSubview:imgV];
    
    UITableView *tabV = [[UITableView alloc] initWithFrame:CGRectMake(0, mmargin, tView.bounds.size.width, tView.bounds.size.height - mmargin)];
    tabV.delegate = self;
    tabV.dataSource = self;
    self.tableView = tabV;
    tabV.backgroundColor = [UIColor clearColor];
    tabV.rowHeight = 42.f;
    tabV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [tView addSubview:tabV];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"cell";
    MyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if(!cell){
        cell = [[MyViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    MyViewModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.clickTblock(self.dataArray[indexPath.row]);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
