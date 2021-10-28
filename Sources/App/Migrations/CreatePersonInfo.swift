

import Foundation
import Fluent
import FluentPostgresDriver

struct CreatePersonInfo: Migration{
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("person_infos")    // table name
            .field("id",.int,.identifier(auto:true),.required)
            .field("adult",.bool)
            .field("gender",.int)
            .field("department",.string)
            .field("name",.string)
            .field("popularity", .custom("numeric"))
            .field("profile_path",.string)
            .create()
    }
    
    //undo
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("person_infos").delete()
    }
    
}
