//
//  File.swift
//  
//
//  Created by Jackson on 7/10/2021.
//

import Foundation
import Fluent
import Vapor
import FluentPostgresDriver

final class PlaygroundController {
    
    //this will change to load data form our database
    func getActor(req: Request) throws -> EventLoopFuture<PersonInfoResponse>{
        // //getting a page number to get the data
        guard let maxItem = Environment.process.PAGE_PER_ITEM else{
            throw Abort(.internalServerError,reason: "INTERNAL ERROR")
        }
        
        guard let postgresSql = (req.db as? PostgresDatabase)?.sql() else {
            throw Abort(.internalServerError,reason:"DB INTERNAL ERROR")
        }
        
        let page = abs((try? req.query.get(Int.self, at: "page") as Int) ?? 1 )//default 1
        let offset = Int(maxItem) ?? 20
        let pageOffset = (page - 1) * offset
        
        let sql = """
        SELECT id,department as known_for_department,name,profile_path
        FROM person_infos
        WHERE department = 'Acting' LIMIT \(maxItem) OFFSET \(pageOffset)
        """
        
        return postgresSql.raw(SQLQueryString(sql)).all(decoding: PersonData.self).map{results -> PersonInfoResponse in
            return PersonInfoResponse(response: results)
        }

    }

    //http://127.0.0.1:8080/api/playground/getDirector?page=1s
    func getDirector(req : Request) throws -> EventLoopFuture<PersonInfoResponse>{
        guard let maxItem = Environment.process.PAGE_PER_ITEM else{
            throw Abort(.internalServerError,reason: "INTERNAL ERROR")
        }
        guard let postgresSql = (req.db as? PostgresDatabase)?.sql() else {
            throw Abort(.internalServerError,reason:"DB INTERNAL ERROR")
        }

        let page = abs((try? req.query.get(Int.self, at: "page") as Int) ?? 1 )//default 1
        let offset = Int(maxItem) ?? 20
        let pageOffset = (page - 1) * offset

        let sql = """
         SELECT person_infos.id,person_infos.name,person_infos.profile_path,crews.department as known_for_department
         FROM (SELECT person_id , department FROM person_crews WHERE department = 'Directing'
         GROUP BY (person_id,department)) AS crews INNER JOIN person_infos ON person_infos.id =  crews.person_id ORDER BY person_id ASC LIMIT \(maxItem) OFFSET \(pageOffset)
        """
        // print(sql)
        return postgresSql.raw(SQLQueryString(sql)).all(decoding: PersonData.self).map{results -> PersonInfoResponse in
                return PersonInfoResponse(response: results)
        }
        
    }
    
    //this controller will only get one genre datac
    func getGenreById(req : Request) throws ->  EventLoopFuture<GenreInfoResponse> {
        //join 2 table -> this will
        // let api = APIGenreResponse(id:1)
        let log = Logger.init(label: "API:")
        log.debug("Getting movie data by genre id")
        guard let postgresSql = (req.db as? PostgresDatabase)?.sql() else {
            throw Abort(.internalServerError,reason:"DB INTERNAL ERROR")
        }
        
        guard let genreId = (try? req.query.get(Int.self, at: "id") as Int) else {
            throw Abort(.badRequest,reason:"ID NOT PROVIDED")
        }
        
        var amount = abs((try? req.query.get(Int.self, at: "size") as Int) ?? 5 )//default 1
        if amount > 20{
            amount = 20
        }
        
        let sql = """
         SELECT genre_infos.id,genre_infos.name,movie_infos.poster_path as describe_img FROM genres_movies
         INNER JOIN movie_infos ON movie_infos."id" = genres_movies.movie_info_id
         INNER JOIN genre_infos ON genre_infos."id" = genres_movies.genre_info_id
         WHERE genre_infos.id = \(genreId) ORDER BY RANDOM() LIMIT \(amount)
        """
        
        return postgresSql.raw(SQLQueryString(sql)).all(decoding: GenreInfo.self).map{results -> GenreInfoResponse in
            return GenreInfoResponse(response: results)
        }

    }
    
    func getGenreAll(req : Request) throws -> EventLoopFuture<GenreInfoResponse>{
        //this route will only send 1 result ,account to provided data
        guard let postgresSql = (req.db as? PostgresDatabase)?.sql() else {
            throw Abort(.internalServerError,reason:"DB INTERNAL ERROR")
        }
        
        //logging debug message
        let log = Logger.init(label: "API:")
        log.debug("Getting movie data by genre id")
        
        //getting all genre id
        let genreSql = "SELECT id, name FROM genre_infos ORDER BY id"

        return postgresSql.raw(SQLQueryString(genreSql)).all(decoding: GenreData.self).flatMap{genreDatas -> EventLoopFuture<GenreInfoResponse> in
            
            var queryEventLoops :[EventLoopFuture<GenreInfo?>] = []
            for genre in genreDatas{
                let sql = """
                 SELECT genre_infos.id,genre_infos.name,movie_infos.poster_path as describe_img FROM genres_movies
                 INNER JOIN movie_infos ON movie_infos."id" = genres_movies.movie_info_id
                 INNER JOIN genre_infos ON genre_infos."id" = genres_movies.genre_info_id
                 WHERE genre_infos.id = \(genre.id) ORDER BY RANDOM() LIMIT 1
                """
                
                let data = postgresSql.raw(SQLQueryString(sql)).first(decoding: GenreInfo.self)
                queryEventLoops.append(data)
            }
            
            
            return queryEventLoops.flatten(on: req.eventLoop).map{queryDatas -> GenreInfoResponse in
                var responseDatas : [GenreInfo] = []
                queryDatas.forEach{ info in
                    if let data = info {
                        responseDatas.append(data)
                    }
                }
                return GenreInfoResponse(response: responseDatas)
            }
        }
    }
    
    func getPreviewMovie(req : Request) throws -> String{
        return "test"
    }
    
    func postPreviewResult(req : Request) throws -> EventLoopFuture<MoviePreviewInfo>{
        // front will send a item Collectionx
        //return just one movie for user preview
        
        //Testing!!
        guard let postgresSql = (req.db as? PostgresDatabase)?.sql() else {
            throw Abort(.internalServerError,reason:"DB INTERNAL ERROR")
        }
        
        guard let movieID = req.headers["movie_id"].first else{
            req.logger.debug("MOVIE ID IS EMPTY")
            return req.eventLoop.future(MoviePreviewInfo(id: nil, title: nil, poster_path: nil, overview: nil, run_time: nil, release_date: nil, original_language: nil, genres: nil, casts: nil))
        }
        
        //Select a movie from db
        let movieSQL = """
                SELECT movie_infos."id",movie_infos.title,movie_infos.poster_path,movie_infos.overview,movie_infos.release_date,movie_infos.run_time,movie_infos.original_language
                FROM movie_infos
                WHERE movie_infos."id" = \(movieID)
        """
        
        return postgresSql.raw(SQLQueryString(movieSQL)).first(decoding: PreviewMovieInfo.self).flatMap{movieResult -> EventLoopFuture<MoviePreviewInfo> in
                let id = movieResult!.id
            
                let genreSQL = """
                    SELECT genre_infos."id",genre_infos."name" FROM genres_movies
                    INNER JOIN genre_infos ON genre_infos."id" = genres_movies.genre_info_id
                    WHERE genres_movies.movie_info_id = \(id);
                """

           return postgresSql.raw(SQLQueryString(genreSQL)).all(decoding: GenreData.self).flatMap{genres -> EventLoopFuture<MoviePreviewInfo> in
                
                let castSQL = """
                   SELECT movie_characters.id,person_infos."name",movie_characters."character" from movie_characters
                   INNER JOIN movie_infos ON movie_infos.id = movie_characters.movie_id
                   INNER JOIN person_infos ON person_infos.id = movie_characters.person_id
                   WHERE movie_infos."id" = \(id) ORDER BY "order" LIMIT 3;
                """
            
                return postgresSql.raw(SQLQueryString(castSQL)).all(decoding: MovieCast.self).map{casts -> MoviePreviewInfo in
                    return MoviePreviewInfo(id: movieResult!.id, title: movieResult!.title, poster_path: movieResult!.poster_path, overview: movieResult!.overview, run_time: movieResult!.run_time, release_date: movieResult!.release_date, original_language: movieResult!.original_language, genres: genres, casts: casts)
                }
           }
//
//
        }

//        return ""
    }
}

struct AlgorithmFormatJSON : Content{
    var Genres : [GenreInfo]
    var Actors : [PersonDataInfo]
    var Directors : [PersonDataInfo]
}

struct PreviewMovieInfo : Content {
    let id: Int
    let title: String
    let poster_path: String?
    let overview: String
    let run_time: Int
    let release_date: String?
    let original_language: String
}

struct MoviePreviewInfo : Content{
    let id: Int?
    let title: String?
    let poster_path: String?
    let overview: String?
    let run_time: Int?
    let release_date: String?
    let original_language: String?
    let genres : [GenreData]?
    let casts : [MovieCast]?
}

struct MovieCast: Content, Identifiable {
    let id: Int
    let character: String
    let name: String
}
