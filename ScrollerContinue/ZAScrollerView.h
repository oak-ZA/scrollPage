//
//  ZAScrollerView.h
//  ScrollerContinue
//
//  Created by 张奥 on 2019/9/23.
//  Copyright © 2019 张奥. All rights reserved.
//

#import <UIKit/UIKit.h>
//点击回调
 typedef void(^TapScrollViewBlock)(NSInteger pageIndex);
@interface ZAScrollerView : UIView
-(void)setDataSuroces:(NSArray *)dataSurces withCallBackBlock:(TapScrollViewBlock)block;
@end
