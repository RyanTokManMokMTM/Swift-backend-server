//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/9/24.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateListMovie: Migration{
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("lists_movies")    // table name
            .id()
            .field("list_id", .uuid, .required, .references("lists","id"))
            .field("user_id", .uuid, .required, .references("users","id"))
            .field("movie_id", .int, .required)
            .field("movie_title", .string, .required)
            .field("movie_posterPath", .string)
            .field("user_feeling", .custom("character varying(200)"), .required)
            .field("user_ratetext", .int, .required)
            .create()
    }
    
    //undo
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("lists_movies").delete()
    }
    
}
