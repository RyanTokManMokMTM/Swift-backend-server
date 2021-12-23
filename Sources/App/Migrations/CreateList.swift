//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/9/24.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateList: Migration{
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("lists")    // table name
            .id()
            .field("list_title", .custom("character varying(100)"), .required)
            .field("user_id", .uuid, .required, .references("users","id"))
            .field("list_last_update", .datetime, .required)
            .create()
    }
    
    //undo
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("lists").delete()
    }
    
}
