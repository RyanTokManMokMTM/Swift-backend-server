import Foundation
import Fluent
import Vapor

//Person list []
// Actor : [Person] -> known_for_department : Acting
// Director : [Person] -> known_for_department : Direcotr
struct PersonData: Content {
    var id:Int
    var name: String
    var known_for_department: String? //
    var profile_path: String?
}

struct GenreInfo : Content {
    var id : Int //genre id
    var name : String //genre name
    var describe_img : String //using any image which movie can describe this Genre (URL)
}

struct GenreData : Content,Identifiable{
    let id : Int
    let name : String
}

struct PersonInfoResponse : Content{
    var response : [PersonData]
}

struct GenreInfoResponse : Content {
    var response : [GenreInfo]
}

struct PreviewDataInfo : Identifiable, Content{
    let id : String
    let itemType : PreviewInfo? //descrip what data in used
    let genreData : GenreInfo? //only for genre
    let personData : PersonDataInfo? //only for actor and director
}

struct PersonDataInfo : Content,Identifiable {
    let id:Int
    let name: String
    let known_for_department: String
    let profile_path: String?
}

enum PreviewInfo : String,Content{
    case Actor = "Actor"
    case Director = "Director"
    case Genre = "Genre"
}

//Movie Card
struct MovieCardInfo : Content{
    let id : Int
    let title : String
    let poster : String
    let vote_average : Double
}

struct MovieCardInfoResponse : Content{
    var results : [MovieCardInfo]
}


struct SearchRef : Content{
    let id : Int
    let type : RefType
}

enum RefType :Content{
    case Persons
    case Genre
}

