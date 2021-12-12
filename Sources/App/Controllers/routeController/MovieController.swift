//
//  File.swift
//  
//
//  Created by JacksonTmm on 1/12/2021.
//

import Foundation
import Fluent
import Vapor
import FluentPostgresDriver

//All the movie will apply the recommandation system
final class MovieController {

    //TODO - Get Movie Info(id,namemmposter)
    func getMovieByGenre(req: Request) throws -> EventLoopFuture<MovieCardInfoResponse> {
        //By now, fetch from db for testing...
        guard let postgresSql = (req.db as? PostgresDatabase)?.sql() else {
            throw Abort(.internalServerError,reason:"DB INTERNAL ERROR")
        }
        
        guard let genreID = try? req.query.get(Int.self, at: "genre") else{
            throw Abort(.badRequest,reason: "genre is missing")
        }
//
        let sql = """
            SELECT movie_info_id as id ,title,poster_path as poster,movie_infos.vote_average  FROM genres_movies
            INNER JOIN movie_infos ON genres_movies.movie_info_id = movie_infos."id"
            INNER JOIN genre_infos ON genres_movies.genre_info_id = genre_infos."id"
            WHERE genre_infos.id = \(genreID) ORDER BY RANDOM() LIMIT 20;
        """
        return postgresSql.raw(SQLQueryString(sql)).all(decoding: MovieCardInfo.self).map{data -> MovieCardInfoResponse in

            return MovieCardInfoResponse(results:data)
        }
    }
}

