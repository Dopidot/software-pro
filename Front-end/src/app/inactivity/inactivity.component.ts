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
    currentProgram = {};
    currentUser = {};
    success = 'success';

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

    loadProgram(user: any): void {
        
    }

    loadSuggestion(user: any): void {
        this.currentUser = user;


    }

    startSuggestion(): void {
        this.commonService.getSuggestionByProfile(this.currentUser['weight'], 
            this.currentUser['height'], this.currentUser['age']).subscribe(data => {
            console.log(data);

            this.fitislyService.getProgramInfo(data['value']).subscribe(data => {
                let temp = data['body']['program'];
                this.currentProgram= temp;
            });

            /*this.commonService.createSuggestion().subscribe(data => {

            });*/
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
