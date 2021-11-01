
import Foundation
import Fluent
import Vapor


//Many to Many relationship
//A Movie -> more than 1 genre
//A genre -> can have more than 1 movie

final class PersonInfo: Model,Content {
    
    static let schema = "person_infos"
    
    @ID(custom: "id") //primary key
    var id: Int?
    
    //movie data infos
    @Field(key:"adult")
    var adult : Bool

    @Field(key:"gender")
    var gender : Int

    @Field(key:"department")
    var department : String

    @Field(key:"name")
    var name : String

    @Field(key:"popularity")
    var popularity : Float64

    @Field(key:"profile_path")
    var profilePath : String

    @Children(for:\.$person)
    var crews : [PersonCrew]

    @Children(for : \.$person)
    var chararcters : [MovieCharacter]
    
    init(){}

    // //to create the instance of the model
    init (
        id: Int?, 
        adult : Bool,
        gender : Int,
        department : String,
        popularity : Float64,
        profilePath : String
    ){
        self.id = id
        self.adult = adult
        self.gender = gender
        self.department = department
        self.popularity = popularity
        self.profilePath = profilePath
    }
}
