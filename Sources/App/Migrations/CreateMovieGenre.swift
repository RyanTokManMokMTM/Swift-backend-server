import Foundation
import Fluent
import FluentPostgresDriver

struct CreateGenresMovies : Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("genres_movies")    // table name
            .unique(on: "movie_info_id", "genre_info_id")
            .field("movie_info_id", .uint ,.required)   //primary key
            .field("genre_info_id", .uint,.required)   //primary key
            .field("id",.uint,.identifier(auto: true))
            .foreignKey("movie_info_id", references: "movie_infos", "id")
            .foreignKey("genre_info_id", references: "genre_infos","id")
            .create()
    }
    
    //undo
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("genres_movies").delete()
    }
    
}