//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/9/24.
//

import Foundation
import Fluent
import Vapor

final class ListMovie: Model, Content{
    static let schema = "lists_movies"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "list_id")
    var list: List

    @Field(key: "movie_id")
    var movie: Int
    
    @Field(key: "movie_title")
    var title: String
    
    @Field(key: "movie_posterPath")
    var posterPath: String
    
    @Field(key: "user_feeling")
    var feeling: String
    
    @Field(key: "user_ratetext")
    var ratetext: Int


    init() {}

    init(id: UUID? = nil, list: List,movie:Int, title:String, posterPath:String, feeling:String, ratetext:Int){
        self.id = id
        self.$list.id = list.id!
        self.movie = movie
        self.title = title
        self.posterPath = posterPath
        self.feeling = feeling
        self.ratetext = ratetext
    }
}
