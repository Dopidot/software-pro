import { Component, OnInit, TemplateRef } from '@angular/core';
import { MenuService } from '../services/menu.service';
import { LocalDataSource } from 'ng2-smart-table';
import { SmartTableData } from '../@core/data/smart-table';
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

    settings = {
        actions: {
            custom: [
                {
                    name: 'show',
                    title: '<i class="far fa-address-card fa-xs" title="Show more details"></i>',
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

    source: LocalDataSource = new LocalDataSource();

    constructor(
        private service: SmartTableData,
        private dialogService: NbDialogService,
        private fitisly: FitislyService,
        private menuService: MenuService,
        ) {

        this.loadUsers();
    }

    ngOnInit(): void {
        this.menu = this.menuService.getMenu();
    }

    loadUsers(): void {
        this.fitisly.getUsers().subscribe(data => {
            data = data['body']['list'];
            
            data.forEach(element => {
                this.fitisly.getUserInfo(element['account_id']).subscribe(info => {
                    let myInfo = info['body']['user_profile'];

                    this.users.push({
                        pseudo: this.capitalize(myInfo['pseudonyme']),
                        lastName: this.capitalize(myInfo['last_name']),
                        firstName: this.capitalize(myInfo['first_name']),
                        email: this.capitalize(myInfo['mail']),
                        picture: 'http://51.178.16.171:8150/get-user-profile-picture/' + myInfo['profile_picture']
                    });
                    //console.log(this.users);
                    this.source.load(this.users);
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
