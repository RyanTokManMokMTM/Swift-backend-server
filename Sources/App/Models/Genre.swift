import Foundation
import Fluent
import Vapor

final class GenreModel : Model,Content{
    static let schema = "genre_infos"

    @ID(custom: "id")
    var id : uint?

    @Field(key:"name")
    var name : String

    @Timestamp(key:"created_at",on:.create)
    var createdAt : Date?

    @Timestamp(key:"updated_at",on:.update)
    var updatedAt : Date?

    @Timestamp(key:"deleted_at",on:.delete)
    var deletedAt : Date?

    @Siblings(through: GenresMovies.self, from: \.$genreID, to: \.$movieID)
    public var movies: [Movie] //has a list of movie

    init(){
    }

    init(
        id : uint,
        name : String,
        createdAt : Date?,
        updatedAt : Date?,
        deletedAt : Date?){
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }
} 