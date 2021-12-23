//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/2/16.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateUser: Migration{

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")    // table name
        .id()
        .field("user_name", .string)
        .field("email", .string, .required)
        .field("password", .string, .required)
        .field("user_avatar", .string)
        .unique(on: "user_name")
        .unique(on: "email")
        .create()
    }
    
    //undo
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
    
}
