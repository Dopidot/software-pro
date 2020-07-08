import { Component } from '@angular/core';

@Component({
  selector: 'ngx-footer',
  styleUrls: ['./footer.component.scss'],
  template: `
    <!--<span class="created-by">
      Created with ♥ by <b><a href="https://akveo.page.link/8V2f" target="_blank">Akveo</a></b> 2019
    </span>
    <div class="socials">
      <a href="#" target="_blank" class="ion ion-social-github"></a>
      <a href="#" target="_blank" class="ion ion-social-facebook"></a>
      <a href="#" target="_blank" class="ion ion-social-twitter"></a>
      <a href="#" target="_blank" class="ion ion-social-linkedin"></a>
    </div>-->
    <span class="created-by">
      <a href="mailto:contact@fitisly.com" target="_blank">contact@fitisly.com</a>
    </span>
    <span>2020 Fitisly. All rights reserved.</span>
  `,
})
export class FooterComponent {
}
