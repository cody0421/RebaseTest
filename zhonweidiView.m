//
//  zhonweidiView.m
//  12345
//
//  Created by Cody on 2017/8/29.
//  Copyright © 2017年 hotBear. All rights reserved.
//

#import "zhonweidiView.h"

@implementation zhonweidiView


//我是 C3
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)c1{
    NSLog(@"C1 is ok!");
}

- (void)c3AndC3{
    NSLog(@"就是C3");
}

- (void)c3Orc3{
    NSLog(@"C3报道");
}



//我现在在C1分支上进行工作
- (void)c1ShowTitle{
    UILabel * label = [UILabel new];
    label.text = @"合并后的事情";
}


@end
