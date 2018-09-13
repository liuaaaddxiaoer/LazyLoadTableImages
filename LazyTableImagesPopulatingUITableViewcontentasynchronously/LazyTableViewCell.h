//
//  LazyTableViewCell.h
//  LazyTable
//
//  Created by 刘小二 on 2018/9/13.
//

#import <UIKit/UIKit.h>

@interface LazyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
