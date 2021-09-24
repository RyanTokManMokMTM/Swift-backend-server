//
//  File.swift
//
//
//  Created by Kao Li Chi on 2021/2/15.
//

import Foundation
import Fluent
import Vapor
import JWT

final class User: Model,Content {   // Controllers/APIController -> 11
    
    static let schema = "users"     //table name
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "UserName")
    var UserName: String
    
    @Field(key: "Email")
    var Email: String
    
    // 雜湊過的密碼，以策安全
    @Field(key: "Password")
    var Password: String
    
    
    init() {}
    
    init(id: UUID? = nil,UserName: String,Email:String,Password:String){
        self.id = id
        self.UserName = UserName
        self.Email = Email
        self.Password = Password
    }
        
}

extension User: ModelAuthenticatable {
    // 要取帳號的欄位
    static var usernameKey: KeyPath<User, Field<String>> = \User.$UserName
    // 要取雜湊密碼的欄位
    static var passwordHashKey: KeyPath<User, Field<String>> = \User.$Password
    
    // 確認密碼是否與資料庫的一致
    func verify(password: String) throws -> Bool {
        return try Bcrypt.verify(password, created: self.Password)
    }
}

//----------JWT驗證----------//
//this is middleware that runs on every single route
struct JWTBearerAuthenticator: JWTAuthenticator{
    typealias Payload = MyJwtPayload
    
    func authenticate(jwt: Payload, for request: Request) -> EventLoopFuture<Void> {
        do{
            //check the signature on the token which is MyJwrPayload
            try jwt.verify(using: request.application.jwt.signers.get()!)
            
            return
                User.find(jwt.id, on: request.db)
                    .unwrap(or: Abort(.notFound))   //找不到id就回傳not found
                    .map{ user in
                        request.auth.login(user)
                    }
        } catch {
            return request.eventLoop.makeSucceededFuture(())
        }
    }
}

//----------產生token (not encrypted but encoded)----------//
extension User{
    func generateToken(_ app: Application) throws -> String {
        var expDate = Date()
            expDate.addTimeInterval(86400 * 7)    //一天86400s, token七天後到期
        
        let exp = ExpirationClaim(value: expDate)
        
        return try app.jwt.signers.get(kid:.private)!.sign(MyJwtPayload(id: self.id , UserName: self.UserName, exp: exp))
    }
}

