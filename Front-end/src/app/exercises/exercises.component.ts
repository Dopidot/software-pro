import { Component, OnInit } from '@angular/core';
import { MENU_ITEMS } from '../menu/menu';
import { LocalDataSource } from 'ng2-smart-table';

import { SmartTableData } from '../@core/data/smart-table';

@Component({
  selector: 'ngx-exercises',
  templateUrl: './exercises.component.html',
  styleUrls: ['./exercises.component.scss']
})
export class ExercisesComponent implements OnInit {

    menu = MENU_ITEMS;
    
    settings = {
        add: {
          addButtonContent: '<i class="nb-plus"></i>',
          createButtonContent: '<i class="nb-checkmark"></i>',
          cancelButtonContent: '<i class="nb-close"></i>',
        },
        edit: {
          editButtonContent: '<i class="nb-edit"></i>',
          saveButtonContent: '<i class="nb-checkmark"></i>',
          cancelButtonContent: '<i class="nb-close"></i>',
        },
        delete: {
          deleteButtonContent: '<i class="nb-trash"></i>',
          confirmDelete: true,
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
          repetition: {
            title: 'Repetition',
            type: 'number',
          },
          rest: {
            title: 'Rest time',
            type: 'number',
          }
        },
      };
    
      source: LocalDataSource = new LocalDataSource();
    
      constructor(private service: SmartTableData) {
        const data = [{
            id: 1,
            name: 'Pectoraux',
            description: 'On developpe les pecs',
            repetition: 2,
            rest: 10,
          }, {
            id: 2,
            name: 'Pompes',
            description: 'Développement des bras',
            repetition: 3,
            rest: 20,
          }];
        this.source.load(data);
      }

      ngOnInit(): void {
    }
    
      onDeleteConfirm(event): void {
        if (window.confirm('Are you sure you want to delete?')) {
          event.confirm.resolve();
        } else {
          event.confirm.reject();
        }
      }
  

}
