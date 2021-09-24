//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/5/21.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateArticle: Migration{
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("articles")    // table name
            .id()
            .field("article_Title", .custom("character varying(100)"), .required)
            .field("article_Text", .custom("character varying(200)"), .required)
            .field("user_id", .uuid, .required, .references("users","id"))
            .field("movie_id",.int,.required)
            .field("LikeCount", .int)
            .field("LastModifiedOn", .datetime, .required)
            .create()
    }
    
    //undo
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("articles").delete()
    }
    
}
