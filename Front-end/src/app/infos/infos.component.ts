import { Component, OnInit } from '@angular/core';
import { MENU_ITEMS } from '../menu/menu';
import { StatusService } from '../services/status.service';
import { UserService } from '../services/user.service';

@Component({
    selector: 'ngx-infos',
    templateUrl: './infos.component.html',
    styleUrls: ['./infos.component.scss']
})
export class InfosComponent implements OnInit {

    menu = MENU_ITEMS;
    data: any;

    private fitislyAdminAPI = 'http://localhost:4000';
    private fitislyAdminDB = 'http://localhost:4000/api/users/7';

    constructor(
        private statusService: StatusService,
        private userService: UserService,
    ) { }

    ngOnInit(): void {
        this.loadStatuts();
    }

    loadStatuts(): void {
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
        this.getStatus(3, this.fitislyAdminDB);
    }

    getStatus(index, baseUrl: string): void {

        this.statusService.isOnline(baseUrl).subscribe(data => {
            this.data[index].status = true;
        }, error => {
            if (error.status >= 200 && error.status < 500)
            {
                this.data[index].status = true;
            }
        });
    }

}
