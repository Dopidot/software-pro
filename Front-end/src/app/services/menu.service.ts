/**
 * Service : MenuService
 * @author Mickael MOREIRA
 * @version 1.0.0 
 */

import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { TranslateService } from '@ngx-translate/core';

@Injectable()
export class MenuService {

    constructor(
        private http: HttpClient,
        private translate: TranslateService,
        ) {}

    private addMenuItem(title: string, icon: string, link: string, home: boolean = false): any {
        let obj = {};

        title !== undefined ? obj['title'] = title : '';
        icon !== undefined ? obj['icon'] = icon : '';
        link !== undefined ? obj['link'] = link : '';
        home !== false ? obj['home'] = home : '';

        return obj;
    }

    private addSubMenuItem(obj: any, title: string, link: string): any {
        if (obj === undefined) {
            return;
        }

        if (obj['children'] === undefined) {
            obj['children'] = [];
        }

        obj['children'].push({
            title: title,
            link: link
        });

        return obj;
    }

    getMenu(): any {
        let menu = [];

        this.getMenuTitles().subscribe(item => {
            menu.push(this.addMenuItem(item['MENU_HOME'], 'home-outline', '/home', true));
            menu.push(this.addMenuItem(item['MENU_MEMBERS'], 'people-outline', '/members'));

            let tempMenu = this.addMenuItem(item['MENU_COACHING'], 'trending-up-outline', undefined);
            tempMenu = this.addSubMenuItem(tempMenu, item['MENU_COACH'], '/coachs');
            tempMenu = this.addSubMenuItem(tempMenu, item['MENU_PROGRAMS'], '/programs');
            tempMenu = this.addSubMenuItem(tempMenu, item['MENU_EXERCISES'], '/exercises');
            menu.push(tempMenu);

            tempMenu = this.addMenuItem(item['MENU_COMMUNITY'], 'message-square-outline', undefined);
            tempMenu = this.addSubMenuItem(tempMenu, item['MENU_NEWS'], '/news');
            tempMenu = this.addSubMenuItem(tempMenu, item['MENU_INACTIVE'], '/inactivity');
            menu.push(tempMenu);

            menu.push(this.addMenuItem(item['MENU_EVENTS'], 'calendar-outline', '/events'));
            menu.push(this.addMenuItem(item['MENU_INFOS'], 'info-outline', '/infos'));
        });

        return menu;
    }

    getMenuTitles(): any {
        let menuItems = ['MENU_HOME', 'MENU_MEMBERS', 'MENU_COACHING', 'MENU_COACH', 'MENU_PROGRAMS', 'MENU_EXERCISES', 
            'MENU_COMMUNITY', 'MENU_NEWS', 'MENU_INACTIVE', 'MENU_EVENTS', 'MENU_INFOS'];

        return this.translate.get(menuItems);
    }

}