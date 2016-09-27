//
//  FileNameDefine.h
//  BathroomShopping
//
//  Created by zzy on 8/12/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#ifndef FileNameDefine_h
#define FileNameDefine_h

#ifdef BSDEBUG

// 我的页面中我的信息缓存文件
#define kMyInfoCacheFileName @"MyInfoCacheFileNameDebug"
//数据库路径
#define dbPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"bathDebug.sqlite"]
//搜索历史缓存文件
#define kSearchHistoryFileName @"SearchHistoryFileDebug"
#else

// 我的页面中我的信息缓存文件
#define kMyInfoCacheFileName @"MyInfoCacheFileName"
//搜索历史缓存文件
#define kSearchHistoryFileName @"SearchHistoryFile"
//数据库路径
#define dbPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"bath.sqlite"]
#endif

#endif /* FileNameDefine_h */
