/**
 * Service : UserService
 * @author Mickael MOREIRA
 * @version 1.0.0 
 */

import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { User } from "../models/user.model";
import { Observable } from "rxjs/index";
import { ApiConfig } from '../../../src/api.config';

@Injectable()
export class UserService {

    apiConfig: ApiConfig = new ApiConfig();
    baseUrlUser: string;
    baseUrlCoach: string;

    constructor(private http: HttpClient) {
        this.baseUrlUser = this.apiConfig.adminApiUrl + '/api/users';
        this.baseUrlCoach = this.apiConfig.adminApiUrl + '/api/coachs';
     }

    connectUser(user: User): Observable<any> {
        return this.http.post<any>(this.baseUrlUser + '/login', user);
    }

    getUserById(id: number): Observable<User> {
        return this.http.get<User>(this.baseUrlUser + '/' + id);
    }

    getCoachHighlighted(): Observable<any> {
        return this.http.get<any>(this.baseUrlCoach);
    }

    createCoachHighlighted(id: number): Observable<any> {
        return this.http.post<any>(this.baseUrlCoach, { 'coachId': id, 'isHighlighted': true });
    }

    deleteCoachHighlighted(id: string): Observable<any> {
        return this.http.delete<any>(this.baseUrlCoach + '/' + id);
    }
}