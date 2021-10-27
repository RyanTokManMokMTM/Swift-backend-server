import Foundation
import Fluent
import FluentPostgresDriver

struct CreateGenresMovies : Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("genres_movies")    // table name
            .field("movie_info_id", .int ,.required)   //primary key
            .field("genre_info_id", .int,.required)   //primary key
            .field("id",.int,.identifier(auto: true))
            .foreignKey("movie_info_id", references: "movie_infos", "id")
            .foreignKey("genre_info_id", references: "genre_infos","id")
            .unique(on : "movie_info_id","genre_info_id")
            .create()
    }
    
    //undo
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("genres_movies").delete()
    }
    
}