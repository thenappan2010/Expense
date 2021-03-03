//
//  AppDelegate.swift
//  Expensee
//
//  Created by temp on 23/02/21.
//

import UIKit
import CoreData
import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher


  
@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    public var driveService : GTLRDriveService =  GTLRDriveService()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupGoogle()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Expensee")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func setupGoogle()
    {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.clientID = "570372699845-fcqls9u21e4sfqp1fmg0la7hdsiur2mg.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.scopes =
                    [kGTLRAuthScopeDrive,kGTLRAuthScopeDriveFile,kGTLRAuthScopeDriveMetadata]
                
        GIDSignIn.sharedInstance()?.signInSilently()
    }

}


extension AppDelegate : GIDSignInDelegate,GIDSignInUIDelegate
{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {

        guard let user = user else {

            return
        }
            driveService.authorizer = user.authentication.fetcherAuthorizer()
//            driveService.authorizer = user.authentication.fetcherAuthorizer()
            var accDetail = [AnyHashable: Any]()
            accDetail["username"] = user.profile.name
            accDetail["email"] = user.profile.email
            accDetail["userId"] = user.userID
            accDetail["serverAuthCode"] = user.serverAuthCode
            accDetail["idToken"] = user.authentication.idToken

//           Utils.setPreferenceValue(setValue: accDetail, ForKey: kGoogleUser)
//           NotificationCenter.default.post(name: NSNotification.Name("DSGoogleSignIn"), object: nil)
    }
    
    
}
