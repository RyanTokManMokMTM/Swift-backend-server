//
//  SwiftUIView.swift
//  
//
//  Created by JacksonTmm on 13/12/2021.
//

import SwiftUI
import Fluent
import Vapor
import FluentPostgresDriver

final class TrailerVideoController {
    func getRecommandVideo(req : Request) throws -> EventLoopFuture<[TrailerInfo]>{
        guard let postgresSql = (req.db as? PostgresDatabase)?.sql() else {
            throw Abort(.internalServerError,reason:"DB INTERNAL ERROR")
        }
        
        let sql = """
        SELECT movieinfo.* , movie_video_infos.file_path as video_path FROM  (SELECT movie_infos."id",movie_infos.title,movie_infos.poster_path as poster,string_to_array(string_agg(genre_infos."name",','),',') as genres FROM genres_movies
          INNER JOIN movie_infos ON movie_infos."id" = genres_movies.movie_info_id
          INNER JOIN genre_infos ON genre_infos."id" = genres_movies.genre_info_id
          GROUP BY (movie_infos.title, movie_infos."id",poster)) as movieinfo
          INNER JOIN movie_video_infos ON movieinfo."id" = movie_video_infos.movie_id
          GROUP BY movieinfo."id",movieinfo.title,movieinfo.poster,movieinfo.genres,video_path LIMIT 10;
        """
        
        return postgresSql.raw(SQLQueryString(sql)).all(decoding: TrailerInfo.self).map{datas -> [TrailerInfo] in
            return datas
        }
    }
}

struct TrailerInfo : Content{
    let id : Int
    let title : String
    let genres : [String]
    let poster : String
    let video_path : String
}
