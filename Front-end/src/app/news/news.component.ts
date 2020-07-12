import { Component, OnInit, TemplateRef } from '@angular/core';
import { MenuService } from '../services/menu.service';
import { CommonService } from '../services/common.service';
import { DatePipe } from '@angular/common';
import { NbDialogService } from '@nebular/theme';
import { News } from '../models/news.model';

@Component({
    selector: 'ngx-news',
    templateUrl: './news.component.html',
    styleUrls: ['./news.component.scss']
})
export class NewsComponent implements OnInit {

    menu = [];
    news = [];
    tiny = 'tiny';
    success = 'success';
    danger = 'danger';
    primary = 'primary';
    errorMessage: string;
    currentNews: News = new News();
    popupType: number = 0;
    imageBase64: string;
    imagePath: string;
    imageFile: string;

    constructor(
        private menuService: MenuService,
        private commonService: CommonService,
        private datePipe: DatePipe,
        private dialogService: NbDialogService,
    ) { }

    ngOnInit(): void {
        this.menu = this.menuService.getMenu();
        this.loadNews();
    }

    selectNews(news): void {
        this.imagePath = null;
        this.imageBase64 = null;
        this.imageFile = null;
        this.currentNews = news;

        if (news['newsletterimage'])
        {
            this.imagePath = this.commonService.getPicture(news['newsletterimage']);
        }
    }

    loadNews(): void {
        this.commonService.getNews().subscribe(data => {
            this.news = data;
        });
    }

    addNews(): void {
        this.currentNews['creationDate'] = this.datePipe.transform(new Date(), 'yyyy-MM-dd');

        this.commonService.createNews(this.currentNews, this.imageFile).subscribe(data => {
            let res = data['body']['newsletter'];

            this.imagePath = this.commonService.getPicture(res['newsletterimage']);
            this.loadNews();
        });
    }

    updateNews(): void {
        this.commonService.updateNews(this.currentNews['id'], this.currentNews, this.imageFile).subscribe(data => {
            let res = data['body']['newsletter'];
            
            this.imagePath = this.commonService.getPicture(res['newsletterimage']);
            this.loadNews();
        });
    }

    removeNews(): void {
        this.commonService.deleteNews(this.currentNews['id']).subscribe(data => {
            this.currentNews = new News();
            this.loadNews();
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
