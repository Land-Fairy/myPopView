//
//  MyViewCell.m
//  MyPopView
//
//  Created by 高凯轩 on 2016/12/5.
//  Copyright © 2016年 ggg. All rights reserved.
//

#import "MyViewCell.h"
#import "MyViewModel.h"
@interface MyViewCell()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imgV;

@end

@implementation MyViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    self.backgroundColor = [UIColor clearColor];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 22, 22)];
    [self.contentView addSubview:imgV];
    self.imgV = imgV;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(42, 10, 40, 22)];
    [self.contentView addSubview:label];
    [label setTextColor:[UIColor whiteColor]];
    self.label = label;
}

- (void)setModel:(MyViewModel *)model{
    _model = model;
    self.imgV.image = [UIImage imageNamed:model.imgName];
    self.label.text = model.name;
    
}
@end
