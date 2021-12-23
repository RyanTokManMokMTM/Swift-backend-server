//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/10/27.
//

import Foundation
import Fluent
import Vapor

final class LikeArticle: Model, Content{
    static let schema = "like_articles"

    @ID(key:.id)
    var id: UUID?

    @Parent(key: "user_id")
    var user: User
    
    @Parent(key: "article_id")
    var article: Article

    @Timestamp(key: "like_article_update", on: .update)
    var updatedOn: Date?

    init() {}

    init(id: UUID? = nil, user: User,article: Article){
        self.id = id
        self.$user.id = user.id!
        self.$article.id = article.id!
    }
}
