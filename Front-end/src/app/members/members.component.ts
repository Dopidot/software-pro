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
    users: { pseudo: string, lastName: string, firstName: string, email: string, picture : string }[] = [];
    source: LocalDataSource = new LocalDataSource();

    settings = {
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
                title: 'Pseudonyme',
                type: 'string',
            },
            lastName: {
                title: 'Nom',
                type: 'string',
            },
            firstName: {
                title: 'Prénom',
                type: 'string',
            },
            email: {
                title: 'Email',
                type: 'string',
            }
        },
    };

    constructor(
        private dialogService: NbDialogService,
        private fitisly: FitislyService,
        private menuService: MenuService,
        ) { }

    ngOnInit(): void {
        this.menu = this.menuService.getMenu();
        this.loadUsers();
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

                    if (index % 10 === 0 || data.length === index)
                    {
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

}
