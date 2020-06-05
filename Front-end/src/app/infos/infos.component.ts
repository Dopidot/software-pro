import { Component, OnInit } from '@angular/core';
import { MENU_ITEMS } from '../menu/menu';

@Component({
    selector: 'ngx-infos',
    templateUrl: './infos.component.html',
    styleUrls: ['./infos.component.scss']
})
export class InfosComponent implements OnInit {

    menu = MENU_ITEMS;
    data: any;

    constructor() { }

    ngOnInit(): void {
        this.loadStatuts();
    }

    loadStatuts(): void {
        this.data = [
            {
                name: 'Fitisly Admin : API',
                status: true,
                icon: 'fa-server',
            },
            {
                name: 'Fitisly : API',
                status: false,
                icon: 'fa-server',
            },
            {
                name: 'Fitisly : Database',
                status: true,
                icon: 'fa-database',
            },
            {
                name: 'Fitisly Admin : Database',
                status: true,
                icon: 'fa-database',
            },
        ]
    }

}
