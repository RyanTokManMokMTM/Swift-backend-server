//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/5/21.
//

import Foundation
import Fluent
import Vapor

final class Article: Model, Content{
    static let schema = "articles"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "article_Title")
    var Title: String
    
    @Field(key: "article_Text")
    var Text: String
    
    @Parent(key: "user_id")
    var user: User
    
    @Field(key: "movie_id")
    var movie: Int
    
    @Field(key: "LikeCount")
    var LikeCount: Int
    
    @Timestamp(key: "LastModifiedOn", on: .update)
    var updatedOn: Date?
    
    
    init() {}
    
    init(id: UUID? = nil, Title: String, Text:String, user:User, movie:Int, LikeCount:Int){
        self.id = id
        self.Title = Title
        self.Text = Text
        self.$user.id = user.id! //when setting a parent, only need to set the wrapper's id to hook in the relation
        self.movie = movie
        self.LikeCount = LikeCount
    }
}
