//
//  SwiftUIView.swift
//  
//
//  Created by JacksonTmm on 13/12/2021.
//

import Foundation
import Fluent
import Vapor
import FluentPostgresDriver

final class TrailerVideoController {
    func getRecommandVideo(req : Request) throws -> EventLoopFuture<[TrailerInfo]>{
        guard let postgresSql = (req.db as? PostgresDatabase)?.sql() else {
            throw Abort(.internalServerError,reason:"DB INTERNAL ERROR")
        }
        
        let page = abs((try? req.query.get(Int.self, at: "page") as Int) ?? 1)
        
        
        let sql = """
        SELECT movieinfo.* ,string_to_array(string_agg(movie_video_infos.trailer_name , ',' ORDER BY movie_video_infos.release_time ASC),',') as video_titles ,string_to_array(string_agg(movie_video_infos.file_path, ',' ORDER BY movie_video_infos.release_time ASC),',') as video_paths FROM  (SELECT movie_infos."id",movie_infos.title,movie_infos.poster_path as poster,string_to_array(string_agg(genre_infos."name",','),',') as genres FROM genres_movies
        INNER JOIN movie_infos ON movie_infos."id" = genres_movies.movie_info_id
        INNER JOIN genre_infos ON genre_infos."id" = genres_movies.genre_info_id
        GROUP BY (movie_infos.title, movie_infos."id",poster)) as movieinfo
        INNER JOIN movie_video_infos ON movieinfo."id" = movie_video_infos.movie_id
        GROUP BY movieinfo."id",movieinfo.title,movieinfo.poster,movieinfo.genres ORDER BY id LIMIT 10 OFFSET \((page - 1) * 10);
        """
        
        return postgresSql.raw(SQLQueryString(sql)).all(decoding: TrailerInfo.self).flatMapThrowing{datas -> [TrailerInfo] in
            return datas
        }
    }
}

struct TrailerInfo : Content{
    let id : Int
    let title : String
    let genres : [String]
    let poster : String
    let video_titles : [String]
    let video_paths : [String]
}

struct TrailerInfoResponse : Content{
    let id : Int
    let title : String
    let genres : [String]
    let poster : String
    let video_infos : EpidesoInfo //JSON String
}

struct EpidesoInfo : Content{
    let title : String
    let path : String
}
