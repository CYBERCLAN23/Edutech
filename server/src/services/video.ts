import { chatCompletion } from './ai';

export interface VideoScript {
  title: string;
  subject: string;
  className: string;
  duration: string;
  scenes: {
    sceneNumber: number;
    visualDescription: string;
    narration: string;
    durationSeconds: number;
  }[];
  keyTakeaways: string[];
}

export async function generateVideoScript(
  topic: string,
  subject: string,
  className: string,
  duration: 'short' | 'medium' | 'long' = 'medium'
): Promise<VideoScript> {
  const durationMap = { short: '3-5', medium: '8-12', long: '15-20' };
  const durationStr = durationMap[duration];

  const prompt = `Tu es un créateur de contenu éducatif pour EduCam, plateforme éducative camerounaise.
Génère un script vidéo éducatif en français pour le sujet "${subject}" (classe ${className}).

SUJET: ${topic}
DURÉE: ${durationStr} minutes

Format de réponse JSON (uniquement du JSON valide):
{
  "title": "Titre accrocheur en français",
  "subject": "${subject}",
  "className": "${className}",
  "duration": "${durationStr} minutes",
  "scenes": [
    {
      "sceneNumber": 1,
      "visualDescription": "Description détaillée des visuels pour cette scène",
      "narration": "Texte narratif complet en français, clair et pédagogique",
      "durationSeconds": 60
    }
  ],
  "keyTakeaways": ["Point clé 1", "Point clé 2", "Point clé 3"]
}

Règles:
- Total des durées des scènes = ~${durationStr} minutes
- 1 scène d'introduction + 4-6 scènes de contenu + 1 scène de conclusion
- Langage adapté au niveau ${className}
- Inclure des exemples concrets du programme camerounais
- Maximum 300 tokens par scène de narration`;

  const result = await chatCompletion(
    [{ role: 'system', content: 'Tu génères des scripts vidéo éducatifs en JSON.' }, { role: 'user', content: prompt }],
    0.7,
    4000
  );

  try {
    const jsonMatch = result.match(/\{[\s\S]*\}/);
    if (!jsonMatch) throw new Error('No JSON found in response');
    return JSON.parse(jsonMatch[0]);
  } catch {
    return {
      title: topic,
      subject,
      className,
      duration: `${durationStr} minutes`,
      scenes: [
        {
          sceneNumber: 1,
          visualDescription: 'Introduction animée avec le logo EduCam',
          narration: `Bonjour et bienvenue dans ce cours sur ${topic}.`,
          durationSeconds: 30,
        },
        {
          sceneNumber: 2,
          visualDescription: `Présentation du concept ${topic}`,
          narration: `Aujourd'hui, nous allons étudier ${topic}.`,
          durationSeconds: 60,
        },
      ],
      keyTakeaways: [`Comprendre ${topic}`],
    };
  }
}

export async function generateEducationalVideo(
  topic: string,
  subject: string,
  className: string,
  duration: 'short' | 'medium' | 'long' = 'medium'
) {
  const script = await generateVideoScript(topic, subject, className, duration);

  const totalDuration = script.scenes.reduce((sum, s) => sum + s.durationSeconds, 0);

  const storyboard = script.scenes.map((scene) => ({
    scene: scene.sceneNumber,
    visual: scene.visualDescription,
    narration: scene.narration,
    duration: scene.durationSeconds,
    suggestedVisuals: suggestVisuals(scene.visualDescription),
  }));

  return {
    script,
    storyboard,
    totalDurationSeconds: totalDuration,
    estimatedMinutes: Math.round(totalDuration / 60),
    metadata: {
      generatedAt: new Date().toISOString(),
      topic,
      subject,
      className,
      model: 'openai/gpt-4o',
    },
  };
}

function suggestVisuals(visualDescription: string): string[] {
  const suggestions: string[] = [];
  if (visualDescription.toLowerCase().includes('formule') || visualDescription.toLowerCase().includes('équation')) {
    suggestions.push('Équations en LaTeX animées');
  }
  if (visualDescription.toLowerCase().includes('graphique') || visualDescription.toLowerCase().includes('courbe')) {
    suggestions.push('Graphiques interactifs (Chart.js)');
  }
  if (visualDescription.toLowerCase().includes('carte') || visualDescription.toLowerCase().includes('géographie')) {
    suggestions.push('Cartes interactives (Mapbox)');
  }
  if (visualDescription.toLowerCase().includes('schéma') || visualDescription.toLowerCase().includes('diagramme')) {
    suggestions.push('Diagrammes animés (Mermaid.js)');
  }
  suggestions.push('Texte incrusté avec animations CSS');
  suggestions.push('Image illustrative générée par IA');
  return suggestions;
}
