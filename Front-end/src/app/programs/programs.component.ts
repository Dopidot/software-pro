import { Component, OnInit, TemplateRef } from '@angular/core';
import { MENU_ITEMS } from '../menu/menu';
import { LocalDataSource } from 'ng2-smart-table';

import { SmartTableData } from '../@core/data/smart-table';
import { NbDialogService } from '@nebular/theme';

@Component({
    selector: 'ngx-programs',
    templateUrl: './programs.component.html',
    styleUrls: ['./programs.component.scss']
})
export class ProgramsComponent implements OnInit {

    menu = MENU_ITEMS;
    currentProgram: any;
    danger = 'danger';
    success = 'success';
    source: LocalDataSource = new LocalDataSource();

    settings = {
        actions: {
            custom: [
                {
                    name: 'show',
                    title: '<i class="far fa-eye fa-xs" title="Show more details"></i>',
                },
                {
                    name: 'edit',
                    title: '<i class="far fa-edit fa-xs" title="Edit informations"></i>',
                },
                {
                    name: 'delete',
                    title: '<i class="far fa-trash-alt fa-xs" title="Remove item"></i>',
                },
            ],
            add: false,
            edit: false,
            delete: false,
        },
        columns: {
            name: {
                title: 'Name',
                type: 'string',
            },
            description: {
                title: 'Description',
                type: 'string',
            }
        },
    };

    constructor(
        private service: SmartTableData,
        private dialogService: NbDialogService,
    ) {

        this.loadPrograms();
    }

    ngOnInit(): void {
    }

    loadPrograms(): void {
        const data = [
        {
            id: 1,
            name: 'Remise en forme',
            description: 'Besoin de se remettre au sport ?'
        },
        {
            id: 2,
            name: 'Amélioration du haut du corps',
            description: 'Renforcement musculaire'
        },
        ];

        this.source.load(data);
    }

    selectAction(event, dialogAdd: TemplateRef<any>, dialogDelete: TemplateRef<any>): void {
        this.currentProgram = event.data;

        switch (event.action) {
            case 'show': {

                break;
            }
            case 'edit': {
                this.openPopup(dialogAdd);
                break;
            }
            case 'delete': {
                this.openPopup(dialogDelete);
                break;
            }
        }
    }

    openPopup(dialog: TemplateRef<any>): void {
        this.dialogService.open(
            dialog
        );
    }

    confirmDelete(): void {
        console.log('Program sucessfully deleted !');
    }

}
