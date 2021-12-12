
import Foundation
import Fluent
import Vapor
import FluentPostgresDriver

final class SearchingController {
    init(){}

    func getRecommandSeachKey(req : Request) throws -> EventLoopFuture<[RecommandMovieKeyInfo]>{
        guard let postgresSql = (req.db as? PostgresDatabase)?.sql() else {
            throw Abort(.internalServerError,reason:"DB INTERNAL ERROR")
        }
        
        let sql = """
            SELECT id,title,overview FROM movie_infos WHERE vote_average > 6 ORDER BY RANDOM() LIMIT 20;
        """
        
        return postgresSql.raw(SQLQueryString(sql)).all(decoding: RecommandMovieKeyInfo.self).map{results -> [RecommandMovieKeyInfo] in
            return results
        }

    }

}


struct RecommandMovieKeyInfo : Content {
    let id : Int
    let title : String
    let overview : String
}


struct TMDBSearchResult : Content{
    let results : [TMDBSearchMovieInfo]
    let total_pages : Int
}

struct TMDBSearchMovieInfo : Content{
    let name : String
    let id : Int
}

struct TMDBSearchFullResult : Content{
    let results : [TMDBMovieResult]
    let total_pages : Int
}

struct TMDBMovieResult : Content {
    let adult : Bool
    let backdrop_path : String
    let genre_ids : [Int]
    let id : Int
    let original_language : String
    let original_title : String
    let overview : String
    let popularity : Float
    let poster_path : String
    let release_date : String
    let title : String
    let video : Bool
    let vote_average : Float
    let vote_count : Int
}
