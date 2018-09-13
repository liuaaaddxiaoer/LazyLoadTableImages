//
//  MyLazyViewController.m
//  LazyTable
//
//  Created by 刘小二 on 2018/9/13.
//

#import "MyLazyViewController.h"
#import "LazyTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
static NSString *const LazyCellIds = @"LazyCellIds";
@interface MyLazyViewController ()
@property(nonatomic, strong) NSArray *datas;
@end

@implementation MyLazyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LazyTableViewCell class]) bundle:nil] forCellReuseIdentifier:LazyCellIds];
    self.tableView.rowHeight = 400;

    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://api.bilibili.com/x/web-interface/ranking/region?rid=25&day=3&jsonp=jsonp"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        NSLog(@"%@",jsonData);
        self.datas = jsonData[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }] resume] ;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *iconURL = self.datas[indexPath.row][@"pic"];
    
    LazyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:LazyCellIds forIndexPath:indexPath];
    cell.contentImageView.image = [self drawImage];
    UIImage *caImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:iconURL];
    if (caImage) {
        cell.contentImageView.image = caImage;
    }else {
        if ((self.tableView.dragging || self.tableView.decelerating)) {
            
        }else {
            [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:iconURL] placeholderImage:[self drawImage] options:SDWebImageAvoidAutoSetImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                CATransition *transition = [CATransition animation];
                
            }];;
        }
    }
    cell.titleLabel.text = self.datas[indexPath.row][@"title"];
    return cell;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
        [self loadImagesOnVisibility];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self loadImagesOnVisibility];
    }
}

- (void)loadImagesOnVisibility {
    NSArray *visibleIndexPathRows =  self.tableView.indexPathsForVisibleRows;
    for (NSIndexPath *indexPath in visibleIndexPathRows) {
        NSString *iconURL = self.datas[indexPath.row][@"pic"];
        UIImage *caImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:iconURL];
        if (!caImage) {
            LazyTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:iconURL] placeholderImage:[self drawImage]];
        }
    }
    
}

- (UIImage *)drawImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(414, 270), NO, 1);
   UIBezierPath *be = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 414, 270)];
    
    [[UIColor redColor] setFill];
    
    [be fill];
    
    UIImage *tmpImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tmpImage;
}

@end
