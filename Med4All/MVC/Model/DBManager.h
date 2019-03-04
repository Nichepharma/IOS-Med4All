//
//  DBManager.h
//  SQLLight
//
//  Created by Yahia on 2/15/15.
//  Copyright (c) 2015 Production Code. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface DBManager : NSObject
{
    NSString *databasePath;
}

+(DBManager*)getSharedInstance;
//  API
-(BOOL)addfavouritRequest :(NSDictionary *) requestData ;
-(NSDictionary*)getFavouritRequest;
-(BOOL)removeFavouritRequest :(NSString*)request_id ;
-(NSMutableArray *)getFavouritIDs ;
-(BOOL)removeFavouritAllRequest ;
@end
