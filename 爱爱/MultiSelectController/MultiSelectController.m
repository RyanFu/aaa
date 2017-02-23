//
//  MultiSelectController.m
//  MultiSelectControl
//
//  Created by Darshan Patel on 7/3/15.
//  Copyright (c) 2015 Darshan Patel. All rights reserved.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Darshan Patel
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "MultiSelectController.h"
#import "MultiSelectCell.h"
#import "MultiSelectFlowLayout.h"

#import "CustomTableViewCell.h" //自定义cell

#import "ServiceDetailVC.h" //浪漫服务详情页

@interface MultiSelectController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,MultiSelectDelegate,UIGestureRecognizerDelegate>

@end

@implementation MultiSelectController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.arrSelected = [[NSMutableArray alloc] init];

    if (!self.multiSelectCellBackgroundColor) {

        self.multiSelectCellBackgroundColor = [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0];
    }

    if (!self.tableTextColor) {

        self.tableTextColor = [UIColor blackColor];

    }

    if (!self.multiSelectTextColor) {

        self.multiSelectTextColor = [UIColor whiteColor];
    }



    [self navigationBarSetup];
    [self collectionViewInitializations];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)navigationBarSetup
{

    if (!self.leftButtonTextColor) {

        self.leftButtonTextColor = [UIColor blackColor];
    }


    if (!self.rightButtonTextColor) {

        self.rightButtonTextColor = [UIColor blackColor];
    }


    if (!self.rightButtonText) {

        self.rightButtonText = @"Apply";
    }


    if (!self.leftButtonText) {


        self.leftButtonText = @"Cancel";
    }

    NSDictionary * navBarTitleTextAttributes =
    @{ NSForegroundColorAttributeName : [UIColor blackColor],
       NSFontAttributeName            : [UIFont systemFontOfSize:16.0] };

    self.navigationController.navigationBar.titleTextAttributes = navBarTitleTextAttributes;

//    self.navigationItem.title = @"Select";
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];


    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -10; // for example shift right bar button to the right


    UIButton *btnCancel =[UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame= CGRectMake(0, 0, 40, 40);
    [btnCancel setTitle:self.leftButtonText forState:UIControlStateNormal];
    [btnCancel setTitleColor:self.leftButtonTextColor forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(btnCancelTapped:) forControlEvents:UIControlEventTouchUpInside];


    UIBarButtonItem *barCancel =[[UIBarButtonItem alloc] initWithCustomView:btnCancel];
    self.navigationItem.leftBarButtonItems = @[spacer,barCancel];


    UIBarButtonItem *spacera = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacera.width = -15; // for example shift right bar button to the right

    UIButton *btnApply =[UIButton buttonWithType:UIButtonTypeCustom];
    btnApply.frame= CGRectMake(0, 0, 40, 40);
    [btnApply setTitle:self.rightButtonText forState:UIControlStateNormal];
    [btnApply setTitleColor:self.rightButtonTextColor forState:UIControlStateNormal];
    [btnApply addTarget:self action:@selector(btnApplyTapped:) forControlEvents:UIControlEventTouchUpInside];



    UIBarButtonItem *barApply =[[UIBarButtonItem alloc] initWithCustomView:btnApply];
    self.navigationItem.rightBarButtonItems = @[spacera,barApply];


    [self.tblOptions setTableFooterView:[UIView new]];
    

}
-(void)collectionViewInitializations
{
    MultiSelectFlowLayout *flowLayout = [[MultiSelectFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 30)];
    [flowLayout setSectionInset:UIEdgeInsetsMake(5.0, 10.0, 5.0, 10.0)];
    [flowLayout setMinimumLineSpacing:0.0];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.multiSelectCollectionView setCollectionViewLayout:flowLayout];

   // [self.multiSelectCollectionView registerClass:[MultiSelectCell class] forCellWithReuseIdentifier:@"MultiSelectCell"];

}
-(void)updateViewConstraints
{
    [super updateViewConstraints];

    if ([self.arrSelected count]!=0) {

        self.topLayoutConstraint.constant = 68;

    }else
    {
        self.topLayoutConstraint.constant = 0;
    }

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.arrOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";

    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    //现在数组里保存的是字典了
    NSDictionary *model = self.arrOptions[indexPath.row];
    
    cell.model = model;
    
    //给图片添加个点击事件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchToCheck:)];
    singleTap.delegate = self;
    [cell.backView addGestureRecognizer:singleTap];
    cell.backView.userInteractionEnabled = YES; //开启用户交互

    cell.tintColor = self.multiSelectCellBackgroundColor;
    
    if ([self.arrSelected containsObject:self.arrOptions[indexPath.row]]) {

        cell.accessoryType = UITableViewCellAccessoryCheckmark;

    }else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CustomTableViewCell *cell= (CustomTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {

        cell.accessoryType = UITableViewCellAccessoryNone;

        [self.arrSelected removeObject:self.arrOptions[indexPath.row]];
        [self.multiSelectCollectionView reloadData];
        [self.view setNeedsUpdateConstraints];


    }else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;

        [self.arrSelected addObject:self.arrOptions[indexPath.row]];
        [self.multiSelectCollectionView reloadData];

        [self.view setNeedsUpdateConstraints];

    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *model = self.arrOptions[indexPath.row];
    
    /*
     普通版也可实现一步设置搞定高度自适应，不再推荐使用此套方法，具体参看“UITableView+SDAutoTableViewCellHeight”头文件
     return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass];
     */
    
    // 推荐使用此普通简化版方法（一步设置搞定高度自适应，性能好，易用性好）
    return [self.tblOptions cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[CustomTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    
}




- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return [self.arrSelected count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    MultiSelectCell *cell = (MultiSelectCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MultiSelectCell" forIndexPath:indexPath];
    cell.delegate =self;
    NSDictionary *dict = [self.arrSelected objectAtIndex:indexPath.row];
    
    cell.lblText.text = [dict objectForKey:@"title"];
    cell.lblText.tag = [[dict objectForKey:@"serviceId"]integerValue];  //标记
    cell.lblText.textColor = self.multiSelectTextColor;
    cell.layer.cornerRadius = 3.0;
    cell.backgroundColor = self.multiSelectCellBackgroundColor;
    return cell;

}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    ((MultiSelectCell*)cell).delegate = nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    NSDictionary *dict = [self.arrSelected objectAtIndex:indexPath.row];
    
    CGRect textRect = [[dict objectForKey:@"title"]
                       boundingRectWithSize:CGSizeMake(320, 30)
                       options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}

                       context:nil];

    return CGSizeMake(textRect.size.width+32, 30);

}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}


-(void)didCancelClicked:(NSInteger)textLabelTag
{
    for (NSDictionary *dict in self.arrOptions) {
        
        if ([[dict objectForKey:@"serviceId"]integerValue]==textLabelTag) {
            
            [self.arrSelected removeObject:dict];
            
        }
        
    }
    
    [self.multiSelectCollectionView reloadData];
    [self.tblOptions reloadData];
    [self.view setNeedsUpdateConstraints];

}

-(IBAction)btnCancelTapped:(id)sender
{
    
    if ([self.delegate respondsToSelector:@selector(multiSelectControllerDidCancel:)]) {
        
        [self.delegate multiSelectControllerDidCancel:self];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        [self.arrSelected removeAllObjects];
        [self.multiSelectCollectionView reloadData];
        
        self.delegate = nil;
        
    }];
    
}
-(IBAction)btnApplyTapped:(id)sender
{
    
    if ([self.delegate respondsToSelector:@selector(multiSelectController: didFinishPickingSelections: )]) {
        
        [self.delegate multiSelectController:self didFinishPickingSelections:self.arrSelected];
        
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        [self.arrSelected removeAllObjects];
        [self.multiSelectCollectionView reloadData];
        
        self.delegate = nil;
        
    }];
}



///图片点击事件
-(void)touchToCheck:(UITapGestureRecognizer *)tapView
{

    NSLog(@"tag:%ld",tapView.view.tag);
    
    ServiceDetailVC *svc = [ServiceDetailVC new];
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:svc animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
    
}













/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
