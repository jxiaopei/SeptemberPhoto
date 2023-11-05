//
//  ImageFilterManger.m
//  SeptemberPhoto
//
//  Created by Eric on 2023/9/25.
//

#import "ImageFilterManger.h"
#import "ImageUtil.h"
#import "ColorMatrix.h"

@implementation ImageFilterManger

//任务组
+ (NSArray<UIImage *> *)getImageArrWithImage:(UIImage *)inImage{
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:@[[UIImage new],[UIImage new],[UIImage new],[UIImage new],[UIImage new],[UIImage new],[UIImage new],[UIImage new],[UIImage new]]];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue1 = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_enter(group);
    dispatch_async(queue1, ^{
        UIImage * img1 = [ImageUtil imageWithImage:inImage withColorMatrix:colormatrix_lomo];
        arr[0] = img1;
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue1, ^{
        UIImage * img2 = [ImageUtil imageWithImage:inImage withColorMatrix:colormatrix_heibai];
        arr[1] = img2;
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue1, ^{
        UIImage * img3 = [ImageUtil imageWithImage:inImage withColorMatrix:colormatrix_huajiu];
        arr[2] = img3;
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue1, ^{
        UIImage * img4 = [ImageUtil imageWithImage:inImage withColorMatrix:colormatrix_gete];
        arr[3] = img4;
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue1, ^{
        UIImage * img5 = [ImageUtil imageWithImage:inImage withColorMatrix:colormatrix_ruise];
        arr[4] = img5;
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue1, ^{
        UIImage * img6 = [ImageUtil imageWithImage:inImage withColorMatrix:colormatrix_danya];
        arr[5] = img6;
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue1, ^{
        UIImage * img7 = [ImageUtil imageWithImage:inImage withColorMatrix:colormatrix_guangyun];
        arr[6] = img7;
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue1, ^{
        UIImage * img8 = [ImageUtil imageWithImage:inImage withColorMatrix:colormatrix_menghuan];
        arr[7] = img8;
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue1, ^{
        UIImage * img9 = [ImageUtil imageWithImage:inImage withColorMatrix:colormatrix_langman];
        arr[8] = img9;
        dispatch_group_leave(group);
    });
    long result = dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    if (result == 0){
        return arr.mutableCopy;
    }else{
        return @[];
    }
    
}

@end
