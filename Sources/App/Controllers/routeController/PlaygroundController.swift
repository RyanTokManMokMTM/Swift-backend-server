//
//  File.swift
//  
//
//  Created by Jackson on 7/10/2021.
//

import Foundation
import Fluent
import Vapor


final class PlaygroundController {
    private let host = "https://api.themoviedb.org/3"
    private let apiKey = "29570e7acc52b3e085ab46f6a60f0a55"
    private let genreURI = "/genre/movie/list"
    private let decoder = JSONDecoder()
    
    func getActor(req: Request) throws -> String{
        return "a"
    }
    
    func getGenre(req : Request) throws ->  EventLoopFuture<[DragGenreData]> {
        /*TODO:
         just getting data and combine data and return
         PROCESS: get All genre(futrue) -> fetch data from anthore api(desscription image)(future)
         */
        let client = req.client
        let genreURI = "\(self.host)/genre/movie/list?api_key=\(self.apiKey)&language=en-US"
        
      return client.get(URI(string: genreURI)).flatMap{ res -> EventLoopFuture<[DragGenreData]> in
            do{
                let resData = try res.content.decode(Genre.self)
                let genreInfo = resData.genres
                var genreMovieResults : [EventLoopFuture<SpecifyGenreMovieResult>] = []
    //
                for info in genreInfo {
                    let uri = "\(self.host)/discover/movie?api_key=\(self.apiKey)&language=en-US&sort_by=popularity.desc&page=1&with_genres=\(info.id)"
                    let movieInfoFuture = client.get(URI(string: uri)).flatMapThrowing{infoRes -> SpecifyGenreMovieResult in
                        return try infoRes.content.decode(SpecifyGenreMovieResult.self) //try to decode content ->body to our model
                    }
                    genreMovieResults.append(movieInfoFuture)
                }
                
               return genreMovieResults.flatten(on: req.eventLoop).map{info -> [DragGenreData] in
                    var dragResult : [DragGenreData] = []
                    for i in 0..<info.count{
                        let result = DragGenreData(info: genreInfo[i], describeImg: info[i].results.randomElement()!.poster_path)
                        dragResult.append(result)
                    }
                    return dragResult
                }
            } catch{
                return req.eventLoop.makeFailedFuture(error)
            }
        }
    }
    
    func getDirector(req : Request) throws -> String{
        return "Hello"
    }
    
    
}
