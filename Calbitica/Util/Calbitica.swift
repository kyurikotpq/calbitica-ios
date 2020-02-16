//
//  Calbitica.swift
//  Calbitica
//
//  Created by Student on 12/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import Foundation

// Where all API requests are made
// Serves as an middleman between the HttpUtil and the VCs
// so that VCs won't be so populated
class Calbitica {
    static let baseURL = "https://app.kyurikotpq.com/calbitica/api/"
    
    /**
    * Exchange auth code obtained locally for Calbitica JWTs
    */
    static func tokensFromAuthCode(_ code: String, closure: @escaping (String) -> Void) {
        let url = baseURL + "auth/code"
        let data = ["code": code] // data to pass in POST
        
        // When the response from API is returned,
        // run this function
        func httpFinishClosure(response: Data) {
            do {
                let decodedUser = try JSONDecoder().decode(User.self, from: response)
                closure(decodedUser.jwt)
            } catch {
//                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        // Make the HTTP Request
        HttpUtil.post(url: url, data: data, closure: httpFinishClosure)
    }
    

    static let calbitBaseURL = baseURL + "calbit/"
    static func getCalbits(closure: @escaping (CalbitsResponse) -> Void) {
        let url = calbitBaseURL
        
        // When the response from API is returned,
        // run this function
        func httpFinishClosure(response: Data) {
            do {
                let calbits = try JSONDecoder().decode(CalbitsResponse.self, from: response)
                
                if let jwt = calbits.jwt {
                    AuthController.handleJWTClosure(jwt: jwt)
                }
                closure(calbits)
            } catch {
//                print("JSON error: \(error.localizedDescription)")
            }
        }
        // Make the HTTP Request
        HttpUtil.get(url: url, closure: httpFinishClosure)
    }
    static func createCalbit(data: [String: Any], closure: @escaping (Data) -> Void) {
        let url = calbitBaseURL
        HttpUtil.post(url: url, data: data, closure: closure)
    }
    static func completeCalbit(_ id: String, status: Bool) {
        let url = calbitBaseURL + id + "/complete"
        let data = ["status": status]
        HttpUtil.put(url: url, data: data, closure: { _ in })
    }
    static func updateCalbit(_ id: String, data: [String: Any], closure: @escaping (Data) -> Void) {
        let url = calbitBaseURL + id
        HttpUtil.put(url: url, data: data, closure: closure)
    }
    static func deleteCalbit(_ id: String, closure: @escaping () -> Void) {
        let url = calbitBaseURL + id
        
        HttpUtil.delete(url: url, closure: closure)
    }

    static let calendarBaseURL = baseURL + "cal/"
    static func getCalendars(closure: @escaping ([CalbiticaCalendar]) -> Void) {
        let url = calendarBaseURL
        
        func httpFinishClosure(response: Data) {
            do {
                let calendars = try JSONDecoder().decode(CalendarsResponse.self, from: response)
                
                if let jwt = calendars.jwt {
                    AuthController.handleJWTClosure(jwt: jwt)
                }
                closure(calendars.data)
            } catch {
//                print("JSON error: \(error.localizedDescription)")
            }
        }
        HttpUtil.get(url: url, closure: httpFinishClosure)
    }
    static func changeCalSync(id: String, sync: Bool, closure: @escaping (Data) -> Void) {
        let syncStr = (sync) ? "true" : "false"
        let url = calendarBaseURL + "sync/" + id + "?sync=" + syncStr

        // Make the HTTP Request
        HttpUtil.get(url: url, closure: closure)
    }

    static let habiticaBaseURL = baseURL + "h/"
    static func getHProfile(closure: @escaping (Profile) -> Void) {
        let url = habiticaBaseURL + "profile"
        
        // When the response from API is returned,
        // run this function
        func httpFinishClosure(response: Data) {
            do {
                let decodedProfile = try JSONDecoder().decode(ProfileResponse.self, from: response)
                
                // handle jwt
                if let jwt = decodedProfile.jwt {
                    AuthController.handleJWTClosure(jwt: jwt)
                }
                
                closure(decodedProfile.data)
            } catch {
//                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        // Make the HTTP Request
        HttpUtil.get(url: url, closure: httpFinishClosure)
    }
    
    static func respondToQuest(accept: Bool, groupID: String, closure: @escaping (QuestInfo) -> Void) {
        let url = habiticaBaseURL + "quest"
        let data = ["accept" : accept, "groupID" : groupID] as [String : Any] // data to pass in POST
        
        // When the response from API is returned,
        // run this function
        func httpFinishClosure(response: Data) {
            do {
                let decodedQuest = try JSONDecoder().decode(QuestResponse.self, from: response)
                closure(decodedQuest.data)
            } catch {
//                 print("JSON error: \(error.localizedDescription)")
            }
        }

        // Make the HTTP Request
        HttpUtil.post(url: url, data: data, closure: httpFinishClosure)
    }
    
    static func toggleSleep(closure: @escaping (InnInfo) -> Void) {
        let url = habiticaBaseURL + "sleep"

        // When the response from API is returned,
        // run this function
        func httpFinishClosure(response: Data) {
            do {
                // Decode InnInfo
                let decodedInn = try JSONDecoder().decode(InnResponse.self, from: response)
                closure(decodedInn.data)
            } catch {
//                print("JSON error: \(error.localizedDescription)")
            }
        }

        // Make the HTTP Request
        HttpUtil.get(url: url, closure: httpFinishClosure)
    }

    static func changeHabiticaAPIKey(data: [String: String], closure: @escaping (String) -> Void) {
        let url = baseURL + "settings/habitica"

        // When the response from API is returned,
        // run this function
        func httpFinishClosure(response: Data) {
            do {
                let decodedUser = try JSONDecoder().decode(User.self, from: response)
                closure(decodedUser.jwt)
            } catch {
//                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        // Make the HTTP Request
        HttpUtil.post(url: url, data: data, closure: httpFinishClosure)
    }
}
