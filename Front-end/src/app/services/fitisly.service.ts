/**
 * Service : FitislyService
 * @author Mickael MOREIRA
 * @version 1.0.0 
 */

import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from "rxjs/index";

@Injectable()
export class FitislyService {

    baseUrl: string = 'http://51.178.16.171:8150/';

    constructor(private http: HttpClient) { }

    getUsers(): Observable<any> {
        return this.http.get<any>(this.baseUrl + 'get-users');
    }

    getUserInfo(id: number): Observable<any> {
        return this.http.get<any>(this.baseUrl + 'get-user-profile/id/' + id);
    }

    getCoachs(): Observable<any> {
        return this.http.get<any>(this.baseUrl + 'get-all-coachs');
    }

    getPicture(pictureId: string): string {
        return this.baseUrl + 'get-user-profile-picture/' + pictureId;
    }

    getConnectionByGender(date: string): Observable<any> {
        return this.http.get<any>(this.baseUrl + 'get-connections-by-gender/' + date);
    }

    getUserAgeStats(): Observable<any> {
        return this.http.get<any>(this.baseUrl + 'get-age-statistics/');
    }
}