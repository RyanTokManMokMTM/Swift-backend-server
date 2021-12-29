//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/5/21.
//

import Foundation
import Vapor
import Fluent

struct UserController: RouteCollection{

    func boot(routes: RoutesBuilder) throws {

        let users = routes.grouped("users")
    
        users.group("register"){ usr in
            usr.post(use: register)
        }
        
        users.group(":userID"){ usr in
            usr.get(use: GetUser)
        }
        
        users.group("login"){ usr in
            usr.post(use: login)
        }
        
        users.grouped(JWTBearerAuthenticator())     //做JWT驗證
            .group("me"){ usr in
                usr.get(use: me)
            }

    }
    
    //----------JWT驗證使用者身份----------//
    //假設驗證成功, return the user
    func me(req: Request) throws -> EventLoopFuture<Me> {
        let user = try req.auth.require(User.self)
        let UserName = user.UserName
        
        return User.query(on: req.db)
            .filter(\.$UserName == UserName)    //get username of the db
            .first()
            .unwrap(or: Abort(.notFound))
            .map { usr in
                return Me(id: usr.id ,UserName: user.UserName)
            }
    }
    
    //----------使用者登入----------//
    //return Token as string , so return event loop future string
    func login(req: Request) throws -> EventLoopFuture<String> {
        let userToLogin = try req.content.decode(UserLogin.self)    //get username and password

        return User.query(on: req.db)
            .filter(\.$UserName == userToLogin.UserName)    //get username of the db
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { dbUser in
                let verified = try dbUser.verify(password: userToLogin.Password)     //verify password
                if verified == false {
                    throw Abort(.unauthorized)
                }
                req.auth.login(dbUser)                              //verify successful then login
                let user = try req.auth.require(User.self)
                return try user.generateToken(req.application)      //generate the token and send it to the user
            }
    }
    
    
    //----------使用者註冊----------//
    func register(req: Request) throws -> EventLoopFuture<User>{
        // 檢查email和password的格式
        
        try UserRegister.validate(content: req)
        
        // 從request body中decode出UserRegister
        let newUser = try req.content.decode(UserRegister.self)
        print(newUser)

        
        //確定password和confirmpassword是否一致
        guard newUser.password == newUser.confirm_password else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }
       
        // 將UserRegister 轉成 User
        let user = try User(UserName:newUser.user_name, Email: newUser.email, Password: Bcrypt.hash(newUser.password), UserPhoto: "p1.jpg")
        
        return user.save(on: req.db).map { user }
    }

    //----------GET使用者info----------//
    func GetUser(req: Request) throws -> EventLoopFuture<User>{
        
        guard let userID = req.parameters.get("userID") as UUID? else{
            throw Abort(.badRequest)
        }
        
        
        return User.query(on: req.db)
            .filter(\.$id == userID )
            .first()
            .unwrap(or: Abort(.notAcceptable))
            .map { usr in
                return usr
            }
    }



    
    
}
