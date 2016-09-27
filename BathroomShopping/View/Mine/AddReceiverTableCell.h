//
//  AddReceiverTableCell.h
//  BathroomShopping
//
//  Created by zzy on 8/27/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddReceiverTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UITextField *contentTxt;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;
+ (instancetype)cellWithTableView:(UITableView *)table;
@end
