import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { InactivityComponent } from './inactivity.component';

describe('InactivityComponent', () => {
  let component: InactivityComponent;
  let fixture: ComponentFixture<InactivityComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ InactivityComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(InactivityComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
