//
//  GoodsRecommendTableCell.m
//  BathroomShopping
//
//  Created by zzy on 8/14/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "GoodsRecommendTableCell.h"
#import "GoodsRecommendView.h"

//水平间距
#define hspace 8
//垂直间距
#define vspace 8
//每行的数量
#define numOfRow 3

#define goodsRecommendViewW (ScreenW - 2 * 8 - (numOfRow - 1) * hspace) / numOfRow
#define goodsRecommendViewH goodsRecommendViewW * 3 / 2

static NSString *ID = @"goodsRecommendTableCell";
@interface GoodsRecommendTableCell()
/** <##> */
@property (nonatomic, weak)UILabel *titleLbl;
/** <##> */
@property (nonatomic, weak)UILabel *leftLine;
/** <##> */
@property (nonatomic, weak)UILabel *rightLine;
/** <##> */
@property (nonatomic, weak)UIButton *moreBtn;
/** <##> */
@property (nonatomic, weak)UIView *goodsBgView;
/** <##> */
@property (nonatomic, weak)UILabel *bottomLine;
@end

@implementation GoodsRecommendTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
    }
    return self;
}


+ (instancetype)cellWithTableView:(UITableView *)table {
    

    GoodsRecommendTableCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[GoodsRecommendTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)initView {

    UILabel *titleLbl = [[UILabel alloc]init];
    titleLbl.text = @"为你推荐";
    titleLbl.textColor = [UIColor darkGrayColor];
    titleLbl.font = [UIFont systemFontOfSize:15];
    [self addSubview:titleLbl];
    self.titleLbl = titleLbl;
    
    UILabel *leftLine = [[UILabel alloc]init];
    leftLine.backgroundColor = [UIColor colorWithHexString:@"0xcfcfcf"];
    [self addSubview:leftLine];
    self.leftLine = leftLine;
    
    UILabel *rightLine = [[UILabel alloc]init];
    rightLine.backgroundColor = [UIColor colorWithHexString:@"0xcfcfcf"];
    [self addSubview:rightLine];
    self.rightLine = rightLine;
    
    UIView *goodsBgView = [[UIView alloc]init];
    [self addSubview:goodsBgView];
    self.goodsBgView = goodsBgView;
    NSInteger count = MIN(self.recommendGoodsArr.count, 6);
    for (int i = 0; i < count; i++) {
    
        GoodsRecommendView *goodsRecommendView = [GoodsRecommendView instanceView];
        [goodsBgView addSubview:goodsRecommendView];
    }
    
    UILabel *bottomLine = [[UILabel alloc]init];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"0xcfcfcf"];
    [self addSubview:bottomLine];
    self.bottomLine = bottomLine;
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setTitle:@"查看更多为你推荐" forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:moreBtn];
    self.moreBtn = moreBtn;
}

- (void)layoutSubviews {

    CGSize size = [self.titleLbl sizeThatFits:CGSizeZero];
    self.titleLbl.frame = CGRectMake(0, 12, size.width, size.height);
    self.titleLbl.centerX = self.width / 2;
    
    self.leftLine.frame = CGRectMake(CGRectGetMinX(self.titleLbl.frame) - 80 - 20, 0, 80, 0.5);
    self.leftLine.centerY = self.titleLbl.centerY;
    
    self.rightLine.frame = CGRectMake(CGRectGetMaxX(self.titleLbl.frame) + 20, 0, 80, 0.5);
    self.rightLine.centerY = self.titleLbl.centerY;
    
    
    self.goodsBgView.frame = CGRectMake(8, CGRectGetMaxY(self.titleLbl.frame) + 8, self.width - 2 * 8, goodsRecommendViewH * 2 + vspace);
    for (int i = 0; i < self.goodsBgView.subviews.count; i++) {
    
        CGFloat goodsRecommendViewX = (i % numOfRow) * (goodsRecommendViewW + hspace);
        CGFloat goodsRecommendViewY = (i / numOfRow) * (goodsRecommendViewH + vspace);
        self.goodsBgView.subviews[i].frame = CGRectMake(goodsRecommendViewX, goodsRecommendViewY, goodsRecommendViewW, goodsRecommendViewH);
    }
    
    self.bottomLine.frame = CGRectMake(0, CGRectGetMaxY(self.goodsBgView.frame) + 8, self.width, 0.5);
 
    self.moreBtn.frame = CGRectMake(0, CGRectGetMaxY(self.bottomLine.frame), self.width, 40);
    self.moreBtn.centerX = self.width / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

+ (CGFloat)getCellHeight:(NSMutableArray *)recommendGoodsArr{

    if (recommendGoodsArr.count == 0) {
        
        return 0;
        
    }else if (recommendGoodsArr.count / 3 == 0) {
    
        return goodsRecommendViewH + 40;
        
    }else {
    
        return 2 * goodsRecommendViewH + 40;
    }
}

- (void)setRecommendGoodsArr:(NSMutableArray *)recommendGoodsArr {

    _recommendGoodsArr = recommendGoodsArr;
    if (recommendGoodsArr.count != 0) {
        
        [self initView];
        [self setNeedsLayout];
    }
}
@end
