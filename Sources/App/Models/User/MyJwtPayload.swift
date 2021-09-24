//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/5/21.
//

import Vapor
import JWT

struct MyJwtPayload: Authenticatable, JWTPayload {
    var id: UUID?
    var UserName: String
    var exp: ExpirationClaim
    
    func verify(using signer: JWTSigner) throws {   //configure.swift:37
        try self.exp.verifyNotExpired()     //verify the token is not expired
    }
}
