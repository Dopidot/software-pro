import { Component, OnInit, TemplateRef } from '@angular/core';
import { MenuService } from '../services/menu.service';
import { LocalDataSource } from 'ng2-smart-table';
import { CommonService } from '../services/common.service';
import { DatePipe } from '@angular/common';
import { NbDialogService } from '@nebular/theme';

import { ProgramService } from '../services/program.service';
import { Program } from '../models/program.model';

import * as _ from 'lodash';

@Component({
    selector: 'ngx-programs',
    templateUrl: './programs.component.html',
    styleUrls: ['./programs.component.scss']
})
export class ProgramsComponent implements OnInit {

    menu = [];
    programs = [];
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

    constructor(
        private menuService: MenuService,
        private commonService: CommonService,
        private datePipe: DatePipe,
        private dialogService: NbDialogService,
        private programService: ProgramService,
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

        if (program['programimage'])
        {
            this.imagePath = this.commonService.getPicture(program['programimage']);
        }
    }

    loadPrograms(): void {
        this.programService.getPrograms().subscribe(data => {
            this.programs = data;
            console.log(data);
        });
    }

    addProgram(): void {
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
