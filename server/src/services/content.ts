import { chatCompletion } from './ai';

export interface GeneratedLesson {
  title: string;
  objectives: string[];
  content: string;
  summary: string;
}

export interface GeneratedExercise {
  title: string;
  instructions: string;
  questions: { text: string; points: number }[];
}

export interface GeneratedQuiz {
  title: string;
  timeLimitMinutes: number;
  questions: { text: string; options: string[]; correctIndex: number }[];
}

export async function generateLesson(
  topic: string,
  subject: string,
  className: string
): Promise<GeneratedLesson> {
  const prompt = `Génère un plan de leçon détaillé en français pour "${topic}" (${subject}, ${className}).

Format JSON:
{
  "title": "Titre de la leçon",
  "objectives": ["Objectif 1", "Objectif 2", "Objectif 3"],
  "content": "Contenu complet de la leçon avec explications, exemples du programme camerounais, et points clés. Minimum 500 mots.",
  "summary": "Résumé en 3-4 phrases"
}`;

  const result = await chatCompletion(
    [{ role: 'system', content: 'Tu génères du contenu éducatif en français.' }, { role: 'user', content: prompt }],
    0.7,
    3000
  );

  try {
    const jsonMatch = result.match(/\{[\s\S]*\}/);
    if (!jsonMatch) throw new Error('No JSON found');
    return JSON.parse(jsonMatch[0]);
  } catch {
    return {
      title: topic,
      objectives: [`Comprendre les concepts clés de ${topic}`],
      content: `Contenu de la leçon sur ${topic} adapté au programme ${className}.`,
      summary: `Cette leçon couvre ${topic} pour la classe ${className}.`,
    };
  }
}

export async function generateExercises(
  topic: string,
  subject: string,
  numQuestions: number = 5
): Promise<GeneratedExercise> {
  const prompt = `Génère ${numQuestions} questions d'exercice sur "${topic}" (${subject}).

Format JSON:
{
  "title": "Exercice sur ${topic}",
  "instructions": "Consignes claires pour l'élève",
  "questions": [
    {"text": "Question 1?", "points": 2}
  ]
}

Règles:
- Questions progressives (facile → difficile)
- Adapté au programme camerounais
- Points totaux = ${numQuestions * 2}`;

  const result = await chatCompletion(
    [{ role: 'system', content: 'Tu génères des exercices éducatifs en français.' }, { role: 'user', content: prompt }],
    0.7,
    2000
  );

  try {
    const jsonMatch = result.match(/\{[\s\S]*\}/);
    if (!jsonMatch) throw new Error('No JSON found');
    return JSON.parse(jsonMatch[0]);
  } catch {
    return {
      title: `Exercice sur ${topic}`,
      instructions: `Réponds aux questions suivantes sur ${topic}.`,
      questions: Array.from({ length: numQuestions }, (_, i) => ({
        text: `Question ${i + 1} sur ${topic}?`,
        points: 2,
      })),
    };
  }
}

export async function generateQuiz(
  topic: string,
  subject: string,
  numQuestions: number = 10
): Promise<GeneratedQuiz> {
  const prompt = `Génère un QCM de ${numQuestions} questions sur "${topic}" (${subject}).

Format JSON:
{
  "title": "Quiz: ${topic}",
  "timeLimitMinutes": ${numQuestions * 2},
  "questions": [
    {
      "text": "Question?",
      "options": ["A) Option 1", "B) Option 2", "C) Option 3", "D) Option 4"],
      "correctIndex": 0
    }
  ]
}

Règles:
- 4 options par question (A, B, C, D)
- Une seule bonne réponse
- Adapté au programme camerounais`;

  const result = await chatCompletion(
    [{ role: 'system', content: 'Tu génères des QCM éducatifs en français.' }, { role: 'user', content: prompt }],
    0.7,
    3000
  );

  try {
    const jsonMatch = result.match(/\{[\s\S]*\}/);
    if (!jsonMatch) throw new Error('No JSON found');
    return JSON.parse(jsonMatch[0]);
  } catch {
    return {
      title: `Quiz: ${topic}`,
      timeLimitMinutes: numQuestions * 2,
      questions: Array.from({ length: numQuestions }, (_, i) => ({
        text: `Question ${i + 1} sur ${topic}?`,
        options: ['A) Option 1', 'B) Option 2', 'C) Option 3', 'D) Option 4'],
        correctIndex: 0,
      })),
    };
  }
}

export async function generateRecommendation(
  studentName: string,
  subject: string,
  average: number,
  recentScores: number[]
): Promise<string> {
  const prompt = `Élève: ${studentName}, Matière: ${subject}, Moyenne: ${average}/20, Dernières notes: [${recentScores.join(', ')}].

Génère une recommandation pédagogique personnalisée en français (3-4 phrases).
Sois précis et actionable. Inclus des conseils d'étude spécifiques.`;

  return chatCompletion(
    [{ role: 'system', content: 'Tu es un conseiller pédagogique.' }, { role: 'user', content: prompt }],
    0.7,
    500
  );
}

export async function correctCopy(
  text: string,
  subject: string
): Promise<{
  corrections: { original: string; correction: string; explanation: string }[];
  score: number;
  totalPoints: number;
  feedback: string;
  praises: string[];
}> {
  const prompt = `Corrige cette copie d'élève en ${subject}.

TEXTE: "${text}"

Analyse:
1. Erreurs (orthographe, grammaire, contenu)
2. Note sur 20
3. Feedback constructif
4. Points positifs

Format JSON:
{
  "corrections": [{"original": "texte erroné", "correction": "texte corrigé", "explanation": "explication"}],
  "score": 14,
  "totalPoints": 20,
  "feedback": "Feedback global en français",
  "praises": ["Point fort 1", "Point fort 2"]
}`;

  const result = await chatCompletion(
    [{ role: 'system', content: 'Tu es un correcteur pédagogique exigeant mais encourageant.' }, { role: 'user', content: prompt }],
    0.5,
    2000
  );

  try {
    const jsonMatch = result.match(/\{[\s\S]*\}/);
    if (!jsonMatch) throw new Error('No JSON found');
    return JSON.parse(jsonMatch[0]);
  } catch {
    return {
      corrections: [{ original: text, correction: text, explanation: 'Analyse en cours...' }],
      score: 10,
      totalPoints: 20,
      feedback: 'Correction générée automatiquement.',
      praises: ['Travail en cours d\'analyse'],
    };
  }
}
