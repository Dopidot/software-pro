import { Component, OnInit, TemplateRef } from '@angular/core';
import { MenuService } from '../services/menu.service';
import { LocalDataSource } from 'ng2-smart-table';

import { NbDialogService } from '@nebular/theme';

import { ExerciseService } from '../services/exercise.service';
import { Exercise } from '../models/exercise.model';

@Component({
    selector: 'ngx-exercises',
    templateUrl: './exercises.component.html',
    styleUrls: ['./exercises.component.scss']
})
export class ExercisesComponent implements OnInit {

    menu = [];
    currentExercise: Exercise = new Exercise();
    danger = 'danger';
    success = 'success';
    source: LocalDataSource = new LocalDataSource();
    errorMessage: string;
    popupType: number = 0;
    imageBase64: string;
    imagePath: string;
    imageFile: string;

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
            },
        },
    };

    constructor(
        private dialogService: NbDialogService,
        private exerciseService: ExerciseService,
        private menuSerivce: MenuService,
    ) { }

    ngOnInit(): void {
        this.menu = this.menuSerivce.getMenu();
        this.loadExercise();
    }

    loadExercise(): void {
        this.exerciseService.getExercises().subscribe(data => {
            this.source.load(data);
        });
    }

    selectAction(event, dialog: TemplateRef<any>, dialogDelete: TemplateRef<any>): void {
        this.getExercise(event.data['id']);

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

    getExercise(id: number): void {
        this.exerciseService.getExerciseById(id).subscribe(data => {
            this.currentExercise = data;
            this.imagePath = null;
            this.imageBase64 = null;
            this.imageFile = null;

            if (data['exerciseimage']) {
                this.imagePath = this.exerciseService.getPicture(data['exerciseimage']);
            }
        }, error => {
            this.errorMessage = 'Une erreur est survenue, veuillez vérifier les informations saisies.';
        });
    }

    addExercise(): void {
        this.exerciseService.createExercise(this.currentExercise, this.imageFile).subscribe(data => {
            let res = data['body']['exercise'];
            
            this.imagePath = this.exerciseService.getPicture(res['exerciseimage']);
            this.loadExercise();
        }, error => {
            this.errorMessage = 'Une erreur est survenue, veuillez vérifier les informations saisies.';
        });
    }

    editExercise(): void {
        this.exerciseService.updateExercise(this.currentExercise['id'], this.currentExercise, this.imageFile).subscribe(data => {
            let res = data['body']['exercise'];
            
            this.imagePath = this.exerciseService.getPicture(res['exerciseimage']);
            this.loadExercise();
        }, error => {
            this.errorMessage = 'Une erreur est survenue, veuillez vérifier les informations saisies.';
        });
    }

    confirmDelete(): void {
        this.exerciseService.deleteExercise(this.currentExercise['id']).subscribe(data => {
            this.loadExercise();
        }, error => {
            this.errorMessage = 'Une erreur est survenue, veuillez réessayer ultérieurement.';
        });
    }

    fileChangeEvent(fileInput: any) {
        if (fileInput.target.files && fileInput.target.files[0]) {
            const reader = new FileReader();

            reader.onload = (e: any) => {
                this.imageBase64 = e.target.result;
            };

            reader.readAsDataURL(fileInput.target.files[0]);
            this.imageFile = fileInput.target.files[0];
        }
    }

    removePicture(): void {
        this.imageBase64 = null; 
        this.imagePath = null; 
        this.imageFile = null;
    }
}
