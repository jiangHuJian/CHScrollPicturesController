 //
//  CHScrollPicturesViewCell.h
//  HtmlTest
//
//  Created by baoju_mac_2 on 16/9/27.
//  Copyright © 2016年 baoju_chenHanWei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHScrollPicturesViewCell : UICollectionViewCell



-(void)imageWith:(NSString *)imageUrl imageSize:(NSString *)imageSize;

-(UIImage *)getImage;
@end
