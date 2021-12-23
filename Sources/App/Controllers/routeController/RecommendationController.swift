//  SwiftUIView.swift
//  
//
//  Created by JacksonTmm on 23/12/2021.
//
import Foundation
import Fluent
import Vapor
import FluentPostgresDriver

final class RecommendationController{
    init(){}
    
    func getRecommendationResult(req : Request) throws -> EventLoopFuture<MovieCardInfoResponse>{
        guard let movieIDs = req.headers["recommandIds"].first else{
            throw Abort(.internalServerError,reason: "SERVER ERROR")
        }
        
        guard let postgresSql = (req.db as? PostgresDatabase)?.sql() else{
            throw Abort(.internalServerError,reason:"DB INTERNAL ERROR")
        }
        
        if movieIDs.isEmpty{
            throw Abort(.noContent,reason: "NO ANY RECOMMAND MOVIES")
        }
        
        let sql = """
        SELECT movie_info_id as id ,title,poster_path as poster,movie_infos.vote_average  FROM genres_movies
        INNER JOIN movie_infos ON genres_movies.movie_info_id = movie_infos."id"
        INNER JOIN genre_infos ON genres_movies.genre_info_id = genre_infos."id"
        WHERE movie_info_id in (\(movieIDs))
        GROUP BY movie_info_id ,title,poster_path ,movie_infos.vote_average ORDER BY movie_info_id
        """
        return postgresSql.raw(SQLQueryString(sql)).all(decoding: MovieCardInfo.self).map{data -> MovieCardInfoResponse in

            return MovieCardInfoResponse(results:data)
        }
        
    }
}
