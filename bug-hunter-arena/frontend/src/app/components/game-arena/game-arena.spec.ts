import { ComponentFixture, TestBed } from '@angular/core/testing';

import { GameArenaComponent } from './game-arena';

describe('GameArena', () => {
  let component: GameArenaComponent;
  let fixture: ComponentFixture<GameArenaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [GameArenaComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(GameArenaComponent);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
