//
//  CHScrollPicturesController.h
//  HtmlTest
//
//  Created by baoju_mac_2 on 16/9/27.
//  Copyright © 2016年 baoju_chenHanWei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHScrollPicturesController : UIViewController
/**photos*/
@property(nonatomic,strong)NSArray *photos;
/**sizeArr*/
@property(nonatomic,strong)NSArray *imageSizes;

/**index*/
@property(nonatomic,assign)NSInteger index;

@end
