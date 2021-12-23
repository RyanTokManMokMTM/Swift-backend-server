//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/5/21.
//

import Foundation
import Fluent
import FluentPostgresDriver
import AppKit

struct CreateArticle: Migration{
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("articles")    // table name
            .id()
            .field("article_title", .custom("character varying(100)"), .required)
            .field("article_text", .custom("character varying(1000)"), .required)
            .field("user_id", .uuid, .required, .references("users","id"))
            .field("movie_id",.int,.required)
            .field("article_like_count", .int)
            .field("article_last_update", .datetime, .required)
            .create()
    }
    
    
    
    //undo
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("articles").delete()
    }
    
}
