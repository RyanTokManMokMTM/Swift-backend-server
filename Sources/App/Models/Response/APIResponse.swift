import Foundation
import Fluent
import Vapor


struct PersonData: Content {
    var id:Int
    var name: String
    var known_for_department: String?
    var profile_path: String?
}

struct GenreInfo : Content {
    var id : Int //genre id
    var name : String //genre name
    var describe_img : String //using any image which movie can describe this Genre (URL)
}

struct GenreData : Content{
    let id : Int
    let name : String
}

struct PersonInfoResponse : Content{
    var response : [PersonData]
}

struct GenreInfoResponse : Content {
    var response : [GenreInfo]
}

