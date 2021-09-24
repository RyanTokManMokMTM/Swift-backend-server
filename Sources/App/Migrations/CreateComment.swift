//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/6/2.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateComment: Migration{
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("comments")    // table name
            .id()
            .field("comment_Text", .custom("character varying(200)"), .required)
            .field("user_id", .uuid, .required, .references("users","id"))
            .field("article_id",.uuid, .required, .references("articles","id"))
            .field("LikeCount", .int)
            .field("LastModifiedOn", .datetime, .required)
            .create()
    }
    
    //undo
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("articles").delete()
    }
    
}
