import { Component, OnInit } from '@angular/core';
import { MenuService } from '../services/menu.service';

@Component({
    selector: 'ngx-news',
    templateUrl: './news.component.html',
    styleUrls: ['./news.component.scss']
})
export class NewsComponent implements OnInit {

    menu = [];
    notifications: any;
    currentNotif: any;
    tiny = 'tiny';

    constructor(
        private menuService: MenuService,
    ) { }

    ngOnInit(): void {
        this.menu = this.menuService.getMenu();
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

    removeNotification(notification: any): void {

        let index = this.notifications.findIndex(x => x.id === notification.id);

        if (index !== -1)
        {
            this.notifications.splice(index, 1);
        }
    }

}
