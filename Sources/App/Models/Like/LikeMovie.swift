//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/10/27.
//

import Foundation
import Fluent
import Vapor

final class LikeMovie: Model, Content{
    static let schema = "like_movies"

    @ID(key:.id)
    var id: UUID?

    @Parent(key: "user_id")
    var user: User

    @Field(key: "movie_id")
    var movie: Int
    
    @Field(key: "movie_title")
    var title: String
    
    @Field(key: "movie_poster_path")
    var posterPath: String

    @Timestamp(key: "like_movie_update", on: .update)
    var updatedOn: Date?

    init() {}

    init(id: UUID? = nil, user: User,movie:Int, title:String, posterPath:String){
        self.id = id
        self.$user.id = user.id!
        self.movie = movie
        self.title = title
        self.posterPath = posterPath
    }
}
