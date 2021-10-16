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
        database.schema("movie_infos")    // table name  //primary key
            .field("adult", .bool)
            .field("backdrop_path", .string)
            .field("id", .int, .identifier(auto: true),.required) 
            .field("original_language", .string)
            .field("original_title", .string)
            .field("overview", .string)
            .field("popularity", .custom("numeric"))
            .field("poster_path",.string)
            .field("release_date",.string)
            .field("title",.string)
            .field("video",.bool)
            .field("vote_average",.custom("numeric"))
            .field("vote_count",.int)
            .field("created_at",.datetime)
            .field("updated_at",.datetime)
            .field("deleted_at",.datetime)
            .create()
    }
    
    //undo
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("movie_infos").delete()
    }
    
}
