//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/5/21.
//

import Foundation
import Fluent
import Vapor

//因為客戶端發表新文章時，只會傳回title和text 
struct ArticleTodo: Content {
    var Title : String
    var Text : String
    var Movie : Int
}
