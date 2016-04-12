//
//  AppdetailModel.h
//  LimitFree
//
//  Created by Apple on 16/4/1.
//  Copyright © 2016年 Dordly. All rights reserved.
//

//应用详情

#import "BaseModel.h"

@interface AppdetailModel : BaseModel

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *fileSize;

@property (nonatomic, copy) NSString *itunesUrl;

@property (nonatomic, copy) NSString *language;

@property (nonatomic, copy) NSString *applicationId;

@property (nonatomic, copy) NSString *lastPrice;

@property (nonatomic, copy) NSString *ratingOverall;

@property (nonatomic, copy) NSString *releaseNotes;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, copy) NSString *downloads;

@property (nonatomic, copy) NSString *releaseDate;

@property (nonatomic, copy) NSString *slug;

@property (nonatomic, copy) NSString *updateDate;

@property (nonatomic, copy) NSString *appurl;

@property (nonatomic, copy) NSString *sellerId;

@property (nonatomic, copy) NSString *sellerName;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *iconUrl;

@property (nonatomic, copy) NSString *starCurrent;

@property (nonatomic, copy) NSString *starOverall;

@property (nonatomic, copy) NSString *priceTrend;

@property (nonatomic, copy) NSString *expireDatetime;

@property (nonatomic, copy) NSString *newversion;

@property (nonatomic, copy) NSString *currentPrice;

@property (nonatomic, strong) NSArray *photos;

@property (nonatomic, copy) NSString *description_long;

@property (nonatomic, copy) NSString *systemRequirements;

@property (nonatomic, assign) NSInteger categoryId;

@property (nonatomic, copy) NSString *currentVersion;

@end

@interface PhotosModel : NSObject

@property (nonatomic, copy) NSString *smallUrl;

@property (nonatomic, copy) NSString *originalUrl;

@end

