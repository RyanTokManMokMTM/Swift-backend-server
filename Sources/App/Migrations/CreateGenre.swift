import Foundation
import Fluent
import FluentPostgresDriver


struct CreateGenre : Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("genre_infos")    // table name
            .field("id",.uint,.required,.identifier(auto: true))
            .field("name",.string)
            .field("created_at",.datetime)
            .field("updated_at",.datetime)
            .field("deleted_at",.datetime)
            .create()
    }
    
    //undo
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("genre_infos").delete()
    }
    
}