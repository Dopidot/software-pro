import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from "rxjs/index";

@Injectable()
export class CommonService {

    baseUrl: string = 'http://localhost:4000';
    baseUrlEvent: string = 'http://localhost:4000/api/events';
    baseUrlNews: string = 'http://localhost:4000/api/newsletters';


    constructor(private http: HttpClient) { }


    /* EVENTS */
    getEvents(): Observable<any> {
        return this.http.get<any>(this.baseUrlEvent);
    }

    createEvent(event: any): Observable<any> {
        return this.http.post<any>(this.baseUrlEvent, event);
    }

    updateEvent(id: number, event: any): Observable<any> {
        return this.http.put<any>(this.baseUrlEvent + '/' + id, event);
    }

    deleteEvent(id: number): Observable<any> {
        return this.http.delete<any>(this.baseUrlEvent + '/' + id);
    }

    /* NEWS */
    getNews(): Observable<any> {
        return this.http.get<any>(this.baseUrlNews);
    }

    createNews(news: any): Observable<any> {
        return this.http.post<any>(this.baseUrlNews, news);
    }

    updateNews(id: number, news: any): Observable<any> {
        return this.http.put<any>(this.baseUrlNews + '/' + id, news);
    }

    deleteNews(id: number): Observable<any> {
        return this.http.delete<any>(this.baseUrlNews + '/' + id);
    }

    /* COMMON */
    getPicture(name: string): string {
        return this.baseUrl + '/' + name;
    }

    isServerOnline(baseUrl): Observable<any> {
        return this.http.get<any>(baseUrl);
    }
}