//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/10/27.
//


import Foundation
import Fluent
import FluentPostgresDriver
import Vapor

struct LikeMovieController: RouteCollection{
    
    func boot(routes: RoutesBuilder) throws {
        
        let likeMovie = routes.grouped("likeMovie")
        likeMovie.group("my"){ li in
            li.get(":userID",use: GetMyLike)
        }
        likeMovie.post("new",use: postLike)
        likeMovie.group("delete"){ li in
            li.delete(":likeMovieID",use: deleteLike)
        }
        likeMovie.group("check"){ li in
            li.group(":userID"){ i in
                i.get(":movieID",use: checkLikeMovie)
                
            }
        }
    }
    
    
    //----------------------------我的喜愛電影--------------------------------//

    func GetMyLike(req: Request) throws -> EventLoopFuture<[LikeMovie]> {

        guard let userID = req.parameters.get("userID") as UUID? else{
            throw Abort(.badRequest)
        }
        
        return  LikeMovie.query(on: req.db)
            .with(\.$user)
            .filter(LikeMovie.self, \LikeMovie.$user.$id == userID )
            .sort(\.$updatedOn, .descending)
            .all()

    }
    

    //----------------------------post喜愛電影-------------------------------//
    func postLike(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let todo = try req.content.decode(NewLikeMovie.self)

        return User.query(on: req.db)
            .filter(\.$id == todo.userID)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap{ usr in
                let likeMovie = LikeMovie(user: usr, movie: todo.movie, title: todo.title, posterPath: todo.posterPath)
                return likeMovie.create(on: req.db).transform(to: .ok)
            }
    }
    
    
    
   //-----------------------------delete喜愛電影-------------------------------//
   
   func deleteLike(req: Request) throws -> EventLoopFuture<HTTPStatus> {
       
       return LikeMovie.find(req.parameters.get("likeMovieID"), on: req.db)
           .unwrap(or: Abort(.notFound))
           .flatMap{ $0.delete(on: req.db) }
           .transform(to: .ok)
   }
    
    //-----------------------------check喜愛電影-------------------------------//
    
    func checkLikeMovie(req: Request) throws -> EventLoopFuture<[CheckLike]> {

        guard let userID = req.parameters.get("userID") as UUID? else{
            throw Abort(.badRequest)
        }
        guard let movieID = req.parameters.get("movieID") as Int? else{
            throw Abort(.badRequest)
        }
        
        let database = (req.db as! PostgresDatabase).sql()
        
        let sql = """
        SELECT like_movies."id"
        FROM like_movies
        WHERE movie_id = '\(movieID)' AND user_id = '\(userID)'
        """
        
        return database.raw(SQLQueryString(sql)).all(decoding: CheckLike.self).flatMapThrowing{ result -> [CheckLike] in
            return result
        }
     
    }
   
}
