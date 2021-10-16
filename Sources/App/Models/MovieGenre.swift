import Foundation
import Fluent
import Vapor

final class GenresMovies : Model{
    static let schema = "genres_movies"

    @ID(custom: "id")
    var id: Int?

    @Parent(key :"movie_info_id") //bingding to movie_infos id
    var movieID : Movie

    @Parent(key:"genre_info_id") //binding to genre_infos id
    var genreID : GenreModel

    init(){}

    init(id:Int?,movie_ID : Movie,genre_ID : GenreModel) throws{
        self.id = id
        self.$movieID.id = try movieID.requireID()
        self.$genreID.id = try genreID.requireID()
    }
}