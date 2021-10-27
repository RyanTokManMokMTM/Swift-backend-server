import Vapor
import Fluent
import Foundation
import FluentPostgresDriver

struct CreatePersonCrew : Migration{
    func prepare(on database : Database) -> EventLoopFuture<Void> {
        database.schema("person_crews")
            .field("person_id",.int,.required,.references("person_infos", "id"))
            .field("movie_id",.int,.required,.references("movie_infos", "id"))
            .field("id",.int,.identifier(auto:true),.required)
            .field("credit_id",.string)
            .field("department",.string)
            .create()
    }

    func revert(on database : Database) -> EventLoopFuture<Void>{
        database.schema("person_crews").delete()
    }
}