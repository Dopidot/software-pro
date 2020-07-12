import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Program } from "../models/program.model";
import { Observable } from "rxjs/index";

@Injectable()
export class ProgramService {

    baseUrl: string = 'http://localhost:4000/api/programs';

    constructor(private http: HttpClient) { }

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

        if (file)
        {
            formData.set(imageAttribut, file, file.name);
        }

        return formData;
    }
}