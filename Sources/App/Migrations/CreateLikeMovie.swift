//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/10/27.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateLikeMovie: Migration{

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("like_movies")    // table name
            .id()
            .field("user_id", .uuid, .required, .references("users","id"))
            .field("movie_id", .int, .required)
            .field("movie_title", .string, .required)
            .field("movie_poster_path", .string)
            .field("like_movie_update", .datetime, .required)
            .create()
    }
    
    //undo
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("like_movies").delete()
    }
    
}
