import { Component, OnInit, OnDestroy, CUSTOM_ELEMENTS_SCHEMA, signal, computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { ApiService } from '../../services/api';
import { SoundService } from '../../services/sound.service';
import { AVATARS } from '../select-expert/select-expert';

const TOTAL_QUESTIONS = 10;

@Component({
  selector: 'app-game-arena',
  standalone: true,
  imports: [CommonModule],
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
  templateUrl: './game-arena.html',
  styleUrls: ['./game-arena.css']
})
export class GameArenaComponent implements OnInit, OnDestroy {

  // ── Signals (réactivité garantie) ────────────────────────────────────────
  loading         = signal(true);
  quizId          = signal(0);
  description     = signal('');
  code            = signal('');
  answers         = signal<any[]>([]);
  techName        = signal('');
  answered        = signal(false);
  selectedId      = signal<number | null>(null);
  message         = signal('');
  messageOk       = signal(false);
  timeLeft        = signal(30);
  sessionScore    = signal(0);
  questionsAnswered = signal(0);
  correctAnswers  = signal(0);
  totalScore      = signal(0);

  // ── Expert actif ─────────────────────────────────────────────────────────
  expertName   = signal('');
  expertAvatar = signal('🤖');
  expertCoins  = signal(0);
  expertId     = signal(0);
  hint         = signal('');
  hintLoading  = signal(false);

  // ── Propriétés simples ───────────────────────────────────────────────────
  teamName: string = '';
  teamId: number = 0;
  expertTechId: number = 0;
  private seenQuizIds: number[] = []; // anti-doublons
  readonly totalQuestions = TOTAL_QUESTIONS;

  // ── Computed ─────────────────────────────────────────────────────────────
  progressPercent = computed(() =>
    Math.round((this.questionsAnswered() / TOTAL_QUESTIONS) * 100)
  );

  timerColor = computed(() => {
    const t = this.timeLeft();
    if (t > 15) return 'text-green-400';
    if (t > 7)  return 'text-yellow-400';
    return 'text-red-400 animate-pulse';
  });

  private timerInterval: any = null;

  constructor(private apiService: ApiService, private router: Router, private sound: SoundService) {}

  ngOnInit(): void {
    const savedTeam = localStorage.getItem('team_data');
    const savedId   = localStorage.getItem('team_id');

    if (!savedTeam || !savedId) {
      this.router.navigate(['/login']);
      return;
    }

    const team = JSON.parse(savedTeam);
    this.teamName = team.name ?? '';
    this.totalScore.set(Number(team.score) || 0);
    this.teamId = parseInt(savedId, 10);

    // Charger l'expert actif sélectionné
    const activeExpert = localStorage.getItem('active_expert');
    if (activeExpert) {
      const exp = JSON.parse(activeExpert);
      this.expertName.set(exp.pseudo ?? '');
      this.expertId.set(exp.id ?? 0);
      this.expertCoins.set(exp.coins ?? 0);
      // Mapping techno → id pour filtrer les quiz
      const techMap: Record<string, number> = {
        'PHP': 1, 'ReactJS': 2, 'C++': 3, 'C#': 4, 'Mobile': 5
      };
      this.expertTechId = techMap[exp.tech] ?? 0;
      const av = AVATARS.find((a: any) => a.id === exp.avatar);
      this.expertAvatar.set(av ? av.emoji : '🤖');
    }
    // Restaurer stats de session si on revient
    const stats = localStorage.getItem('session_stats');
    if (stats) {
      const s = JSON.parse(stats);
      this.sessionScore.set(s.sessionScore ?? 0);
      this.questionsAnswered.set(s.questionsAnswered ?? 0);
      this.correctAnswers.set(s.correctAnswers ?? 0);
    }

    // Charger le quiz stocké par spinWheel() ou en charger un nouveau
    const savedQuiz = localStorage.getItem('current_quiz');
    if (savedQuiz) {
      this.applyQuiz(JSON.parse(savedQuiz));
    } else {
      this.fetchQuiz();
    }
  }

  ngOnDestroy(): void {
    this.stopTimer();
  }

  // ── Quiz ─────────────────────────────────────────────────────────────────

  private applyQuiz(data: any): void {
    this.quizId.set(data.id);
    this.description.set(data.description ?? data.bug_description ?? '');
    this.code.set(data.code ?? data.code_snippet ?? '');
    this.answers.set(Array.isArray(data.answers) ? [...data.answers] : []);
    this.techName.set(data.tech_name ?? localStorage.getItem('current_tech_name') ?? '');
    this.answered.set(false);
    this.selectedId.set(null);
    this.message.set('');
    this.hint.set('');
    this.loading.set(false);
    // Marquer ce quiz comme vu
    if (data.id && !this.seenQuizIds.includes(data.id)) {
      this.seenQuizIds.push(data.id);
    }
    this.startTimer();
  }

  private fetchQuiz(): void {
    this.loading.set(true);
    this.stopTimer();
    this.hint.set('');
    const techId = this.expertTechId || undefined;
    this.apiService.getRandomQuiz(techId, this.seenQuizIds).subscribe({
      next: (data: any) => {
        localStorage.setItem('current_quiz', JSON.stringify(data));
        this.applyQuiz(data);
      },
      error: () => {
        this.loading.set(false);
        this.message.set('Impossible de charger un quiz.');
      }
    });
  }

  // ── Chrono ───────────────────────────────────────────────────────────────

  private startTimer(): void {
    this.stopTimer();
    this.timeLeft.set(30);
    this.timerInterval = setInterval(() => {
      const current = this.timeLeft();
      if (current <= 1) {
        this.stopTimer();
        if (!this.answered()) this.onTimeout();
      } else {
        this.timeLeft.set(current - 1);
        // Tick sonore dans les 10 dernières secondes
        if (current - 1 <= 10) this.sound.playTick();
      }
    }, 1000);
  }

  private stopTimer(): void {
    if (this.timerInterval) {
      clearInterval(this.timerInterval);
      this.timerInterval = null;
    }
  }

  private onTimeout(): void {
    this.answered.set(true);
    this.messageOk.set(false);
    this.message.set('⏱ Temps écoulé !');
    this.sound.playTimeout();
    this.questionsAnswered.update(n => n + 1);
    this.saveStats();
    setTimeout(() => { this.message.set(''); this.nextQuestion(); }, 1500);
  }

  // ── Validation ───────────────────────────────────────────────────────────

  validate(answerId: number): void {
    if (this.answered() || !this.quizId() || !this.teamId) return;

    this.answered.set(true);
    this.selectedId.set(answerId);
    this.stopTimer();

    this.apiService.validateAnswer(this.quizId(), answerId, this.teamId, this.teamName, this.expertId()).subscribe({
      next: (res: any) => {
        const correct = !!res.correct;
        this.messageOk.set(correct);
        this.message.set(correct ? '✅ BRAVO ! Bug corrigé. +10 pts' : "❌ ÉCHEC ! L'anomalie persiste.");
        correct ? this.sound.playCorrect() : this.sound.playWrong();
        this.questionsAnswered.update(n => n + 1);

        if (correct) {
          this.correctAnswers.update(n => n + 1);
          this.sessionScore.update(n => n + 10);
          this.totalScore.update(n => n + 10);
          // Créditer les coins ET le score de l'expert
          this.expertCoins.update(n => n + 10);

          const saved = localStorage.getItem('team_data');
          if (saved) {
            const t = JSON.parse(saved);
            t.score = this.totalScore();
            localStorage.setItem('team_data', JSON.stringify(t));
          }
          // Mettre à jour coins ET score de l'expert en localStorage
          const ae = localStorage.getItem('active_expert');
          if (ae) {
            const e = JSON.parse(ae);
            e.coins = (e.coins ?? 0) + 10;
            e.score = (e.score ?? 0) + 10;
            localStorage.setItem('active_expert', JSON.stringify(e));
          }
        }

        this.saveStats();

        setTimeout(() => {
          this.message.set('');
          this.nextQuestion();
        }, 1500);
      },
      error: () => {
        this.answered.set(false);
        this.message.set('Erreur serveur, réessaie.');
        this.messageOk.set(false);
        setTimeout(() => this.message.set(''), 2000);
      }
    });
  }

  // ── Indice ───────────────────────────────────────────────────────────────

  buyHint(): void {
    if (this.hintLoading() || this.answered() || !this.expertId()) return;
    this.hintLoading.set(true);

    this.apiService.buyHint(this.expertId(), this.quizId()).subscribe({
      next: (res: any) => {
        this.hint.set(res.hint);
        this.expertCoins.set(res.coins_left);
        this.sound.playCoin();
        // Mettre à jour localStorage
        const ae = localStorage.getItem('active_expert');
        if (ae) {
          const e = JSON.parse(ae);
          e.coins = res.coins_left;
          localStorage.setItem('active_expert', JSON.stringify(e));
        }
        this.hintLoading.set(false);
      },
      error: (err: any) => {
        this.hint.set(err.error?.error ?? 'Coins insuffisants (5 coins requis)');
        this.hintLoading.set(false);
      }
    });
  }

  // ── Navigation ───────────────────────────────────────────────────────────

  private nextQuestion(): void {
    if (this.questionsAnswered() >= TOTAL_QUESTIONS) {
      this.router.navigate(['/results']);
      return;
    }
    localStorage.removeItem('current_quiz');
    this.fetchQuiz();
  }

  private saveStats(): void {
    localStorage.setItem('session_stats', JSON.stringify({
      sessionScore:      this.sessionScore(),
      questionsAnswered: this.questionsAnswered(),
      correctAnswers:    this.correctAnswers(),
      wrongAnswers:      this.wrongAnswers
    }));
  }

  // Stockage des questions ratées pour le récap
  private wrongAnswers: Array<{description: string, code: string, correctAnswer: string}> = [];
}
