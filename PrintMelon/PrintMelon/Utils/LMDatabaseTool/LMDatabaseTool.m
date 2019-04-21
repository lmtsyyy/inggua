//
//  LMDatabaseTool.m
//  GLSH
//
//  Created by admin on 17/4/18.
//
//

#import "LMDatabaseTool.h"

@interface LMDatabaseTool()<NSCopying>

@end

static LMDatabaseTool *_database;
@implementation LMDatabaseTool

+(instancetype)shareDatabase {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _database = [[self alloc] init];
    });
    return _database;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _database = [super allocWithZone:zone];
    });
    return _database;
}

-(id)copyWithZone:(NSZone *)zone {
    return _database;
}

-(FMDatabaseQueue *)dbQueue {
    if(!_dbQueue) {
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
    }
    return _dbQueue;
}



-(NSString *)dbPath {
    if(!_dbPath) {
        _dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        _dbPath = [_dbPath stringByAppendingPathComponent:@"survey.sqlite"];
    }
    return _dbPath;
}

#if 0
- (void)setupAddPLTable { //添加点位的缓存数据

    PointLocationDetailModel *model = [[PointLocationDetailModel alloc] init];
    [[LMDatabaseTool shareDatabase].dbQueue inDatabase:^(FMDatabase *db) {
        
        if([db open]) {
            NSString *createTable = [NSString stringWithFormat:@"create table if not exists '%@' ('%@' integer primary key autoincrement not null,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text)",AddPLTableName,model.ID,model.watch_height,model.camera_type,model.pic_install_place,model.pic_camera_orientation,model.pic_debug,model.place_type,model.shield_type,model.cameranum,model.remarks,model.overlooking_angle,model.preinstall_height,model.watch_distance,model.address,model.longitude,model.setup_method,model.focal_length,model.watch_arrow,model.latitude,model.fill_light,model.police_station,model.flag,model.point_name,model.point_code,model.measure_time,model.project_id,model.project_name,model.point_id,model.floor_height,model.boom_length,model.upright_heigth,model.pole_length,model.pole_nums,model.overarm_length,model.addOrModify,model.failureDesc];
            if([db executeUpdate:createTable]) {
                NSLog(@"添加点位缓存数据表创建成功");
            }else {
                NSLog(@"添加点位缓存数据表创建失败，error = %@",[db lastErrorMessage]);
            }
        }
        [db close];
    }];
}

- (void)setupAuditPLTable { //审核的缓存数据
    
    AuditCachEntity *entity = [[AuditCachEntity alloc] init];
    [[LMDatabaseTool shareDatabase].dbQueue inDatabase:^(FMDatabase *db) {
        
        if([db open]) {
            NSString *createTable = [NSString stringWithFormat:@"create table if not exists '%@' (id integer primary key autoincrement not null,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text)",AuditPLTableName,entity.point_id,entity.status,entity.roleId,entity.userId,entity.type,entity.failureDesc,entity.flag,entity.addOrModify,entity.point_name];
            if([db executeUpdate:createTable]) {
                NSLog(@"审核点位缓存数据表创建成功");
            }else {
                NSLog(@"审核点位缓存数据表创建失败，error = %@",[db lastErrorMessage]);
            }
        }
        [db close];
    }];
}
#endif

@end

