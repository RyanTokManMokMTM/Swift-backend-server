//
//  File.swift
//  
//
//  Created by Jackson on 5/10/2021.
//

import Foundation
import Fluent
import Vapor

final class SearchController{
    
}
//
//struct SearchController: RouteCollection{
//    
//    // /api/dragitem/get
//    func boot(routes: RoutesBuilder) throws {
//        // /api/search/....
//        let searchRoute = routes.grouped("api","search")
//        
//        // /api/search/playground/(to get drag and drop items)
//        let dragDropRoute = searchRoute.grouped("playground")
//    
//        dragDropRoute.on(.GET, "getGenre", use:getGenre) //get Genre
//        
//        
//    }
//    
//    func getGenre(req : Request) throws -> EventLoopFuture<Genre>{
////
//        return  req.client.get("https://api.themoviedb.org/3/genre/movie/list?api_key=29570e7acc52b3e085ab46f6a60f0a55&language=en-US").flatMapThrowing{ res -> Genre in
//            guard let result = res.body else {
//                throw Abort(.badRequest)
//            }
//            let jsData = Data(buffer:result)
//            let decoder = JSONDecoder()
//            do{
//                let json = try decoder.decode(Genre.self, from: jsData)
//    
////                for genre in json.genres{
////                    let id = genre.id
////
//////                    decoder.decode(SpecifyGenreMovieResult.self, from: <#T##Data#>)
////                }
//                return json
//            }catch{
//                print(error)
//                throw Abort(.badRequest)
//            
//            }
//        }
//    }
//    
//}

struct TempModel : Content{
    let id: Int
    let image: URL
    let caption: String

}

struct GenreData : Content {
    let id : Int
    let name : String
}

struct Genre : Content{
    let genres : [GenreData]
}

struct TMDBError : Content{
    let status_code : Int
    let status_message : String
    let success : Bool
}


struct DragGenreData : Content {
    let info : GenreData
    let describeImg : String //using any image which movie can describe this Genre (URL)
}

struct SpecifyGenreMovieResult: Content{
    let page : Int
    let results : [GenreMovieInfo]
}

struct GenreMovieInfo : Content{
    let poster_path : String
}
