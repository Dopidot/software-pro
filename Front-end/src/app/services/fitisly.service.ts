/**
 * Service : FitislyService
 * @author Mickael MOREIRA
 * @version 1.0.0 
 */

import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from "rxjs/index";
import { ApiConfig } from '../../../src/api.config';

@Injectable()
export class FitislyService {

    apiConfig: ApiConfig = new ApiConfig();
    baseUrl: string;

    constructor(private http: HttpClient) {
        this.baseUrl = this.apiConfig.fitislyApiUrl + '/';
     }

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

    getProgramInfo(id: string): Observable<any> {
        return this.http.get<any>(this.baseUrl + 'get-program-by-id/' + id);
    }

    getProgramPicture(pictureId: string): string {
        return this.baseUrl + 'get-program-picture-file/' + pictureId;
    }
}