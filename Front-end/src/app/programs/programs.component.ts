import { Component, OnInit, TemplateRef } from '@angular/core';
import { MenuService } from '../services/menu.service';
import { LocalDataSource } from 'ng2-smart-table';
import { CommonService } from '../services/common.service';
import { DatePipe } from '@angular/common';
import { NbDialogService } from '@nebular/theme';

import { ProgramService } from '../services/program.service';
import { Program } from '../models/program.model';
import { ExerciseService } from '../services/exercise.service';


import * as _ from 'lodash';

@Component({
    selector: 'ngx-programs',
    templateUrl: './programs.component.html',
    styleUrls: ['./programs.component.scss']
})
export class ProgramsComponent implements OnInit {

    menu = [];
    programs = [];
    data = [];
    exercisesList = [];
    tiny = 'tiny';
    success = 'success';
    danger = 'danger';
    primary = 'primary';
    errorMessage: string;
    currentProgram: Program = new Program();
    popupType: number = 0;
    imageBase64: string;
    imagePath: string;
    imageFile: string;
    source: LocalDataSource = new LocalDataSource();

    settings = {
        pager: {
            display: true,
            perPage: 4
        },
        actions: {
            custom: [
                {
                    name: 'add',
                    title: '<i class="fas fa-plus fa-xs"></i>',
                },
            ],
            add: false,
            edit: false,
            delete: false,
        },
        columns: {
            name: {
                title: 'Nom',
                type: 'string',
            },
        },
    };

    constructor(
        private menuService: MenuService,
        private commonService: CommonService,
        private datePipe: DatePipe,
        private dialogService: NbDialogService,
        private programService: ProgramService,
        private exerciseService: ExerciseService,
    ) { }

    ngOnInit(): void {
        this.menu = this.menuService.getMenu();
        this.loadPrograms();
    }

    selectProgram(program): void {
        this.imagePath = null;
        this.imageBase64 = null;
        this.imageFile = null;
        this.currentProgram = program;

        if (program['programImage'])
        {
            this.imagePath = this.commonService.getPicture(program['programImage']);
        }

        this.loadAllExercises();
    }

    loadPrograms(): void {
        this.programService.getPrograms().subscribe(data => {
            this.programs = data;
            console.log(data);
        });
    }

    loadAllExercises(): void {
        this.data = [];
        
        this.exerciseService.getExercises().subscribe(data => {
            this.data = data;
            this.source.load(this.data);

            this.loadExercises(this.currentProgram);
        });
    }

    loadExercises(program): void {
        this.exercisesList = [];

        program.exercises.forEach(element => {
            this.exerciseService.getExerciseById(element['idexercise']).subscribe(data => {
                this.exercisesList.push(data);

                let index = this.data.findIndex(x => x['id'] === data['id']);

                if (index !== -1)
                {
                    this.data.splice(index, 1);
                    this.source.load(this.data);
                }
            });
        });
    } 

    addProgram(): void {
        this.currentProgram.exercises = '3,4';
        this.programService.createProgram(this.currentProgram, this.imageFile).subscribe(data => {
            let res = data['body']['program'];

            if (res['programimage'])
            {
                this.imagePath = this.commonService.getPicture(res['programimage']);
            }
            this.loadPrograms();
        });
    }

    updateProgram(): void {
        console.log(this.imageFile);
        this.programService.updateProgram(this.currentProgram['id'], this.currentProgram, this.imageFile).subscribe(data => {
            let res = data['body']['program'];
            
            if (res['programimage'])
            {
                this.imagePath = this.commonService.getPicture(res['programimage']);
            }
            this.loadPrograms();
        });
    }

    removeProgram(): void {
        this.programService.deleteProgram(this.currentProgram['id']).subscribe(data => {
            this.currentProgram = new Program();
            this.loadPrograms();
        });
    }

    openPopup(dialog: TemplateRef<any>): void {
        this.dialogService.open(
            dialog
        );
    }

    addExercise(event: any): void {
        this.exercisesList.push(event['data']);
    }

    removeExercise(exercise: any): void {
        let index = this.exercisesList.findIndex(x => x['id'] === exercise['id']);

        if (index !== -1)
        {
            this.exercisesList.splice(index, 1);

            //this.updateProgram();
            this.loadAllExercises();
        }
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
