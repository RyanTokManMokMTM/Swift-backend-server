//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/6/3.
//

import Foundation
import Fluent
import Vapor

struct CommentTodo: Content {
    var Text: String
    var UserName : String
    var ArticleID : UUID
    var LikeCount:String
}
