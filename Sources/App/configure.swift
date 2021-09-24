import Fluent
import FluentPostgresDriver
import Vapor
import JWT

extension String{
    var bytes:[UInt8] { .init(self.utf8) }
}

extension JWKIdentifier{
    static let `public` = JWKIdentifier(string: "public")
    static let `private` = JWKIdentifier(string: "private")
}

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.http.server.configuration.port = 8080
    
    app.databases.use(.postgres(hostname: "localhost" ,username: "postgres",password:"",database:"MovieDB"), as: .psql)

//    app.migrations.add(CreateTodo())

    // register routes
    try routes(app)
}
