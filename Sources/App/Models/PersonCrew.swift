
import Foundation
import Fluent
import Vapor

final class PersonCrew: Model,Content {
    
    static let schema = "person_crews"
    
    @ID(custom: "id") //primary key
    var id: Int?

    @Field(key:"credit_id")
    var creditId : String

    @Field(key:"department")
    var department : String

    @Parent(key :"movie_id") //bingding to movie_infos id
    var movie : Movie

    @Parent(key:"person_id") //binding to genre_infos id
    var person : PersonInfo

    init(){}

    // //to create the instance of the model
    init (
        id: Int?, 
        creditId : String,
        department : String,
        personID : PersonInfo,
        movieID : Movie
    )throws{
        self.id = id
        self.creditId = creditId
        self.department = department
        self.$person.id = try personID.requireID()
        self.$movie.id = try movieID.requireID()
    }
}
