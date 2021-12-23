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

struct LikeArticleController: RouteCollection{
    
    func boot(routes: RoutesBuilder) throws {
        
        let likeArticle = routes.grouped("likeArticle")
        likeArticle.group("my"){ li in
            li.get(":userID",use: GetMyLike)
        }
        likeArticle.post("new",use: postLike)
        likeArticle.group("delete"){ li in
            li.delete(":likeArticleID",use: deleteLike)
        }
        likeArticle.group("check"){ li in
            li.group(":userID"){ i in
                i.get(":articleID",use: checkLikeArticle)
                
            }
        }
    }
    
    
    //----------------------------我的喜愛文章--------------------------------//

    func GetMyLike(req: Request) throws -> EventLoopFuture<[LikeTodo]> {

        guard let userID = req.parameters.get("userID") as UUID? else{
            throw Abort(.badRequest)
        }
        let database = (req.db as! PostgresDatabase).sql()
        
        let sql = """
        SELECT Art.*,users."user_name",users."user_avatar"
        FROM (SELECT like_articles.id AS like_id ,like_articles.user_id AS like_user_id ,
        articles."id" AS article_id ,articles.article_title, articles.article_text,articles.user_id,
        articles.movie_id, articles.article_like_count, articles.article_last_update
        FROM like_articles
        INNER JOIN articles ON articles."id" = like_articles.article_id
        INNER JOIN users ON users."id" = like_articles.user_id) AS Art INNER JOIN users ON users."id" = Art.user_id
        WHERE Art.like_user_id = '\(userID.description)'
        """
        
        return database.raw(SQLQueryString(sql)).all(decoding: LikeTodo.self).flatMapThrowing{ result -> [LikeTodo] in
            return result
        }

    }
    
    

    //----------------------------post喜愛文章-------------------------------//
    func postLike(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let todo = try req.content.decode(NewLikeArticle.self)
        
        return Article.query(on: req.db)
            .filter(\.$id == todo.articleID)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap{ art in
                User.query(on: req.db)
                    .filter(\.$id == todo.userID)
                    .first()
                    .unwrap(or: Abort(.notFound))
                    .flatMap{ usr in
                        let likeArticle = LikeArticle(user: usr, article: art)
                        return likeArticle.create(on: req.db).transform(to: .ok)
                    }
            }
        

 
    }
    
    
    
   //-----------------------------delete喜愛文章-------------------------------//
   
   func deleteLike(req: Request) throws -> EventLoopFuture<HTTPStatus> {
       return LikeArticle.find(req.parameters.get("likeArticleID"), on: req.db)
           .unwrap(or: Abort(.notFound))
           .flatMap{ $0.delete(on: req.db) }
           .transform(to: .ok)
   }
    
    
    
    //-----------------------------check喜愛文章-------------------------------//
    
    func checkLikeArticle(req: Request) throws -> EventLoopFuture<[CheckLike]> {
        guard let userID = req.parameters.get("userID") as UUID? else{
            throw Abort(.badRequest)
        }
        guard let articleID = req.parameters.get("articleID") as UUID? else{
            throw Abort(.badRequest)
        }
        
        let database = (req.db as! PostgresDatabase).sql()
        
        let sql = """
        SELECT like_articles."id"
        FROM like_articles
        WHERE article_id = '\(articleID)' AND user_id = '\(userID)'
        """
        
        return database.raw(SQLQueryString(sql)).all(decoding: CheckLike.self).flatMapThrowing{ result -> [CheckLike] in
            return result
        }
     
    }
    
    
   
}
