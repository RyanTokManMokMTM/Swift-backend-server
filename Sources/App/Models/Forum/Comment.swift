//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/6/2.
//

import Foundation
import Fluent
import Vapor

final class Comment: Model, Content{
    static let schema = "comments"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "comment_Text")
    var Text: String
    
    @Parent(key: "user_id")
    var user: User
    
    @Parent(key: "article_id")
    var article: Article
    
    @Field(key: "LikeCount")
    var LikeCount: Int
    
    @Timestamp(key: "LastModifiedOn", on: .update)
    var updatedOn: Date?
    
    
    init() {}
    
    init(id: UUID? = nil, Text:String, user:User, article:Article, LikeCount:Int){
        self.id = id
        self.Text = Text
        self.$user.id = user.id! //when setting a parent, only need to set the wrapper's id to hook in the relation
        self.$article.id = article.id!
        self.LikeCount = LikeCount
    }
}
