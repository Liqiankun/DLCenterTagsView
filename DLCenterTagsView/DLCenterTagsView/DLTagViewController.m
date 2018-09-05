//
//  DLTagViewController.m
//  TinderCardViewDemo
//
//  Created by David on 2017/10/17.
//  Copyright © 2017年 FT_David. All rights reserved.
//

#import "DLTagViewController.h"
#import "UIColor+HexString.h"
#import <mach/mach.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_height [UIScreen mainScreen].bounds.size.height

@interface DLTagViewController ()

@end

@implementation DLTagViewController

double getMemoryUsage(void) {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self_, TASK_BASIC_INFO, (task_info_t)&info, &size);
    double memoryUsageInMB = kerr == KERN_SUCCESS ? (info.resident_size / 1024.0 / 1024.0) : 0.0;
    return memoryUsageInMB;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *tagsArray = @[@"90后", @"3年以上开发经验", @"iOS开发", @"跨平台开发", @"UI设计", @"交互设计", @"Sketch", @"Objective-c", @"JS", @"Ruby", @"React", @"ReactNative", @"ExpressJS", @"开源"];
    [self createTagsWithArray:tagsArray];
    
}

-(void)createTagsWithArray:(NSArray *)tagsArray {
    dispatch_async(dispatch_queue_create("createTags.com", NULL), ^{
        NSMutableArray *groupTagArray = [[NSMutableArray alloc] init];
        NSMutableArray<NSNumber *> *widthArray = [[NSMutableArray alloc] init];
        CGFloat labelSpace = 10;
        CGFloat lastWidth = 0;
        int lastIndex = 0;
        
        NSMutableArray *smallTagsArray = [[NSMutableArray alloc] init];
        UIFont *font = [UIFont systemFontOfSize:16];
        for (int tagIndex = 0; tagIndex < tagsArray.count; tagIndex ++ ) {
            NSString *tagString =tagsArray[tagIndex];
            CGFloat tagWidth = [tagString sizeWithAttributes:@{NSFontAttributeName: font}].width + 15;
            if (tagWidth + lastIndex * labelSpace + lastWidth >= SCREEN_WIDTH - 60) {
                [widthArray addObject:[NSNumber numberWithFloat:lastWidth]];
                lastWidth = tagWidth;
                [groupTagArray addObject:smallTagsArray];
                smallTagsArray = [[NSMutableArray alloc] init];
                [smallTagsArray addObject:tagString];
                if (tagIndex == tagsArray.count - 1) {
                    [groupTagArray addObject:smallTagsArray];
                    [widthArray addObject:[NSNumber numberWithFloat:lastWidth]];
                }
                lastIndex = 1;
            } else {
                lastWidth = lastWidth + tagWidth;
                [smallTagsArray addObject:tagString];
                if (tagIndex == tagsArray.count - 1) {
                    [groupTagArray addObject:smallTagsArray];
                    [widthArray addObject:[NSNumber numberWithFloat:lastWidth]];
                }
                lastIndex ++;
            }
        }
        
        for (int arrayIndex = 0; arrayIndex < groupTagArray.count; arrayIndex ++) {
            NSArray *smallTagArray = groupTagArray[arrayIndex];
            CGFloat width = [widthArray[arrayIndex] floatValue];
            __block CGFloat lastTagWidth = (SCREEN_WIDTH -  width - (smallTagArray.count - 1) * 10) / 2.0;
            for (int index = 0; index < smallTagArray.count; index ++) {
                NSString *tagString = smallTagArray[index];
                CGFloat tagWidth = [tagString sizeWithAttributes:@{NSFontAttributeName: font}].width + 15;
                dispatch_async(dispatch_get_main_queue(), ^{
                    UILabel *label = [self createTagLabel:tagString];
                    label.frame = CGRectMake(lastTagWidth + index * 10, arrayIndex * (font.lineHeight + 10 + 15) + 80, tagWidth, font.lineHeight + 10);
                    [self.view addSubview:label];
                    lastTagWidth = lastTagWidth + tagWidth;
                });
            }
        }
    });
}

-(UILabel *)createTagLabel:(NSString *)text {
    UIFont *font = [UIFont systemFontOfSize:16];
    UILabel *tagLabel = [[UILabel alloc] init];
    tagLabel.textColor = [UIColor whiteColor];
    tagLabel.font = font;
    tagLabel.layer.cornerRadius = 5.0;
    tagLabel.layer.borderWidth = 1.0;
    tagLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    tagLabel.textAlignment = NSTextAlignmentCenter;
    tagLabel.text = text;
    return tagLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
