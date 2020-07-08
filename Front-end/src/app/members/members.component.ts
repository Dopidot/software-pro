import { Component, OnInit, TemplateRef } from '@angular/core';
import { MENU_ITEMS } from '../menu/menu';
import { LocalDataSource } from 'ng2-smart-table';
import { SmartTableData } from '../@core/data/smart-table';
import { NbDialogService } from '@nebular/theme';

@Component({
    selector: 'ngx-members',
    templateUrl: './members.component.html',
    styleUrls: ['./members.component.scss']
})
export class MembersComponent implements OnInit {

    menu = MENU_ITEMS;
    currentUser = {};
    success = 'success';
    danger = 'danger';

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
            },
            connection: {
                title: 'Dernière connexion',
                type: 'string',
            },
        },
    };

    source: LocalDataSource = new LocalDataSource();

    constructor(
        private service: SmartTableData,
        private dialogService: NbDialogService,
        ) {
        /*const data = this.service.getData();
        console.log(data);
        this.source.load(data);*/
        const data = [
            {
                pseudo: 'Christophil',
                lastName: 'Philemon',
                firstName: 'Christopher',
                email: 'chris.philemon@gmail.com',
                connection: '06:50 le 02/06/2020',
                picture: 'assets/images/alan.png'
            },
            {
                pseudo: 'Juanito',
                lastName: 'Deyehe',
                firstName: 'Jean',
                email: 'jean.deyehe@gmail.com',
                connection: '18:30 le 28/05/2020',
                picture: 'assets/images/jack.png'
            },
            {
                pseudo: 'Bigyeezy',
                lastName: 'Tako',
                firstName: 'Guillaume',
                email: 'guillaume.tako@hotmail.fr',
                connection: '22:51 le 25/05/2020',
                picture: 'assets/images/nick.png'
            },
        ];

        this.source.load(data);
    }

    ngOnInit(): void {
    }

    openPopup(event, dialog: TemplateRef<any>) {
        this.currentUser = event.data;

        this.dialogService.open(
          dialog
        );
      }

}
