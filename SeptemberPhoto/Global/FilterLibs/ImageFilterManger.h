//
//  ImageFilterManger.h
//  SeptemberPhoto
//
//  Created by Eric on 2023/9/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageFilterManger : NSObject

+ (NSArray<UIImage *>*)getImageArrWithImage:(UIImage*)inImage;

@end

NS_ASSUME_NONNULL_END
