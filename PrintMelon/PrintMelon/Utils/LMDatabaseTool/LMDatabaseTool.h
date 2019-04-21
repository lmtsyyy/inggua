//
//  LMDatabaseTool.h
//  GLSH
//
//  Created by admin on 17/4/18.
//
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
@interface LMDatabaseTool : NSObject

+(instancetype)shareDatabase;

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@property (nonatomic, copy) NSString *dbPath;

//- (void)setupAddPLTable;
//- (void)setupAuditPLTable;

@end

