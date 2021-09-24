//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/9/24.
//
//
import Foundation
import Fluent
import Vapor

final class List: Model, Content{
    static let schema = "lists"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "list_Title")
    var Title: String

    @Parent(key: "user_id")
    var user: User

    @Timestamp(key: "LastModifiedOn", on: .update)
    var updatedOn: Date?


    init() {}

    init(id: UUID? = nil, Title: String, user:User){
        self.id = id
        self.Title = Title
        self.$user.id = user.id! //when setting a parent, only need to set the wrapper's id to hook in the relation
    }
}
