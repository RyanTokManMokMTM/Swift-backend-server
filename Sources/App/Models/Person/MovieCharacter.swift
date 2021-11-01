import Foundation
import Fluent
import Vapor


final class MovieCharacter: Model,Content {
    
    static let schema = "movie_characters"
    
    @ID(custom: "id") //primary key
    var id: Int?
    
    @Field(key:"character")
    var character : String

    @Field(key:"credit_id")
    var creditId : String

    @Field(key:"order")
    var order : Int

    @Parent(key: "person_id")
    var person : PersonInfo

    @Parent(key : "movie_id")
    var movie : Movie

    init(){}

    // //to create the instance of the model
    init (
        id: Int?, 
        character : String,
        creditId : String,
        Order : Int,
        movie : Movie,
        person : PersonInfo
    )throws{
        self.id = id
        self.character = character
        self.creditId = creditId
        self.order = Order
        self.$person.id = try person.requireID()
        self.$movie.id = try movie.requireID()
    }
}
