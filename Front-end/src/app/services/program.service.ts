/**
 * Service : ProgramService
 * @author Mickael MOREIRA
 * @version 1.0.0 
 */

import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from "rxjs/index";
import { ApiConfig } from '../../../src/api.config';

@Injectable()
export class ProgramService {

    apiConfig: ApiConfig = new ApiConfig();
    baseUrl: string;

    constructor(private http: HttpClient) {
        this.baseUrl = this.apiConfig.adminApiUrl + '/api/programs';
    }

    getPrograms(): Observable<any> {
        return this.http.get<any>(this.baseUrl);
    }

    createProgram(program: any, file: any): Observable<any> {
        let form = this.createFormData(program, 'programImage', file);

        return this.http.post<any>(this.baseUrl, form);
    }

    updateProgram(id: number, program: any, file: any): Observable<any> {
        let form = this.createFormData(program, 'programImage', file);

        return this.http.put<any>(this.baseUrl + '/' + id, form);
    }

    deleteProgram(id: number): Observable<any> {
        return this.http.delete<any>(this.baseUrl + '/' + id);
    }

    createFormData(obj: any, imageAttribut: string, file: any): FormData {
        let formData = new FormData();
        Object.keys(obj).forEach(key => formData.append(key, obj[key]));

        if (file) {
            formData.set(imageAttribut, file, file.name);
        }

        return formData;
    }
}