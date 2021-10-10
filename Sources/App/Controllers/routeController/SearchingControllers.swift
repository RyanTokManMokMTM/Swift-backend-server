
import Foundation
import Fluent
import Vapor


final class SearchingController {
    init(){}

    //Static value internally
    //we may need to filter it according to our user and algorithmn
    private let searchURI = "/search/keyword"

    func getSearchingResult(req : Request) throws -> EventLoopFuture<[TMDBSearchMovieInfo]>{
        // TODO
        // This router are going to use API Seaching -> return JSON
        // This JSON Include movie id and its name -> according to id or name 
        // filter it with our algorithm

        // it may have more than 1 page -> ...
        // for now on just fetching the first page for testing

        //getting the keyword from uri
        //person??????????????????????????????????/
        guard let keyword = req.parameters.get("keyWord") else{
            throw Abort(.badRequest,reason: "keyword is required")
        }

        guard let apiKey = Environment.process.TMDB_API_KEY  else {
            throw Abort(.serviceUnavailable,reason: "API KEY not found")
        }

        guard let host = Environment.process.TMDB_DOMAIN_NAME else {
            throw Abort(.serviceUnavailable,reason: "DOMAIN not found")
        }
        
        let page = 1
        let uri = "\(host)\(self.searchURI)?api_key=\(apiKey)&query=\(keyword)&page=\(page)"
        let client = req.client

       return client.get(URI(string: uri)).flatMapThrowing{ res -> [TMDBSearchMovieInfo] in
            guard let jsonResults = try? res.content.decode(TMDBSearchResult.self) else {
                throw Abort(.internalServerError)
            }

            return jsonResults.results
        }
    }

    func getSearchingFinalResult(req : Request) throws -> EventLoopFuture<[TMDBMovieResult]>{
        //using getRecommandation??
        //using getSimilar?
        guard let keyword = req.parameters.get("seachKeyWord") else{
            throw Abort(.badRequest,reason: "keyword is required")
        }

        
        guard let apiKey = Environment.process.TMDB_API_KEY  else {
            throw Abort(.serviceUnavailable,reason: "API KEY not found")
        }

        guard let host = Environment.process.TMDB_DOMAIN_NAME else {
            throw Abort(.serviceUnavailable,reason: "DOMAIN not found")
        }

        //get recommandation, assume id is movie id right now
        //
        let client = req.client
        let recommandationURI = "/movie/\(keyword)/recommendations"
        // let similaryURI = "/movie/\(keyword)/similar"
        let page = 1
        let recommandReq = "\(host)\(recommandationURI)?api_key=\(apiKey)&page=\(page)"
        // let similarydReq = "\(host)\(similaryURI)?api_key=\(apiKey)&page=\(page)"

        //send the request and fetching the result
        return client.get(URI(string: recommandReq)).flatMapThrowing{res -> [TMDBMovieResult] in 
            guard let jsonResults = try? res.content.decode(TMDBSearchFullResult.self) else {
                 throw Abort(.internalServerError,reason: "API Error")
            }

            return jsonResults.results
        }
    }
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