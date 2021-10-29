//
//  Movie.swift
//  
//
//  Created by Kao Li Chi on 2021/5/1.
//

import Foundation
import Fluent
import Vapor


//Many to Many relationship
//A Movie -> more than 1 genre
//A genre -> can have more than 1 movie

final class Movie: Model,Content {
    
    static let schema = "movie_infos"
    
    @ID(custom: "id") //primary key
    var id: Int?
    
    //movie data infos
    @Field(key:"adult")
    var adult : Bool

    @Field(key:"backdrop_path")
    var backdropPath : String

    // @Field(key:"GenreIds")
    // var adult : Bool

    @Field(key:"original_language")
    var originalLanguage : String

    @Field(key:"original_title")
    var originalTitle : String

    @Field(key:"overview")
    var overview : String

    @Field(key:"popularity")
    var popularity : Float64

    @Field(key:"poster_path")
    var posterPath : String

    @Field(key:"release_date")
    var releaseDate : String

    @Field(key:"title")
    var title : String

    @Field(key:"video")
    var video : Bool

    @Field(key:"vote_average")
    var voteAverage : Float64

    @Field(key:"vote_count")
    var voteCount : Int

    //required?
    @Timestamp(key:"created_at",on:.create)
    var createdAt : Date?

   //required?
    @Timestamp(key:"updated_at",on:.update)
    var updatedAt : Date?

   //required?
    @Timestamp(key:"deleted_at",on:.delete)
    var deletedAt : Date?

    @Siblings(through: GenresMovies.self, from: \.$movieID, to: \.$genreID)
    public var genres: [GenreModel]
    
    init(){}

    // //to create the instance of the model
    init (
        id: Int?, 
        adult:Bool,
        backdropPath:String,
        originalLanguage:String,
        overview:String,
        popularity:Float64,
        posterPath:String,
        releaseDate:String,
        title:String,
        video:Bool,
        voteAverage:Float64,
        voteCount : Int,
        createdAt : Date?,
        updatedAt : Date?,
        deletedAt : Date?
    ){
        self.id = id
        self.adult = adult
        self.backdropPath = backdropPath
        self.originalLanguage = originalLanguage
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }
}
