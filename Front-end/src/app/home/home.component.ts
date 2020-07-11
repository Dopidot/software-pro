import { Component, OnInit } from '@angular/core';
import { DayCellComponent } from '../pages/extra-components/calendar/day-cell/day-cell.component';
import { FitislyService } from '../services/fitisly.service';
import { MenuService } from '../services/menu.service';

@Component({
    selector: 'ngx-home',
    templateUrl: './home.component.html',
    styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {

    data: any;
    options: any;
    themeSubscription: any;
    selectedEvent: any;
    events: any;
    menu = [];
    users = [];
    date = new Date();
    dayCellComponent = DayCellComponent;

    constructor(
        private fitisly: FitislyService,
        private menuService: MenuService,
        ) { }

    ngOnInit(): void {
        this.menu = this.menuService.getMenu();
        this.loadUsers();
        this.loadEvents();
    }

    loadUsers(): void {
        this.fitisly.getUsers().subscribe(data => {
            let users = data['body']['list'];

            let lastUsers = users.slice(1).slice(-10);

            lastUsers.forEach(element => {
                this.fitisly.getUserInfo(element['account_id']).subscribe(info => {
                    info = info['body']['user_profile'];

                    this.users.push({
                        name: this.capitalize(info['pseudonyme']),
                        title: this.capitalize(info['first_name']),
                        picture: this.fitisly.getPicture(info['profile_picture'])
                    });
                    
                });
            });
        });
    }

    capitalize(s: string): string {
        return s.charAt(0).toUpperCase() + s.slice(1);
    }

    loadEvents(): void {
        this.events = [new Date(2020, 5, 25), new Date(2020, 5, 9)];

        this.dayCellComponent.prototype.loadEvents(this.events);
    }

    showEvent(event: any): void {
        this.selectedEvent = null;
        let html = event['target'];

        if (html['id'] === 'flagEvent')
        {
            this.selectedEvent = 'Seance entrainement gratuit du 28 au 30 Juin !';
        }
    }
}