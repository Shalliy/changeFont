//
//  UIFont+XX.m
//  AnXinCaiFu_XSD
//
//  Created by windForce on 2018/9/4.
//  Copyright © 2018年 Blue Mobi. All rights reserved.
//

#import "UIFont+XX.h"

@implementation UIFont (XX)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL systemSel = @selector(systemFontOfSize:);
        SEL swizzSel = @selector(my_systemFontOfSize:);
        
        Method systemMethod = class_getClassMethod([UIFont class], @selector(systemFontOfSize:));
        Method swizzMethod = class_getClassMethod([UIFont class], @selector(my_systemFontOfSize:));
        method_exchangeImplementations(systemMethod, swizzMethod);
        //首先动态添加方法，实现是被交换的方法，返回值表示添加成功还是失败
//        BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
//        if (isAdd) {
//            //如果成功，说明类中不存在这个方法的实现
//            //将被交换方法的实现替换到这个并不存在的实现
//            class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
//        } else {
//            //否则，交换两个方法的实现
//            method_exchangeImplementations(systemMethod, swizzMethod);
//        }
    });
}

+ (UIFont *)my_systemFontOfSize:(CGFloat)size {
    [UIFont my_systemFontOfSize:size];
    
    return [UIFont fontWithName:@"CaiYunHanMaoBi-LiShu" size:size];
}

@end
