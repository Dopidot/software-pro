import { Component, OnInit } from '@angular/core';
import { MENU_ITEMS } from '../menu/menu';

@Component({
    selector: 'ngx-notifications',
    templateUrl: './notifications.component.html',
    styleUrls: ['./notifications.component.scss']
})
export class NotificationsComponent implements OnInit {

    menu = MENU_ITEMS;
    notifications: any;
    currentNotif: any;
    tiny = 'tiny';

    constructor() { }

    ngOnInit(): void {
        this.loadNotifications();
    }

    selectNotif(notif): void {
        this.currentNotif = notif;
    }

    loadNotifications(): void {
        this.notifications = [
            {
                id: 1,
                message: 'Vous avez reçu un nouvelle message de le part de Christophil.',
                icon: 'fa-comment',
            },
            {
                id: 2,
                message: 'Il y a du nouveau dans votre fil d\'actualité !',
                icon: 'fa-newspaper',
            },
            {
                id: 3,
                message: 'Vous avez reçu un nouvelle message de le part de Christophil.',
                icon: 'fa-comment',
            },
            {
                id: 4,
                message: 'Vous avez reçu un nouvelle message de le part de Christophil.',
                icon: 'fa-comment',
            },
            {
                id: 5,
                message: 'Vous avez reçu un nouvelle message de le part de Christophil.',
                icon: 'fa-comment',
            },
            {
                id: 6,
                message: 'Vous avez reçu un nouvelle message de le part de Christophil.',
                icon: 'fa-comment',
            },
        ];
    }

}
