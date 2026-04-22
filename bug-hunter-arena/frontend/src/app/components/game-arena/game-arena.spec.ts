import { ComponentFixture, TestBed } from '@angular/core/testing';

import { GameArena } from './game-arena';

describe('GameArena', () => {
  let component: GameArena;
  let fixture: ComponentFixture<GameArena>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [GameArena],
    }).compileComponents();

    fixture = TestBed.createComponent(GameArena);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
