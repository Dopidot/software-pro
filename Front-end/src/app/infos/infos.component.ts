/**
 * Component : InfosComponent
 * @author Mickael MOREIRA
 * @version 1.0.0 
 */

import { Component, OnInit } from '@angular/core';
import { MenuService } from '../services/menu.service';
import { CommonService } from '../services/common.service';
import { UserService } from '../services/user.service';

@Component({
    selector: 'ngx-infos',
    templateUrl: './infos.component.html',
    styleUrls: ['./infos.component.scss']
})
export class InfosComponent implements OnInit {

    menu = [];
    data: any;
    userInfo = localStorage.getItem('userInfo') != null ? JSON.parse(localStorage.getItem('userInfo')) : '';
    fitislyAdminAPI;
    fitislyAdminDB;
    fitislyAPI;
    fitislyDB;

    constructor(
        private userService: UserService,
        private menuService: MenuService,
        private commonService: CommonService,
    ) { }

    ngOnInit(): void {
        this.menu = this.menuService.getMenu();
        this.loadStatuts();
    }

    initUrl(): void {
        this.fitislyAdminAPI = this.commonService.apiConfig.adminApiUrl;
        this.fitislyAdminDB = this.userService.baseUrlUser + '/' + this.userInfo['id'];
        this.fitislyAPI = this.commonService.apiConfig.fitislyApiUrl;
        this.fitislyDB = this.commonService.apiConfig.fitislyApiUrl + '/get-age-statistics';
    }

    loadStatuts(): void {
        this.initUrl();

        this.data = [
            {
                name: 'Fitisly Admin : API',
                status: false,
                icon: 'fa-server',
            },
            {
                name: 'Fitisly : API',
                status: false,
                icon: 'fa-server',
            },
            {
                name: 'Fitisly : Database',
                status: false,
                icon: 'fa-database',
            },
            {
                name: 'Fitisly Admin : Database',
                status: false,
                icon: 'fa-database',
            },
        ];

        this.getStatus(0, this.fitislyAdminAPI);
        this.getStatus(1, this.fitislyAPI);
        this.getStatus(2, this.fitislyDB);
        this.getStatus(3, this.fitislyAdminDB);
    }

    getStatus(index, baseUrl: string): void {

        this.commonService.isServerOnline(baseUrl).subscribe(data => {
            this.data[index].status = true;
        }, error => {
            if (error.status >= 200 && error.status < 500)
            {
                this.data[index].status = true;
            }
        });
    }

}
