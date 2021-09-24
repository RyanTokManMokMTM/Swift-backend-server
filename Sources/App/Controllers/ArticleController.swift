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
        articles.get(use: index)
//        articles.post(use: create)
        articles.group(":articleID"){ article in
            article.delete(use: delete)
        }
        
    }

    func index(req: Request) throws -> EventLoopFuture<[Article]> {
        return Article.query(on: req.db)
            .with(\.$user)
            .with(\.$movie)
            .all()
    }
    
    
//    func create(req: Request) throws -> EventLoopFuture<Article> {
//        let todo = try req.content.decode(ArticleTodo.self)
//        return User.query(on: req.db)
//            .filter(\.$UserName == "joyce" )
//            .first()
//            .unwrap(or: Abort(.notFound))
//            .flatMap{ usr in
//                let article = Article(Title: todo.Title, Text:todo.Text , user : usr)
//                return article.create(on: req.db).map{ article }
//            }
//
//    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Article.find(req.parameters.get("articleID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{ $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    
    
}
