//
//  CHScrollPicturesController.m
//  HtmlTest
//
//  Created by baoju_mac_2 on 16/9/27.
//  Copyright © 2016年 baoju_chenHanWei. All rights reserved.
//

#import "CHScrollPicturesController.h"
#import "CHScrollPicturesViewCell.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"
static NSString * CellIdentifier = @"CHScrollPicturesViewCell";
@interface CHScrollPicturesController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *saveBtn;

@end

@implementation CHScrollPicturesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    backgroundView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:backgroundView];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setTitle:@"返回" forState:UIControlStateNormal];
    self.backBtn.frame =CGRectMake(15, 20, 50, 50);
    [self.backBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchDown];
    [backgroundView addSubview:self.backBtn];
    
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    self.saveBtn.frame = CGRectMake(self.view.frame.size.width - 15 - 40, 20, 50, 50);
    [self.saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchDown];
    [backgroundView addSubview:self.saveBtn];

    
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [layout setItemSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 64)];
    layout.minimumLineSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) collectionViewLayout:layout];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CHScrollPicturesViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:CellIdentifier];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    
    self.collectionView.showsHorizontalScrollIndicator = YES;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
    
    [self.view addSubview:self.collectionView];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%zd/%zd",self.index + 1,self.photos.count];
    // Do any additional setup after loading the view.
    

}



//设置页码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger page = scrollView.contentOffset.x/scrollView.frame.size.width ;
    
    self.index = page;
    
    self.navigationItem.title = [NSString stringWithFormat:@"%zd/%zd",page+1,self.photos.count];
    
}
-(void)save{
    
    
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:self.photos[self.index][0]]];
    SDImageCache* cache = [SDImageCache sharedImageCache];
    //此方法会先从memory中取。
    UIImage *image = [cache imageFromDiskCacheForKey:key];
        
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
 
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已存入手机相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alert show];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        
        [alert show];
    }
    
}
-(void)dismissAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --UICollectionView
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    CHScrollPicturesViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
  
    cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
    [cell imageWith:self.photos[indexPath.row][0] imageSize:self.imageSizes[indexPath.row]];
    return cell;
}




@end
