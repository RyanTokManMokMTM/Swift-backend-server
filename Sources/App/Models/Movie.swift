//
//  Movie.swift
//  
//
//  Created by Kao Li Chi on 2021/5/1.
//

import Foundation
import Fluent
import Vapor

final class Movie: Model,Content {
    
    static let schema = "movies"
    
    @ID(custom: "movie_id") //primary key
    var id: Int?
    
    @Field(key: "movie_title")
    var title: String
    
    init(){}
    
    init (id: Int, title:String){
        self.id = id
        self.title = title
    }
    
    
}
