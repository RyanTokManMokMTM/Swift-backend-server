//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/5/21.
//

import Foundation
import Fluent
import Vapor

struct ArticleController: RouteCollection{
    
    func boot(routes: RoutesBuilder) throws {
        
        let articles = routes.grouped("article")
        articles.group(":movieID"){ art in
            art.get(use: GetArticle)
        }
        articles.group("my"){ lis in
            lis.get(":userID",use: GetMyArticle)
        }
     
        articles.post("new", use: postArticle)
        articles.put("update", use: updateArticle)
        articles.group("delete"){ art in
            art.delete(":articleID",use: deleteArticle)
        }
        
    }
    
    //--------------------------------get某電影的討論區文章--------------------------------//
    func GetArticle(req: Request) throws -> EventLoopFuture<[Article]> {

        guard let movieID = req.parameters.get("movieID") as Int? else{
            throw Abort(.badRequest)
        }
        return  Article.query(on: req.db)
            .with(\.$user)
            .sort(\.$updatedOn, .descending)
            .filter(Article.self, \Article.$movie == movieID )
            .all()

    }
    
    //--------------------------------get我發的討論區文章--------------------------------//
    func GetMyArticle(req: Request) throws -> EventLoopFuture<[Article]> {

        guard let userID = req.parameters.get("userID") as UUID? else{
            throw Abort(.badRequest)
        }
        
        return  Article.query(on: req.db)
            .with(\.$user)
            .filter(Article.self, \Article.$user.$id == userID )
            .sort(\.$updatedOn, .descending)
            .all()

    }
    
    //--------------------------------post文章在討論區--------------------------------//
    func postArticle(req: Request) throws -> EventLoopFuture<Article> {
        let todo = try req.content.decode(NewArticle.self)

        return User.query(on: req.db)
            .filter(\.$id == todo.userID)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap{ usr in
                let detail = Article(Title: todo.Title, Text: todo.Text, user: usr, movie: todo.movieID, LikeCount: 0)
                return detail.create(on: req.db).map{ detail }
            }
    }
    
    //--------------------------------update文章--------------------------------//
    func updateArticle(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let update = try req.content.decode(UpdateArticle.self)

        return Article.find(update.articleID, on: req.db)
            .unwrap(or: Abort(.notFound))   //找不到ID就回傳not found
            .flatMap{
                $0.Title = update.Title
                $0.Text = update.Text
                return $0.update(on: req.db).transform(to: .ok)
            }

    }
    
    //--------------------------------delete文章--------------------------------//
    func deleteArticle(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Article.find(req.parameters.get("articleID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{ $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    
    
}
