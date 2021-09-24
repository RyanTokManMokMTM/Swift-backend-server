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
        .field("UserName", .string)
        .field("Email", .string, .required)
        .field("Password", .string, .required)
        .unique(on: "UserName")
        .unique(on: "Email")
        .create()
    }
    
    //undo
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
    
}
