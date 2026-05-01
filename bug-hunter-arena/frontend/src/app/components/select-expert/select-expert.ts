import { Component, OnInit, CUSTOM_ELEMENTS_SCHEMA, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { ApiService } from '../../services/api';

export const AVATARS = [
  { id: 'robot',  emoji: '🤖', label: 'Robot',   color: 'border-cyan-500   bg-cyan-500/10'   },
  { id: 'ninja',  emoji: '🥷', label: 'Ninja',   color: 'border-slate-500  bg-slate-500/10'  },
  { id: 'alien',  emoji: '👾', label: 'Alien',   color: 'border-green-500  bg-green-500/10'  },
  { id: 'hacker', emoji: '💻', label: 'Hacker',  color: 'border-purple-500 bg-purple-500/10' },
  { id: 'wizard', emoji: '🧙', label: 'Wizard',  color: 'border-yellow-500 bg-yellow-500/10' },
  { id: 'cyborg', emoji: '🦾', label: 'Cyborg',  color: 'border-red-500    bg-red-500/10'    },
];

@Component({
  selector: 'app-select-expert',
  standalone: true,
  imports: [CommonModule],
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
  templateUrl: './select-expert.html',
  styleUrls: ['./select-expert.css']
})
export class SelectExpertComponent implements OnInit {
  experts        = signal<any[]>([]);
  loading        = signal(true);
  step           = signal<'expert' | 'avatar' | 'spin'>('expert');
  selectedExpert = signal<any>(null);
  selectedAvatar = signal<string>('');
  saving         = signal(false);
  spinTech       = signal('');      // techno affichée pendant l'animation
  spinDone       = signal(false);   // animation terminée

  private spinInterval: any = null;
  readonly TECHS = ['PHP', 'ReactJS', 'C++', 'C#', 'Mobile'];
  readonly TECH_COLORS: Record<string, string> = {
    'PHP': 'text-cyan-400', 'ReactJS': 'text-blue-400',
    'C++': 'text-purple-400', 'C#': 'text-emerald-400', 'Mobile': 'text-orange-400'
  };

  readonly avatars = AVATARS;
  teamName: string = '';

  constructor(private apiService: ApiService, private router: Router) {}

  ngOnInit(): void {
    const teamData = localStorage.getItem('team_data');
    const teamId   = localStorage.getItem('team_id');

    if (!teamData || !teamId) {
      this.router.navigate(['/login']);
      return;
    }

    this.teamName = JSON.parse(teamData).name;

    this.apiService.getExperts(parseInt(teamId, 10)).subscribe({
      next: (data) => {
        this.experts.set(data);
        this.loading.set(false);
      },
      error: () => {
        this.loading.set(false);
      }
    });
  }

  // Étape 1 : choisir son expert → passer directement à l'avatar
  chooseExpert(expert: any): void {
    this.selectedExpert.set(expert);
    this.selectedAvatar.set(expert.avatar ?? 'robot');
    this.step.set('avatar');
  }

  // Étape 2 : choisir son avatar
  chooseAvatar(avatarId: string): void {
    this.selectedAvatar.set(avatarId);
  }

  // Confirmer : met à jour l'avatar puis charge un quiz de la techno de l'expert
  confirm(): void {
    const expert = this.selectedExpert();
    const avatar = this.selectedAvatar();
    if (!expert || !avatar) return;

    this.saving.set(true);

    this.apiService.updateAvatar(expert.id, avatar).subscribe({
      next: () => {
        // Sauvegarder l'expert actif
        localStorage.setItem('active_expert', JSON.stringify({
          id:            expert.id,
          pseudo:        expert.pseudo,
          avatar:        avatar,
          coins:         expert.coins,
          score:         expert.score,
          tech:          expert.tech_name,
          technology_id: expert.technology_id ?? null
        }));

        // Charger un quiz de la techno de l'expert (pas aléatoire)
        const techId = this.getTechId(expert.tech_name);
        this.apiService.getRandomQuiz(techId).subscribe({
          next: (quizData) => {
            localStorage.setItem('current_quiz', JSON.stringify(quizData));
            localStorage.setItem('current_tech_name', expert.tech_name ?? '');
            this.router.navigate(['/arena']);
          },
          error: () => {
            this.saving.set(false);
          }
        });
      },
      error: () => {
        this.saving.set(false);
      }
    });
  }

  // Mapping nom techno → id
  private getTechId(techName: string): number {
    const map: Record<string, number> = {
      'PHP': 1, 'ReactJS': 2, 'C++': 3, 'C#': 4, 'Mobile': 5
    };
    return map[techName] ?? 0; // 0 = aléatoire si inconnu
  }

  back(): void {
    if (this.step() === 'avatar') {
      this.step.set('expert');
    } else {
      this.router.navigate(['/team']);
    }
  }

  getAvatar(id: string) {
    return this.avatars.find(a => a.id === id) ?? this.avatars[0];
  }
}
