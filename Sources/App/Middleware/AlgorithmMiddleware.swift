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
        do{
            let collections = try req.content.decode([SearchRef].self)
            var resultSQL : String = ""
            var genreIds : [String] = []
            var personsInds : [String] = []
            
            //HERE ARE 3 DIFFERENT SITUATIONS
            //INCLUDE GENRES ,ACTOR,DIRECTOR INFOMATION
            //EXCULUED GENRES
            //EITHER INCLUED GENER OR PERSONS

            guard let postgresSql = (req.db as? PostgresDatabase)?.sql() else {
                return req.eventLoop.future(error: Abort(.badRequest,reason:"DB INTERNAL ERROR"))
            }
//
            for info in collections{
                switch info.type{
                case .Genre:
                    genreIds.append(String(info.id))
                case .Persons:
                    personsInds.append(String(info.id))
                }
            }
            let genres = genreIds.joined(separator: ",")
            let persons = personsInds.joined(separator: ",")

            if !persons.isEmpty{
                //Either one is not empty -> Inclued person id
                if genres.isEmpty{
                    resultSQL = """
                    SELECT DISTINCT movie_infos."id"
                      FROM movie_infos NATURAL JOIN movie_characters WHERE person_id in (\(persons)) ORDER BY id LIMIT 100
                    """
                }else{
                    resultSQL = """
                    SELECT  * FROM
                            ( SELECT DISTINCT movie_infos.title,movie_infos."id" FROM movie_infos NATURAL JOIN genres_movies WHERE genre_info_id in (\(genres))) as movieList
                    NATURAL JOIN movie_characters WHERE person_id in (\(persons)) LIMIT 100;
                    """
                }
            }else{
                //JUST included genres info
                resultSQL = """
                    SELECT DISTINCT movie_infos."id"
                    FROM movie_infos NATURAL JOIN genres_movies WHERE genre_info_id in (\(genres)) ORDER BY id LIMIT 100
                """
            }
            print(resultSQL)
            
            return postgresSql.raw(SQLQueryString(resultSQL)).all(decoding:ResultMovie.self).flatMap{result -> EventLoopFuture<Response> in

                var refMovieIds : [String] = []
                refMovieIds.append(contentsOf: result.map{String($0.id)})
                req.headers.add(name: "refMovieIds", value: refMovieIds.joined(separator: ","))
                
                return next.respond(to: req)
            }
            
        }catch{
            print(error)
            return req.eventLoop.future(error: Abort(.badRequest,reason:"JSON parse failed!"))
        }
        
    }
}


struct ResultMovie : Content{
    let id : Int
}
