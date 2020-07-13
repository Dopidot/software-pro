/**
 * Component : MembersComponent
 * @author Mickael MOREIRA
 * @version 1.0.0 
 */

import { Component, OnInit, TemplateRef } from '@angular/core';
import { MenuService } from '../services/menu.service';
import { LocalDataSource } from 'ng2-smart-table';
import { NbDialogService } from '@nebular/theme';
import { FitislyService } from '../services/fitisly.service';
import { TranslateService } from '@ngx-translate/core';

@Component({
    selector: 'ngx-members',
    templateUrl: './members.component.html',
    styleUrls: ['./members.component.scss']
})
export class MembersComponent implements OnInit {

    menu = [];
    currentUser = {};
    success = 'success';
    danger = 'danger';
    users: { pseudo: string, lastName: string, firstName: string, email: string, picture: string }[] = [];
    source: LocalDataSource = new LocalDataSource();
    settings = this.getTableSettings();
    titlePseudonym = '';
    titleLastName = '';
    titleFirstName = '';
    titleEmail = '';

    constructor(
        private dialogService: NbDialogService,
        private fitisly: FitislyService,
        private menuService: MenuService,
        private translate: TranslateService,
    ) { }

    ngOnInit(): void {
        this.menu = this.menuService.getMenu();
        this.loadUsers();

        this.translate.get(['MEMBERS_PSEUDONYM', 'MEMBERS_LAST_NAME', 'MEMBERS_FIRST_NAME', 'MEMBERS_EMAIL']).subscribe((res: string) => {
            this.titlePseudonym = res['MEMBERS_PSEUDONYM'];
            this.titleLastName = res['MEMBERS_LAST_NAME'];
            this.titleFirstName = res['MEMBERS_FIRST_NAME'];
            this.titleEmail = res['MEMBERS_EMAIL'];

            this.settings = this.getTableSettings();
        });
    }

    loadUsers(): void {
        this.fitisly.getUsers().subscribe(data => {
            data = data['body']['list'];
            let index = 0;

            data.forEach(element => {
                this.fitisly.getUserInfo(element['account_id']).subscribe(info => {
                    let myInfo = info['body']['user_profile'];

                    this.users.push({
                        pseudo: this.capitalize(myInfo['pseudonyme']),
                        lastName: this.capitalize(myInfo['last_name']),
                        firstName: this.capitalize(myInfo['first_name']),
                        email: this.capitalize(myInfo['mail']),
                        picture: this.fitisly.getPicture(myInfo['profile_picture'])
                    });

                    index++;

                    if (index % 10 === 0 || data.length === index) {
                        this.source.load(this.users);
                    }

                }, error => {
                });
            });

        }, error => {
        });
    }

    capitalize(s: string): string {
        return s.charAt(0).toUpperCase() + s.slice(1);
    }

    openPopup(event, dialog: TemplateRef<any>) {
        this.currentUser = event.data;

        this.dialogService.open(
            dialog
        );
    }

    getTableSettings(): any {
        return {
            actions: {
                custom: [
                    {
                        name: 'show',
                        title: '<i class="far fa-address-card fa-xs"></i>',
                    },
                ],
                add: false,
                edit: false,
                delete: false,
            },
            columns: {
                pseudo: {
                    title: this.titlePseudonym,
                    type: 'string',
                },
                lastName: {
                    title: this.titleLastName,
                    type: 'string',
                },
                firstName: {
                    title: this.titleFirstName,
                    type: 'string',
                },
                email: {
                    title: this.titleEmail,
                    type: 'string',
                }
            },
        };
    }

}
