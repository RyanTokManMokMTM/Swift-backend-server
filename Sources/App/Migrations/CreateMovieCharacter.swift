import Vapor
import FluentPostgresDriver
import Foundation

struct CreateMovieCharacter : Migration {
    func prepare(on database : Database) -> EventLoopFuture<Void> {
        database.schema("movie_characters")
            .field("person_id",.int,.required,.references("person_infos", "id"))
            .field("movie_id",.int,.required,.references("movie_infos", "id"))
            .field("id",.int,.identifier(auto:true),.required)
            .field("character",.string)
            .field("credit_id",.string)
            .field("order",.int)
            .create()
    }

    func revert(on database : Database) -> EventLoopFuture<Void> {
        database.schema("movie_characters").delete()
    }
    
}