/**
 * Component : InactivityComponent
 * @author Mickael MOREIRA
 * @version 1.0.0 
 */

import { Component, OnInit } from '@angular/core';
import { MenuService } from '../services/menu.service';
import { FitislyService } from '../services/fitisly.service';
import { CommonService } from '../services/common.service';

@Component({
    selector: 'ngx-inactivity',
    templateUrl: './inactivity.component.html',
    styleUrls: ['./inactivity.component.scss']
})
export class InactivityComponent implements OnInit {

    menu = [];
    users = [];
    suggestions = [];
    currentProgram: any;
    currentUser: any;
    success = 'success';
    isLoading = false;
    imagePath: string;

    constructor(
        private menuService: MenuService,
        private fitislyService: FitislyService,
        private commonService: CommonService,
    ) { }

    ngOnInit(): void {
        this.menu = this.menuService.getMenu();
        this.loadUsers();
    }

    loadUsers(): void {
        this.fitislyService.getUsers().subscribe(data => {
            let temp = data['body']['list'];

            temp.forEach(element => {
                this.fitislyService.getUserInfo(element['account_id']).subscribe(data2 => {
                    let temp2 = data2['body']['user_profile'];

                    let diffDays = Math.floor(( new Date().getTime() - Date.parse(temp2['last_connection_date']) ) / 86400000); 

                    if (diffDays >= 200)
                    {
                        temp2['picture'] = this.fitislyService.getPicture(temp2['profile_picture']);
                        temp2['name'] = this.capitalize(temp2['pseudonyme']);
                        this.users.push(temp2);
                    }
                });
            });
        });
    }

    loadSuggestions(user: any): void {
        if (!this.isLoading)
        {
            this.currentUser = user;
            this.currentProgram = null;
            
            this.commonService.getSuggestions().subscribe(data => {
                this.suggestions = data;
                data = data.sort((a,b) => b['id'] - a['id']);
    
                let value = data.filter(x => x['iduser'] === user['account_id'])[0];
    
                if (value)
                {
                    this.getProgramInfo(value['idprogram']);
                }
            });
        }
    }

    startSuggestion(): void {
        this.isLoading = true;

        let timeDiff = Math.abs(Date.now() - new Date(this.currentUser['birth_date']).getTime());
        let age = Math.floor((timeDiff / (1000 * 3600 * 24))/365.25);

        this.commonService.getSuggestionByProfile(this.currentUser['height'], this.currentUser['weight'], age).subscribe(data => {
            this.isLoading = false;
            let idProgram = data['value'];

            this.getProgramInfo(idProgram);
            this.createSuggestion(idProgram);
            
        }, error => {
            this.isLoading = false;
        });
    }

    getProgramInfo(idProgram: string): void {
        this.fitislyService.getProgramInfo(idProgram).subscribe(data => {
            let temp = data['body']['program'];

            temp['name'] = this.capitalize(temp['name']);
            this.currentProgram = temp;
            this.imagePath = this.fitislyService.getProgramPicture(temp['picture']);
        });
    }

    createSuggestion(idProgram: string): void {
        let suggestion = {
            idProgram: idProgram,
            idUser: this.currentUser['account_id']
        };

        this.commonService.createSuggestion(suggestion).subscribe(data => {
            this.loadSuggestions(this.currentUser);
        });
    }

    /**
     * Capitalize the first letter for a string
     * @input s : string
     * @output string
     */
    capitalize(s: string): string {
        return s.charAt(0).toUpperCase() + s.slice(1);
    }

}
