///Users/yahiael-dow/Desktop/Med4All/Med4All/MVC/Model/DBManager.m
//  DBManager.m
//  SQLLight
//
//  Created by Yahia on 2/15/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//

#import "DBManager.h"

static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;


@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance openDB];
    }
    return sharedInstance;
}


#pragma mark -Start to Create Tables
//-----------------------------------#Create Tables#-----------------------------------//
-(void)openDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    NSLog(@"Dir %@",docsDir);
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"med4all.db"]];
    bool tableCreated  ;
    tableCreated= [sharedInstance createDB];

    if (!tableCreated) {
        NSLog(@"Tables not created");
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
}

#pragma  -mark Create Login Table
-(BOOL)createDB{
    BOOL isSuccess = YES ;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS favouritRequest (f_id  INTEGER PRIMARY KEY AUTOINCREMENT , request_id TEXT UNIQUE , med_name TEXT , request_date TEXT , donator_id TEXT , donator_f_name TEXT , donator_l_name TEXT , donator_phone TEXT , country_id TEXT , country_name TEXT , city_id TEXT , city_name TEXT, area_id , area_name TEXT, address_detail TEXT, donator_availableTime TEXT, item_count TEXT, request_note TEXT, request_status TEXT) ;" ;

            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return isSuccess;
}


//================================================# My Favourit API FUNCTIONS #================================================//
#pragma  -mark  FAVOURIT API


-(BOOL)addfavouritRequest :(NSDictionary *) requestData{

    NSString *sqlKey = @"";
    NSString *sqlVal = @"";
    for (NSString *strRequestKey  in requestData.allKeys) {
        sqlKey = [NSString stringWithFormat:@"%@ , `%@`" , sqlKey , strRequestKey];
        sqlVal = [NSString stringWithFormat:@"%@ , '%@'" , sqlVal , requestData[strRequestKey]];
    }
    sqlKey =  [sqlKey substringFromIndex:2] ;
    sqlVal =  [sqlVal substringFromIndex:2] ;
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO favouritRequest (%@) VALUES (%@)" ,sqlKey , sqlVal ];
    return  [self iudStatementWithSQL_String:insertSQL] ;
}
-(NSDictionary*)getFavouritRequest{
    NSDictionary * dic = [self selectStatementWithTable:@"favouritRequest ORDER BY request_id DESC" fullQuery:@""] ;
    return dic ;
}
-(NSMutableArray *)getFavouritIDs{
    NSDictionary * dic = [self selectStatementWithTable:@"" fullQuery:@"SELECT request_id FROM favouritRequest"] ;
    NSMutableArray *req_id = [dic objectForKey:dic.allKeys.firstObject];
    return req_id ;
}
-(BOOL)removeFavouritRequest :(NSString*)request_id{
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM favouritRequest WHERE request_id = %@",request_id];
    return  [self iudStatementWithSQL_String:deleteSQL] ;
}

-(BOOL)removeFavouritAllRequest{
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM favouritRequest"];
    return  [self iudStatementWithSQL_String:deleteSQL] ;
}










//================================================# SQL API FUNCTIONS #================================================//

#pragma  -mark  IUD STATMENT API

-(BOOL) iudStatementWithSQL_String :(NSString  *)str_sql {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        const char *insert_stmt = [str_sql UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
    }

    BOOL success =((sqlite3_step(statement) == SQLITE_DONE) ?YES : NO);
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return success;

}
#pragma  -mark  SQL STATMENT API
-(NSDictionary *) selectStatementWithTable:(NSString  *)strTable_name fullQuery :(NSString *)fullQuery  {

    NSMutableDictionary *statmemnt_result = [[NSMutableDictionary alloc]init] ;

    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *str_sql = [NSString stringWithFormat:@"select  * from %@" , strTable_name];
        if (![fullQuery isEqualToString:@""]) {
            str_sql = fullQuery;
        }
        //        NSLog(@"str_sql %@ ",str_sql) ;
        const char *query_stmt = [str_sql UTF8String];

        NSMutableArray *dic_TableKey = [[NSMutableArray alloc]init];

        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            // loop to get table column
            for (int x = 0  ; x < sqlite3_column_count(statement) ; x ++ ) {

                [dic_TableKey addObject:[NSString stringWithFormat:@"%s" , sqlite3_column_name(statement , x ) ] ] ;
                [statmemnt_result setObject:[[NSMutableArray alloc] init] forKey:dic_TableKey[x]];
            }

            while (sqlite3_step(statement) == SQLITE_ROW) {

                for (int i = 0 ; i < sqlite3_data_count(statement) ; i ++ ) {
                    // get  table coulmn  and value
                    NSString *_column = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_name(statement, i)] ;
                    NSString *_result = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, i)] ;

                    NSMutableArray *tempArr = [[NSMutableArray alloc] initWithArray:[statmemnt_result objectForKey:_column] ] ;
                    [tempArr addObject:_result];
                    [statmemnt_result setObject:tempArr forKey:_column];
                }

            }

            sqlite3_finalize(statement);
            sqlite3_close(database);

            //            NSLog(@"statmemnt_result %@ ",statmemnt_result) ;
        }
    }
    
    return statmemnt_result;
    
}

@end
