/**
 * Service : CommonService
 * @author Mickael MOREIRA
 * @version 1.0.0 
 */

import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from "rxjs/index";
import { ApiConfig } from '../../../src/api.config';

@Injectable()
export class CommonService {

    apiConfig: ApiConfig = new ApiConfig();
    baseUrlEvent: string;
    baseUrlNews: string;

    constructor(private http: HttpClient) {
        this.baseUrlEvent = this.apiConfig.adminApiUrl + '/api/events';
        this.baseUrlNews = this.apiConfig.adminApiUrl + '/api/newsletters';
     }

    /* EVENTS */
    getEvents(): Observable<any> {
        return this.http.get<any>(this.baseUrlEvent);
    }

    createEvent(event: any, file: any): Observable<any> {
        let form = this.createFormData(event, 'eventImage', file);

        return this.http.post<any>(this.baseUrlEvent, form);
    }

    updateEvent(id: number, event: any, file: any): Observable<any> {
        let form = this.createFormData(event, 'eventImage', file);

        return this.http.put<any>(this.baseUrlEvent + '/' + id, form);
    }

    deleteEvent(id: number): Observable<any> {
        return this.http.delete<any>(this.baseUrlEvent + '/' + id);
    }

    /* NEWS */
    getNews(): Observable<any> {
        return this.http.get<any>(this.baseUrlNews);
    }

    createNews(news: any, file: any): Observable<any> {
        let form = this.createFormData(news, 'newsletterImage', file);

        return this.http.post<any>(this.baseUrlNews, form);
    }

    updateNews(id: number, news: any, file: any): Observable<any> {
        let form = this.createFormData(news, 'newsletterImage', file);

        return this.http.put<any>(this.baseUrlNews + '/' + id, form);
    }

    deleteNews(id: number): Observable<any> {
        return this.http.delete<any>(this.baseUrlNews + '/' + id);
    }

    /* COMMON */
    getPicture(name: string): string {
        return this.apiConfig.adminApiUrl + '/' + name;
    }

    isServerOnline(baseUrl): Observable<any> {
        return this.http.get<any>(baseUrl);
    }

    createFormData(obj: any, imageAttribut: string, file: any): FormData {
        let formData = new FormData(); 
        Object.keys(obj).forEach(key => formData.append(key, obj[key]));

        if (file)
        {
            formData.set(imageAttribut, file, file.name);
        }

        return formData;
    }
}