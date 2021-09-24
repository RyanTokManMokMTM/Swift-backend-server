//
//  CreateMovie.swift
//  
//
//  Created by Kao Li Chi on 2021/5/1.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateMovie: Migration{

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("movies")    // table name
            .field("movie_id", .int, .identifier(auto: true))   //primary key
            .field("movie_title", .string)
            .create()
    }
    
    //undo
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("movies").delete()
    }
    
}
