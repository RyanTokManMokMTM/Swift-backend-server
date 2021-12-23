//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/10/27.
//

import Foundation
import Fluent
import Vapor


struct LikeTodo: Content{
    var like_id: UUID
    var like_user_id: UUID
    var article_id: UUID
    var article_title: String
    var article_text: String
    var user_id: UUID
    var movie_id: Int
    var article_like_count: Int
    var article_last_update: String?
    var user_name: String
    var user_avatar: String
}



struct NewLikeArticle: Content{
    var userID : UUID
    var articleID : UUID
}

struct CheckLike: Content{
    var id : UUID?
}


struct NewLikeMovie: Content{   
    var userID : UUID
    var movie : Int
    var title : String
    var posterPath : String
}

struct CheckLikeMovie: Content{
    var userID : UUID
    var movie : Int
}

