//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/5/21.
//

import Foundation
import Fluent
import Vapor

//------------------發表新文章（POST)------------------//
struct NewArticle: Content {
    var Title : String
    var Text : String
    var movieID : Int
    var userID : UUID
}

//------------------編輯文章（PUT)------------------//
struct UpdateArticle: Content{
    var articleID : UUID
    var Title : String
    var Text : String
    var LikeCount: Int
}

