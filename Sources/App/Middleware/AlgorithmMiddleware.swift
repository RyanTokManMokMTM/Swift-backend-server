//
//  File.swift
//  
//
//  Created by Jackson on 2/11/2021.
//

import Foundation
import Vapor
import FluentPostgresDriver

struct PreviewResultAlgorithmMiddleware : Middleware {
    func respond(to req: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        guard let collection = try? req.content.decode([PreviewDataInfo].self) else {
            return req.eventLoop.future(error: Abort(.badRequest,reason:"JSON parse failed!"))
        }
        var AlgorithmData : AlgorithmFormatJSON = AlgorithmFormatJSON(Genres: [], Actors: [], Directors: [])
        for dataInfo in collection{
            print(dataInfo.itemType)
            switch dataInfo.itemType {
            case .Genre:
                AlgorithmData.Genres.append(dataInfo.genreData!)
                break
            case .Actor:
                AlgorithmData.Actors.append(dataInfo.personData!)
                break
            case .Director:
                AlgorithmData.Directors.append(dataInfo.personData!)
                break
                
            }
        }
        
        print(AlgorithmData.Genres.count)
        print(AlgorithmData.Actors.count)
        print(AlgorithmData.Directors.count)
        
        guard let postgresSql = (req.db as? PostgresDatabase)?.sql() else {
            return req.eventLoop.future(error: Abort(.badRequest,reason:"DB INTERNAL ERROR"))
        }

        
        //Testing
        let movieTempSql = """
            SELECT id FROM movie_infos ORDER BY RANDOM() LIMIT 1 ;
        """
        
        return postgresSql.raw(SQLQueryString(movieTempSql)).first(decoding:ResultMovie.self).flatMap{result -> EventLoopFuture<Response> in
            
            guard let movieID = result else {
                return req.eventLoop.future(error: Abort(.badRequest,reason:"DB INTERNAL ERROR"))
            }

            
            req.headers.add(name: "movie_id", value: String(movieID.id))
            
            return next.respond(to: req)
        }
    }
}


struct ResultMovie : Content{
    let id : Int
}
