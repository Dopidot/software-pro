import { Component, OnInit, TemplateRef } from '@angular/core';
import { MENU_ITEMS } from '../menu/menu';
import { LocalDataSource } from 'ng2-smart-table';

import { NbDialogService } from '@nebular/theme';

import { ProgramService } from '../services/program.service';
import { Program } from '../models/program.model';

@Component({
    selector: 'ngx-programs',
    templateUrl: './programs.component.html',
    styleUrls: ['./programs.component.scss']
})
export class ProgramsComponent implements OnInit {

    menu = MENU_ITEMS;
    currentProgram: Program;
    danger = 'danger';
    success = 'success';
    source: LocalDataSource = new LocalDataSource();
    errorMessage: string;
    popupType: number = 0;

    settings = {
        actions: {
            custom: [
                {
                    name: 'show',
                    title: '<i class="far fa-eye fa-xs"></i>',
                },
                {
                    name: 'edit',
                    title: '<i class="far fa-edit fa-xs"></i>',
                },
                {
                    name: 'delete',
                    title: '<i class="far fa-trash-alt fa-xs"></i>',
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
        private dialogService: NbDialogService,
        private programService: ProgramService,
    ) {
        this.loadPrograms();
    }

    ngOnInit(): void {
    }

    loadPrograms(): void {
        this.programService.getPrograms().subscribe(data => {

            this.source.load(data);
        }, error => {
            this.errorMessage = 'Une erreur est survenue lors du chargement des données.';
        });        
    }

    selectAction(event, dialog: TemplateRef<any>, dialogDelete: TemplateRef<any>): void {
        this.currentProgram = event.data;

        switch (event.action) {
            case 'show': {
                this.popupType = 0;
                this.openPopup(dialog);
                break;
            }
            case 'edit': {
                this.popupType = 1;
                this.openPopup(dialog);
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

    addProgram(): void {
        this.programService.createProgram(this.currentProgram).subscribe(data => {
            this.loadPrograms();
        }, error => {
            this.errorMessage = 'Une erreur est survenue, veuillez vérifier les informations saisies.';
        });
    }

    editProgram(): void {
        this.programService.updateProgram(this.currentProgram['id'], this.currentProgram).subscribe(data => {
            this.loadPrograms();
        }, error => {
            this.errorMessage = 'Une erreur est survenue, veuillez vérifier les informations saisies.';
        });
    }

    confirmDelete(): void {
        console.log(this.currentProgram);

        this.programService.deleteProgram(this.currentProgram['id']).subscribe(data => {
            this.loadPrograms();
        }, error => {
            this.errorMessage = 'Une erreur est survenue, veuillez réessayer ultérieurement.';
        });
    }

}
