//
//  KJAlertView.m
//  MoLiao
//
//  Created by 杨科军 on 2018/7/25.
//  Copyright © 2018年 杨科军. All rights reserved.
//

#import "KJAlertView.h"

#define UIColorFromHEXA(hex,a)    [UIColor colorWithRed:((hex&0xFF0000)>>16)/255.0f green:((hex&0xFF00)>>8)/255.0f blue:(hex&0xFF)/255.0f alpha:a]
#define SystemFontSize(fontsize)  [UIFont systemFontOfSize:(fontsize)]

// 判断是否为iPhone X 系列  这样写消除了在Xcode10上的警告。
#define iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})
// 屏幕总尺寸
#define kScreenWidth        [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight       [[UIScreen mainScreen] bounds].size.height
// 没有tabar 距 底边高度
#define kBOTTOM_SPACE_HEIGHT (iPhoneX?34.0f:0.0f)

@interface KJAlertView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) KJAlertBlock myBlock;
@property (nonatomic, assign) KJAlertViewType type;

@property (nonatomic, assign) CGFloat bottomHeader;

@property (nonatomic, strong) NSString   *title;// 提示标题
@property (nonatomic, strong) NSString   *contentStr;// 提示内容
@property (nonatomic, strong) NSArray    *titleArray;// 按钮标题数组

@property (nonatomic, strong) UIButton     *bgView;
@property (nonatomic, strong) UIView       *centerView;
@property (nonatomic, strong) UITableView  *bottomView;

//*****************  颜色相关  *******************
@property(nonatomic,strong) UIColor *lineColor;  // 线颜色
@property(nonatomic,strong) UIColor *cancleColor;  // 取消颜色
@property(nonatomic,strong) UIColor *titleColor;   // 标题颜色
@property(nonatomic,strong) UIColor *textColor;    // 文字颜色
// center
@property(nonatomic,strong) UIColor *centerViewColor;  // 视图颜色

// bottom
@property(nonatomic,strong) UIColor *bottomViewColor;  // 视图颜色
@property(nonatomic,strong) UIColor *spaceColor;   // 间隙颜色

@end

@implementation KJAlertView

- (void)_config{
    self.bottomHeader = 0.1;
    self.lineColor    = UIColorFromHEXA(0xeeeeee, 1);
    self.spaceColor   = UIColorFromHEXA(0xe8e8e8, 1);
    self.cancleColor  = UIColor.redColor;
    self.textColor    = UIColor.blueColor;
    self.titleColor   = UIColor.blackColor;
    self.centerViewColor = UIColor.whiteColor;
    self.bottomViewColor = UIColor.whiteColor;
    
    self.backgroundColor = UIColorFromHEXA(0x333333, 0.3);
}

/// 初始化
+ (instancetype)createAlertViewWithType:(KJAlertViewType)type Title:(NSString *)title Content:(NSString *)content DataArray:(NSArray *)array Block:(void(^)(KJAlertView *obj))objblock AlertBlock:(KJAlertBlock)block{
    KJAlertView *obj = [[KJAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    obj.title = title;
    obj.contentStr = content;
    obj.titleArray = array;
    obj.type = type;
    
    [obj _config];
    
    if (objblock) {
        objblock(obj);
    }
    
    [obj setUI];
    
    [obj kj_Show];
    obj.myBlock = block;
    
    return obj;
}

- (void)setUI{
    if (self.titleArray == nil) {
        return;
    }
    [self addSubview:self.bgView];
    
    switch (self.type) {
        case KJAlertViewTypeCenter:
            [self createAlertViewCenter];
            break;
        case KJAlertViewTypeBottom:
            [self createAlertViewBottom];
            break;
        default:
            break;
    }
}

//获取字符串大小
- (CGRect)getStringFrame:(NSString *)str withFont:(NSInteger)fontSize withMaxSize:(CGSize)size{
    CGRect rect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SystemFontSize(fontSize)} context:nil];
    return rect;
}

#pragma mark - AlertViewCenter
- (void)createAlertViewCenter {
    _centerView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-(270))/2, (kScreenHeight-(120))/2, (270), (120))];
    _centerView.backgroundColor = self.centerViewColor;
    _centerView.layer.masksToBounds = YES;
    _centerView.layer.cornerRadius = (10);
    [_bgView addSubview:_centerView];
    
    CGFloat titleHeight;
    CGFloat contentLabY;
    
    CGFloat _centerViewwidth = CGRectGetWidth(_centerView.frame);
    
    if ([self.title isEqualToString:@""] || self.title == nil) {
        titleHeight = 0;
        contentLabY = (25);
    }
    else{
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake((20), (15), _centerViewwidth-(20)*2, 20)];
        titleLab.text = self.title;
        titleLab.textColor = self.titleColor;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = [UIFont systemFontOfSize:(16)];
        [_centerView addSubview:titleLab];
        
        titleHeight = titleLab.frame.size.height;
        contentLabY = titleLab.frame.origin.y + titleLab.frame.size.height+(10);
    }
    
    CGRect rect = [self getStringFrame:self.contentStr withFont:15 withMaxSize:CGSizeMake(_centerViewwidth-(20)*2, MAXFLOAT)];
    UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake((_centerViewwidth-rect.size.width)/2, contentLabY, rect.size.width, rect.size.height)];
    contentLab.text = self.contentStr;
    contentLab.textColor = self.textColor;
    contentLab.textAlignment = NSTextAlignmentCenter;
    contentLab.font = SystemFontSize(15);
    contentLab.numberOfLines = 0;
    [_centerView addSubview:contentLab];
    
    CGFloat contentLaby = contentLab.frame.origin.y;
    CGFloat contentLabheight = CGRectGetHeight(contentLab.frame);
    
    UIImageView *imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, contentLaby+contentLabheight+(25)-0.5, kScreenWidth, 0.5)];
    imageLine.backgroundColor = self.lineColor;
    [_centerView addSubview:imageLine];
    
    for (int i = 0; i < self.titleArray.count; i ++) {
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.tag = 2000+i;
        titleBtn.backgroundColor = [UIColor clearColor];
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleBtn setTitle:self.titleArray[i] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = SystemFontSize(15);
        
        if (self.titleArray.count == 1) {
            titleBtn.frame = CGRectMake(_centerViewwidth/self.titleArray.count*i, contentLaby+contentLabheight+(25), _centerViewwidth, (45));
            [titleBtn setTitleColor:self.textColor forState:UIControlStateNormal];
        }
        else{
            titleBtn.frame = CGRectMake(_centerViewwidth/self.titleArray.count*i, contentLaby+contentLabheight+(25), _centerViewwidth/self.titleArray.count-0.5, (45));
            if (i == 0) {
                [titleBtn setTitleColor:self.cancleColor forState:UIControlStateNormal];
            }
            else{
                [titleBtn setTitleColor:self.textColor forState:UIControlStateNormal];
                
                UIImageView *centerLine = [[UIImageView alloc] initWithFrame:CGRectMake(_centerViewwidth/self.titleArray.count*i-0.5, titleBtn.frame.origin.y, 0.5, titleBtn.frame.size.height)];
                centerLine.backgroundColor = self.lineColor;
                [_centerView addSubview:centerLine];
            }
            
            if (self.titleArray.count > 2) {
                [titleBtn setTitleColor:self.textColor forState:UIControlStateNormal];
            }
        }
        
        [_centerView addSubview:titleBtn];
    }
    
    _centerView.frame = CGRectMake((kScreenWidth-(270))/2, (kScreenHeight-(120))/2, (270), contentLaby+contentLabheight+(25)+(45));
}


#pragma mark - AlertViewBottom
- (void)createAlertViewBottom{
    if ([self.title isEqualToString:@""] || self.title == nil) {
        self.bottomHeader = 0.1;
    }
    else{
        self.bottomHeader = (50);
    }
    _bottomView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, self.titleArray.count*(50)+(10)+kBOTTOM_SPACE_HEIGHT+self.bottomHeader) style:UITableViewStyleGrouped];
    _bottomView.delegate = self;
    _bottomView.dataSource = self;
    _bottomView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bottomView.scrollEnabled = NO;
    _bottomView.backgroundColor = self.spaceColor;
    [_bgView addSubview:_bottomView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.titleArray.count-1;
    }
    else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.backgroundColor = self.bottomViewColor;
    }
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-(150))/2, ((50)-(15))/2, (150), (15))];
    titleLab.font = SystemFontSize(15);
    titleLab.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:titleLab];
    
    if (indexPath.section == 0) {
        titleLab.text = self.titleArray[indexPath.row];
        titleLab.textColor = self.textColor;
    }
    else{
        titleLab.text = [self.titleArray lastObject];
        titleLab.textColor = self.cancleColor;
    }
    
    UIImageView *imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, (50)-0.5, kScreenWidth, 0.5)];
    imageLine.backgroundColor = self.lineColor;
    [cell.contentView addSubview:imageLine];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.bottomHeader;
    }
    else{
        return (10);
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section==0) {
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (50))];
        titleLab.text = self.title;
        titleLab.backgroundColor = [self.bottomViewColor colorWithAlphaComponent:0.8];
        titleLab.textColor = self.titleColor;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = SystemFontSize(15);
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(2, (50), kScreenWidth-4, 1)];
        line.backgroundColor = [self.bottomViewColor colorWithAlphaComponent:0.9];
        [titleLab addSubview:line];
        return titleLab;
    }else{
        return nil;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.myBlock) {
        
        [self kj_Dissmiss];
        
        if (indexPath.section == 0) {
            self.myBlock(indexPath.row);
        }
        else{
            self.myBlock(self.titleArray.count-1);
        }
    }
}

#pragma mark - 公用方法
- (void)kj_Show{
    switch (self.type) {
        case KJAlertViewTypeCenter:{
            UIWindow *window = [UIApplication sharedApplication].windows[0];
            [window addSubview:self];
            [self exChangeOut:_centerView dur:0.5];
        }
            break;
        case KJAlertViewTypeBottom:{
            UIWindow *window = [UIApplication sharedApplication].windows[0];
            [window addSubview:self];
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomView.frame = CGRectMake(0, kScreenHeight - self.titleArray.count * (50) - (10) - kBOTTOM_SPACE_HEIGHT - self.bottomHeader, kScreenWidth, self.titleArray.count * (50) + (10) + kBOTTOM_SPACE_HEIGHT + self.bottomHeader);
            }];
        }
            break;
        default:
            break;
    }
}

- (void)kj_Dissmiss{
    switch (self.type) {
        case KJAlertViewTypeCenter:{
            [self removeFromSuperview];
        }
            break;
        case KJAlertViewTypeBottom:{
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, self.titleArray.count*(50)+(10)+kBOTTOM_SPACE_HEIGHT);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
        default:
            break;
    }
}

- (void)titleBtnClick:(UIButton *)btn{
    if (self.myBlock) {
        self.myBlock(btn.tag-2000);
    }
    [self kj_Dissmiss];
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIButton buttonWithType:UIButtonTypeCustom];
        _bgView.frame = [UIScreen mainScreen].bounds;
        [_bgView addTarget:self action:@selector(butChack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgView;
}

- (void)exChangeOut:(UIView *)changeOutView dur:(CFTimeInterval)dur{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = dur;
    //animation.delegate = self;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [changeOutView.layer addAnimation:animation forKey:nil];
}

- (void)butChack{
    [self kj_Dissmiss];
}

#pragma mark - 链接编程设置View的一些属性
- (KJAlertView *(^)(UIColor *))KJBackgroundColor {
    return ^(UIColor *color) {
        self.backgroundColor = color;
        return self;
    };
}
- (KJAlertView *(^)(NSInteger))KJTag {
    return ^(NSInteger tag){
        self.tag = tag;
        return self;
    };
}
- (KJAlertView *(^)(UIView*))KJAddView {
    return ^(UIView *superView){
        if (!superView) {
            [superView addSubview:self];
        }else{
            [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        }
        return self;
    };
}

- (KJAlertView *(^)(UIColor *lineColor,UIColor *titleColor,UIColor *textColor,UIColor *cancleColor))KJComColor {
    return ^(UIColor *lineColor,UIColor *titleColor,UIColor *textColor,UIColor *cancleColor){
        if (lineColor) {
            self.lineColor = lineColor;
        }
        if (titleColor) {
            self.titleColor = titleColor;
        }
        if (textColor) {
            self.textColor = textColor;
        }
        if (cancleColor) {
            self.cancleColor = cancleColor;
        }
        return self;
    };
}

- (KJAlertView *(^)(UIColor *centerViewColor))KJCenterColor {
    return ^(UIColor *centerViewColor){
        if (centerViewColor) {
            self.centerViewColor = centerViewColor;
        }
        return self;
    };
}

- (KJAlertView *(^)(UIColor *bottomViewColor,UIColor *spaceColor))KJBottomColor {
    return ^(UIColor *bottomViewColor,UIColor *spaceColor){
        if (bottomViewColor) {
            self.bottomViewColor = bottomViewColor;
        }
        if (spaceColor) {
            self.spaceColor = spaceColor;
        }
        return self;
    };
}


@end

