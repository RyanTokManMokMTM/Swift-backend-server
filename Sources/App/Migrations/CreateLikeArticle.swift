//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/10/27.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateLikeArticle: Migration{

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("like_articles")    // table name
            .id()
            .field("user_id", .uuid, .required, .references("users","id"))
            .field("article_id",.uuid, .required, .references("articles","id"))
            .field("like_article_update", .datetime, .required)
            .create()
    }
    
    //undo
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("like_movies").delete()
    }
    
}
